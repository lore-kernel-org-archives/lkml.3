Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaLHIvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaLHIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:51:35 -0500
From: Amos Kong <akong@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, herbert@gondor.apana.org.au,
        rusty@rustcorp.com.au, kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v5 REPOST 3/6] hw_random: use reference counts on each struct hwrng.
Date: Mon,  8 Dec 2014 16:50:37 +0800
Message-Id: <1418028640-4891-4-git-send-email-akong@redhat.com>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

current_rng holds one reference, and we bump it every time we want
to do a read from it.

This means we only hold the rng_mutex to grab or drop a reference,
so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
block on read of /dev/hwrng.

Using a kref is overkill (we're always under the rng_mutex), but
a standard pattern.

This also solves the problem that the hwrng_fillfn thread was
accessing current_rng without a lock, which could change (eg. to NULL)
underneath it.

v5: drop redundant kref_init()
v4: decrease last reference for triggering the cleanup
v3: initialize kref (thanks Amos Kong)
v2: fix missing put_rng() on exit path (thanks Amos Kong)
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 135 ++++++++++++++++++++++++++++--------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 94 insertions(+), 43 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a0905c8..83516cb 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -42,6 +42,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/err.h>
 #include <asm/uaccess.h>
 
 
@@ -91,6 +92,60 @@ static void add_early_randomness(struct hwrng *rng)
 		add_device_randomness(bytes, bytes_read);
 }
 
