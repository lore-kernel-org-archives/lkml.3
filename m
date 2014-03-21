Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376AbaCUOds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:33:48 -0400
Received: from verein.lst.de ([213.95.11.211]:40354 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaCUOdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:33:45 -0400
Date: Fri, 21 Mar 2014 15:33:42 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2 02/03]: hwrng: create filler thread
Message-ID: <20140321143342.GK1763@lst.de>
References: <20140321142950.GI1763@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321142950.GI1763@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be viewed as the in-kernel equivalent of hwrngd;
like FUSE it is a good thing to have a mechanism in user land,
but for some reasons (simplicity, secrecy, integrity, speed)
it may be better to have it in kernel space.

This patch creates a thread once a hwrng registers, and uses
the previously established add_hwgenerator_randomness() to feed
its data to the input pool as long as needed. A derating factor
is used to bias the entropy estimation and to disable this
mechanism entirely when set to zero.

Signed-off-by: Torsten Duwe <duwe@suse.de>

---
 drivers/char/hw_random/core.c |   65 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 3 deletions(-)

--- linux/drivers/char/hw_random/core.c.orig
+++ linux/drivers/char/hw_random/core.c
@@ -39,6 +39,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -50,10 +51,18 @@
 
 
 static struct hwrng *current_rng;
+static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
-static u8 *rng_buffer;
+static u8 *rng_buffer, *rng_fillbuf;
+static unsigned short derating_current = 700; /* an arbitrary 70% */
+
+module_param(derating_current, ushort, 0644);
+MODULE_PARM_DESC(derating_current,
+		 "current hwrng entropy estimation per mill");
+
+static void start_khwrngd(void);
 
 static size_t rng_buffer_size(void)
 {
@@ -62,9 +71,18 @@ static size_t rng_buffer_size(void)
 
 static inline int hwrng_init(struct hwrng *rng)
 {
+	int err;
+
 	if (!rng->init)
 		return 0;
-	return rng->init(rng);
+	err = rng->init(rng);
+	if (err)
+		return err;
+
+	if (derating_current > 0 && !hwrng_fill)
+		start_khwrngd();
+
+	return 0;
 }
 
 static inline void hwrng_cleanup(struct hwrng *rng)
@@ -300,6 +318,36 @@ err_misc_dereg:
 	goto out;
 }
 
+static int hwrng_fillfn(void *unused)
+{
+	long rc;
+
+	while (!kthread_should_stop()) {
+		if (!current_rng)
+			break;
+		rc = rng_get_data(current_rng, rng_fillbuf,
+				  rng_buffer_size(), 1);
+		if (rc <= 0) {
+			pr_warn("hwrng: no data available\n");
+			msleep_interruptible(10000);
+			continue;
+		}
+		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
+					   (rc*derating_current)>>10);
+	}
+	hwrng_fill = 0;
+	return 0;
+}
+
+static void start_khwrngd(void)
+{
+	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
+	if (hwrng_fill == ERR_PTR(-ENOMEM)) {
+		pr_err("hwrng_fill thread creation failed");
+		hwrng_fill = NULL;
+	}
+}
+
 int hwrng_register(struct hwrng *rng)
 {
 	int must_register_misc;
@@ -319,6 +367,13 @@ int hwrng_register(struct hwrng *rng)
 		if (!rng_buffer)
 			goto out_unlock;
 	}
+	if (!rng_fillbuf) {
+		rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
+		if (!rng_fillbuf) {
+			kfree(rng_buffer);
+			goto out_unlock;
+		}
+	}
 
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
@@ -373,8 +428,11 @@ void hwrng_unregister(struct hwrng *rng)
 				current_rng = NULL;
 		}
 	}
-	if (list_empty(&rng_list))
+	if (list_empty(&rng_list)) {
 		unregister_miscdev();
+		if (hwrng_fill)
+			kthread_stop(hwrng_fill);
+	}
 
 	mutex_unlock(&rng_mutex);
 }
@@ -385,6 +443,7 @@ static void __exit hwrng_exit(void)
 	mutex_lock(&rng_mutex);
 	BUG_ON(current_rng);
 	kfree(rng_buffer);
+	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
 }
 
