Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab3ILJmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:42:00 -0400
Received: from verein.lst.de ([213.95.11.211]:55332 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3ILJl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:41:58 -0400
Date: Thu, 12 Sep 2013 11:41:00 +0200 (CEST)
From: Torsten Duwe <duwe@lst.de>
Reply-To: Torsten Duwe <duwe@lst.de>
To: tytso@mit.edu, ingo.tuchscherer@de.ibm.com
cc: linux-kernel@vger.kernel.org, Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [Resend PATCH 2/2] s390: provide hardware randomness from zcrypt
 card to /dev/random
Message-ID: <alpine.LNX.2.00.1309121139000.3818@linux.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: LST e.V.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Running completely virtualised, system Z severely lacks good true random sources.
Gathering entropy in a virtual environment is difficult. To compensate, there is
specialised crypto hardware which includes a source for hardware randomness;
the zcrypt driver is able to access this random source. This patch adds a kernel
thread that feeds the random bits via the interface created with the previous patch.

Signed-off-by: Torsten Duwe <duwe@lst.de>

---
 zcrypt_api.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -38,6 +38,8 @@
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/hw_random.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
 #include <linux/debugfs.h>
 #include <asm/debug.h>
 
@@ -99,6 +99,13 @@ static ssize_t zcrypt_online_store(struc
 
 	if (sscanf(buf, "%d\n", &online) != 1 || online < 0 || online > 1)
 		return -EINVAL;
+	if (zdev->ops->rng) {
+		if (zdev->online == 0 && online == 1)
+			zcrypt_rng_device_add();
+		if (zdev->online == 1 && online == 0)
+			zcrypt_rng_device_remove();
+
+	}
 	zdev->online = online;
 	ZCRYPT_DBF_DEV(DBF_INFO, zdev, "dev%04xo%dman", zdev->ap_dev->qid,
 		       zdev->online);
@@ -1117,6 +1119,7 @@ static int zcrypt_rng_device_count;
 static u32 *zcrypt_rng_buffer;
 static int zcrypt_rng_buffer_index;
 static DEFINE_MUTEX(zcrypt_rng_mutex);
+static struct task_struct *zcrypt_hwrng_fill;
 
 static int zcrypt_rng_data_read(struct hwrng *rng, u32 *data)
 {
@@ -1141,6 +1144,36 @@ static struct hwrng zcrypt_rng_dev = {
 	.data_read	= zcrypt_rng_data_read,
 };
 
+static int zcrypt_hwrng_fillfn(void *unused)
+{
+	long rc;
+
+	while (!kthread_should_stop()) {
+		rc = zcrypt_rng((char *)zcrypt_rng_buffer);
+		if (rc == -ENODEV || rc == -EINVAL || rc == -ENOMEM) {
+			pr_err("zcrypt_rng unavailable: %ld\n", rc);
+			break;
+		}
+		if (rc == -EAGAIN || rc == -ERESTARTSYS) {
+			pr_info("zcrypt_rng interrupted: %ld\n", rc);
+			msleep_interruptible(1000);
+			continue;
+		}
+		if (rc == 0) {
+			pr_err("zcrypt_rng: no data available\n");
+			msleep_interruptible(10000);
+			continue;
+		}
+		if (rc < 0) {
+			pr_err("zcrypt_rng unknown error: %ld\n", rc);
+			break;
+		}
+		add_hwgenerator_randomness((void *)zcrypt_rng_buffer, rc);
+	}
+	zcrypt_hwrng_fill = 0;
+	return 0;
+}
+
 static int zcrypt_rng_device_add(void)
 {
 	int rc = 0;
@@ -1157,6 +1189,12 @@ static int zcrypt_rng_device_add(void)
 		if (rc)
 			goto out_free;
 		zcrypt_rng_device_count = 1;
+		zcrypt_hwrng_fill = kthread_run(zcrypt_hwrng_fillfn,
+			NULL, "zc_hwrng");
+		if (zcrypt_hwrng_fill == ERR_PTR(-ENOMEM)) {
+			pr_err("zcrypt_hwrng_fill thread creation failed\n");
+			zcrypt_hwrng_fill = 0;
+		}
 	} else
 		zcrypt_rng_device_count++;
 	mutex_unlock(&zcrypt_rng_mutex);
@@ -1174,6 +1211,10 @@ static void zcrypt_rng_device_remove(voi
 	mutex_lock(&zcrypt_rng_mutex);
 	zcrypt_rng_device_count--;
 	if (zcrypt_rng_device_count == 0) {
+		if (zcrypt_hwrng_fill) {
+			kthread_stop(zcrypt_hwrng_fill);
+			zcrypt_hwrng_fill = 0;
+		}
 		hwrng_unregister(&zcrypt_rng_dev);
 		free_page((unsigned long) zcrypt_rng_buffer);
 	}