+static inline void cleanup_rng(struct kref *kref)
+{
+	struct hwrng *rng = container_of(kref, struct hwrng, ref);
+
+	if (rng->cleanup)
+		rng->cleanup(rng);
+}
+
+static void set_current_rng(struct hwrng *rng)
+{
+	BUG_ON(!mutex_is_locked(&rng_mutex));
+	kref_get(&rng->ref);
+	current_rng = rng;
+}
+
+static void drop_current_rng(void)
+{
+	BUG_ON(!mutex_is_locked(&rng_mutex));
+	if (!current_rng)
+		return;
+
+	/* decrease last reference for triggering the cleanup */
+	kref_put(&current_rng->ref, cleanup_rng);
+	current_rng = NULL;
+}
+
+/* Returns ERR_PTR(), NULL or refcounted hwrng */
+static struct hwrng *get_current_rng(void)
+{
+	struct hwrng *rng;
+
+	if (mutex_lock_interruptible(&rng_mutex))
+		return ERR_PTR(-ERESTARTSYS);
+
+	rng = current_rng;
+	if (rng)
+		kref_get(&rng->ref);
+
+	mutex_unlock(&rng_mutex);
+	return rng;
+}
+
+static void put_rng(struct hwrng *rng)
+{
+	/*
+	 * Hold rng_mutex here so we serialize in case they set_current_rng
+	 * on rng again immediately.
+	 */
+	mutex_lock(&rng_mutex);
+	if (rng)
+		kref_put(&rng->ref, cleanup_rng);
+	mutex_unlock(&rng_mutex);
+}
+
 static inline int hwrng_init(struct hwrng *rng)
 {
 	if (rng->init) {
@@ -113,12 +168,6 @@ static inline int hwrng_init(struct hwrng *rng)
 	return 0;
 }
 
-static inline void hwrng_cleanup(struct hwrng *rng)
-{
-	if (rng && rng->cleanup)
-		rng->cleanup(rng);
-}
-
 static int rng_dev_open(struct inode *inode, struct file *filp)
 {
 	/* enforce read-only access to this chrdev */
@@ -154,21 +203,22 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	ssize_t ret = 0;
 	int err = 0;
 	int bytes_read, len;
+	struct hwrng *rng;
 
 	while (size) {
-		if (mutex_lock_interruptible(&rng_mutex)) {
-			err = -ERESTARTSYS;
+		rng = get_current_rng();
+		if (IS_ERR(rng)) {
+			err = PTR_ERR(rng);
 			goto out;
 		}
-
-		if (!current_rng) {
+		if (!rng) {
 			err = -ENODEV;
-			goto out_unlock;
+			goto out;
 		}
 
 		mutex_lock(&reading_mutex);
 		if (!data_avail) {
-			bytes_read = rng_get_data(current_rng, rng_buffer,
+			bytes_read = rng_get_data(rng, rng_buffer,
 				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
 			if (bytes_read < 0) {
@@ -200,8 +250,8 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			ret += len;
 		}
 
-		mutex_unlock(&rng_mutex);
 		mutex_unlock(&reading_mutex);
+		put_rng(rng);
 
 		if (need_resched())
 			schedule_timeout_interruptible(1);
@@ -213,12 +263,11 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	}
 out:
 	return ret ? : err;
-out_unlock:
-	mutex_unlock(&rng_mutex);
-	goto out;
+
 out_unlock_reading:
 	mutex_unlock(&reading_mutex);
-	goto out_unlock;
+	put_rng(rng);
+	goto out;
 }
 
 
@@ -257,8 +306,8 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 			err = hwrng_init(rng);
 			if (err)
 				break;
-			hwrng_cleanup(current_rng);
-			current_rng = rng;
+			drop_current_rng();
+			set_current_rng(rng);
 			err = 0;
 			break;
 		}
@@ -272,17 +321,15 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
-	int err;
 	ssize_t ret;
-	const char *name = "none";
+	struct hwrng *rng;
 
-	err = mutex_lock_interruptible(&rng_mutex);
-	if (err)
-		return -ERESTARTSYS;
-	if (current_rng)
-		name = current_rng->name;
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
-	mutex_unlock(&rng_mutex);
+	rng = get_current_rng();
+	if (IS_ERR(rng))
+		return PTR_ERR(rng);
+
+	ret = snprintf(buf, PAGE_SIZE, "%s\n", rng ? rng->name : "none");
+	put_rng(rng);
 
 	return ret;
 }
@@ -357,12 +404,16 @@ static int hwrng_fillfn(void *unused)
 	long rc;
 
 	while (!kthread_should_stop()) {
-		if (!current_rng)
+		struct hwrng *rng;
+
+		rng = get_current_rng();
+		if (IS_ERR(rng) || !rng)
 			break;
 		mutex_lock(&reading_mutex);
-		rc = rng_get_data(current_rng, rng_fillbuf,
+		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
 		mutex_unlock(&reading_mutex);
+		put_rng(rng);
 		if (rc <= 0) {
 			pr_warn("hwrng: no data available\n");
 			msleep_interruptible(10000);
@@ -423,14 +474,13 @@ int hwrng_register(struct hwrng *rng)
 		err = hwrng_init(rng);
 		if (err)
 			goto out_unlock;
-		current_rng = rng;
+		set_current_rng(rng);
 	}
 	err = 0;
 	if (!old_rng) {
 		err = register_miscdev();
 		if (err) {
-			hwrng_cleanup(rng);
-			current_rng = NULL;
+			drop_current_rng();
 			goto out_unlock;
 		}
 	}
@@ -457,22 +507,21 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
-	int err;
-
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
 	if (current_rng == rng) {
-		hwrng_cleanup(rng);
-		if (list_empty(&rng_list)) {
-			current_rng = NULL;
-		} else {
-			current_rng = list_entry(rng_list.prev, struct hwrng, list);
-			err = hwrng_init(current_rng);
-			if (err)
-				current_rng = NULL;
+		drop_current_rng();
+		if (!list_empty(&rng_list)) {
+			struct hwrng *tail;
+
+			tail = list_entry(rng_list.prev, struct hwrng, list);
+
+			if (hwrng_init(tail) == 0)
+				set_current_rng(tail);
 		}
 	}
+
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
 		unregister_miscdev();
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 914bb08..c212e71 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/kref.h>
 
 /**
  * struct hwrng - Hardware Random Number Generator driver
@@ -44,6 +45,7 @@ struct hwrng {
 
 	/* internal. */
 	struct list_head list;
+	struct kref ref;
 };
 
 /** Register a new Hardware Random Number Generator driver. */
-- 
1.9.3

