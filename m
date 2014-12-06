Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLFEQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaLFEQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:16:44 -0500
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au
Cc: kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: [PATCH v5 1/6] hw_random: place mutex around read functions and buffers.
Date: Sat,  6 Dec 2014 12:16:37 +0800
Message-Id: <1417839402-13490-2-git-send-email-akong@redhat.com>
In-Reply-To: <1417839402-13490-1-git-send-email-akong@redhat.com>
References: <1417839402-13490-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

There's currently a big lock around everything, and it means that we
can't query sysfs (eg /sys/devices/virtual/misc/hw_random/rng_current)
while the rng is reading.  This is a real problem when the rng is slow,
or blocked (eg. virtio_rng with qemu's default /dev/random backend)

This doesn't help (it leaves the current lock untouched), just adds a
lock to protect the read function and the static buffers, in preparation
for transition.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aa30a25..b1b6042 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -53,7 +53,10 @@
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
+/* Protects rng_list and current_rng */
 static DEFINE_MUTEX(rng_mutex);
+/* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
+static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
 static unsigned short current_quality;
@@ -81,7 +84,9 @@ static void add_early_randomness(struct hwrng *rng)
 	unsigned char bytes[16];
 	int bytes_read;
 
+	mutex_lock(&reading_mutex);
 	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
 }
@@ -128,6 +133,7 @@ static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 			int wait) {
 	int present;
 
+	BUG_ON(!mutex_is_locked(&reading_mutex));
 	if (rng->read)
 		return rng->read(rng, (void *)buffer, size, wait);
 
@@ -160,13 +166,14 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out_unlock;
 		}
 
+		mutex_lock(&reading_mutex);
 		if (!data_avail) {
 			bytes_read = rng_get_data(current_rng, rng_buffer,
 				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
 			if (bytes_read < 0) {
 				err = bytes_read;
-				goto out_unlock;
+				goto out_unlock_reading;
 			}
 			data_avail = bytes_read;
 		}
@@ -174,7 +181,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 		if (!data_avail) {
 			if (filp->f_flags & O_NONBLOCK) {
 				err = -EAGAIN;
-				goto out_unlock;
+				goto out_unlock_reading;
 			}
 		} else {
 			len = data_avail;
@@ -186,7 +193,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			if (copy_to_user(buf + ret, rng_buffer + data_avail,
 								len)) {
 				err = -EFAULT;
-				goto out_unlock;
+				goto out_unlock_reading;
 			}
 
 			size -= len;
@@ -194,6 +201,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 		}
 
 		mutex_unlock(&rng_mutex);
+		mutex_unlock(&reading_mutex);
 
 		if (need_resched())
 			schedule_timeout_interruptible(1);
@@ -208,6 +216,9 @@ out:
 out_unlock:
 	mutex_unlock(&rng_mutex);
 	goto out;
+out_unlock_reading:
+	mutex_unlock(&reading_mutex);
+	goto out_unlock;
 }
 
 
@@ -348,13 +359,16 @@ static int hwrng_fillfn(void *unused)
 	while (!kthread_should_stop()) {
 		if (!current_rng)
 			break;
+		mutex_lock(&reading_mutex);
 		rc = rng_get_data(current_rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
+		mutex_unlock(&reading_mutex);
 		if (rc <= 0) {
 			pr_warn("hwrng: no data available\n");
 			msleep_interruptible(10000);
 			continue;
 		}
+		/* Outside lock, sure, but y'know: randomness. */
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
 					   rc * current_quality * 8 >> 10);
 	}
-- 
1.9.3

