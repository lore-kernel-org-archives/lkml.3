Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaLWFka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:40:30 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:53278 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaLWFk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:40:27 -0500
Subject: [PATCH 3/5] hwrng: core - Do not register device opportunistically
References: <20141223053909.GA28001@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Message-Id: <E1Y3ICh-0007d7-SM@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 23 Dec 2014 16:40:19 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we only register the device when a valid RNG is added.
However the way it's done is buggy because we test whether there
is a current RNG to determine whether we need to register.  As
the current RNG may be missing due to a reinitialisation error
this can lead to a reregistration of the device.

As the device already has to handle a NULL current RNG anyway,
let's just register the device always and remove the complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/core.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 42827fd..1d342f0 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -372,14 +372,14 @@ static DEVICE_ATTR(rng_available, S_IRUGO,
 		   NULL);
 
 
-static void unregister_miscdev(void)
+static void __exit unregister_miscdev(void)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 	misc_deregister(&rng_miscdev);
 }
 
-static int register_miscdev(void)
+static int __init register_miscdev(void)
 {
 	int err;
 
@@ -484,12 +484,6 @@ int hwrng_register(struct hwrng *rng)
 		if (err)
 			goto out_unlock;
 		set_current_rng(rng);
-
-		err = register_miscdev();
-		if (err) {
-			drop_current_rng();
-			goto out_unlock;
-		}
 	}
 	list_add_tail(&rng->list, &rng_list);
 
@@ -530,7 +524,6 @@ void hwrng_unregister(struct hwrng *rng)
 
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
-		unregister_miscdev();
 		if (hwrng_fill)
 			kthread_stop(hwrng_fill);
 	} else
@@ -540,16 +533,24 @@ void hwrng_unregister(struct hwrng *rng)
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
 
-static void __exit hwrng_exit(void)
+static int __init hwrng_modinit(void)
+{
+	return register_miscdev();
+}
+
+static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
 	BUG_ON(current_rng);
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
+
+	unregister_miscdev();
 }
 
-module_exit(hwrng_exit);
+module_init(hwrng_modinit);
+module_exit(hwrng_modexit);
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
 MODULE_LICENSE("GPL");
