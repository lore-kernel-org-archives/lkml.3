Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaJTAeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:34:46 -0400
Received: from ozlabs.org ([103.22.144.67]:51483 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaJTAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org
Cc: herbert@gondor.apana.org.au, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH v2 3/6] hw_random: use reference counts on each struct hwrng.
In-Reply-To: <20140918170813.GA30440@air.redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com> <1411043867-21109-4-git-send-email-akong@redhat.com> <20140918170813.GA30440@air.redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 10:42:11 +1030
Message-ID: <871tq3a9b8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong <akong@redhat.com> writes:
> We got a warning in boot stage when above set_current_rng() is executed,
> it can be fixed by init rng->ref in hwrng_init().
>
>
> @@ -166,6 +169,8 @@ static inline int hwrng_init(struct hwrng *rng)
>         if (current_quality > 0 && !hwrng_fill)
>                 start_khwrngd();
>  
> +       kref_init(&rng->ref);
> +
>         return 0;
>  }

OK, I folded this fix on.

Thanks,
Rusty.

hw_random: use reference counts on each struct hwrng.

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

v3: initialize kref (thanks Amos Kong)
v2: fix missing put_rng() on exit path (thanks Amos Kong)
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a0905c818e13..0ecac38da954 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -42,6 +42,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/err.h>
 #include <asm/uaccess.h>
 
 
@@ -91,6 +92,59 @@ static void add_early_randomness(struct hwrng *rng)
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
@@ -110,13 +164,9 @@ static inline int hwrng_init(struct hwrng *rng)
 	if (current_quality > 0 && !hwrng_fill)
 		start_khwrngd();
 
-	return 0;
-}
+	kref_init(&rng->ref);
 
-static inline void hwrng_cleanup(struct hwrng *rng)
-{
-	if (rng && rng->cleanup)
-		rng->cleanup(rng);
+	return 0;
 }
 
 static int rng_dev_open(struct inode *inode, struct file *filp)
@@ -154,21 +204,22 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
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
@@ -200,8 +251,8 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			ret += len;
 		}
 
-		mutex_unlock(&rng_mutex);
 		mutex_unlock(&reading_mutex);
+		put_rng(rng);
 
 		if (need_resched())
 			schedule_timeout_interruptible(1);
@@ -213,12 +264,11 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
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
 
 
@@ -257,8 +307,8 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
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
@@ -272,17 +322,15 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
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
@@ -357,12 +405,16 @@ static int hwrng_fillfn(void *unused)
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
@@ -423,14 +475,13 @@ int hwrng_register(struct hwrng *rng)
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
@@ -457,22 +508,21 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
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
index 914bb08cd738..c212e71ea886 100644
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
