Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaG3MSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:18:22 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39026 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaG3MSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:18:17 -0400
From: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
To: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Torsten Duwe <duwe@suse.de>, Hendrik Brueckner <brueckner@de.ibm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@de.ibm.com>,
        Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Subject: [PATCH] s390/zcrypt: enable s390 hwrng to seed kernel entropy
Date: Wed, 30 Jul 2014 14:17:36 +0200
Message-Id: <1406722656-6506-1-git-send-email-ingo.tuchscherer@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073012-5024-0000-0000-000000D70F6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the 'quality' property in the zcrypt rng device structure to enable the
zcrypt hwrng device to take part in the kernel entropy seeding process.
A module parameter named hwrng_seed will be introduced to disable the
participation. By default this parameter is set to 1 (enabled).

Signed-off-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
---
 drivers/s390/crypto/ap_bus.c     | 5 +++++
 drivers/s390/crypto/ap_bus.h     | 1 +
 drivers/s390/crypto/zcrypt_api.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 4038437..19fac5f 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -85,6 +85,11 @@ static int ap_thread_flag = 0;
 module_param_named(poll_thread, ap_thread_flag, int, S_IRUSR|S_IRGRP);
 MODULE_PARM_DESC(poll_thread, "Turn on/off poll thread, default is 0 (off).");
 
+int ap_hwrng_seed = 1;
+EXPORT_SYMBOL(ap_hwrng_seed);
+module_param_named(hwrng_seed, ap_hwrng_seed, int, S_IRUSR|S_IRGRP);
+MODULE_PARM_DESC(hwrng_seed, "Turn on/off hwrng auto seed, default is 1 (on).");
+
 static struct device *ap_root_device = NULL;
 static struct ap_config_info *ap_configuration;
 static DEFINE_SPINLOCK(ap_device_list_lock);
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 6405ae2..b0be09a 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -38,6 +38,7 @@
 #define AP_POLL_TIME 1		/* Time in ticks between receive polls. */
 
 extern int ap_domain_index;
+extern int ap_hwrng_seed;
 
 /**
  * The ap_qid_t identifier of an ap queue. It contains a
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 0e18c5d..ed91665 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1374,6 +1374,7 @@ static int zcrypt_rng_data_read(struct hwrng *rng, u32 *data)
 static struct hwrng zcrypt_rng_dev = {
 	.name		= "zcrypt",
 	.data_read	= zcrypt_rng_data_read,
+	.quality	= 990,
 };
 
 static int zcrypt_rng_device_add(void)
@@ -1388,6 +1389,8 @@ static int zcrypt_rng_device_add(void)
 			goto out;
 		}
 		zcrypt_rng_buffer_index = 0;
+		if (!ap_hwrng_seed)
+			zcrypt_rng_dev.quality = 0;
 		rc = hwrng_register(&zcrypt_rng_dev);
 		if (rc)
 			goto out_free;
-- 
1.8.5.5

