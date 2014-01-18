Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaARArG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 19:47:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:12817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbaARAqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 19:46:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,677,1384329600"; 
   d="scan'208";a="466912410"
Date: Sat, 18 Jan 2014 00:46:27 +0000
From: Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, tadeusz.struk@intel.com
Subject: [PATCH RFC 2/2] crypto: Simple load balancer test module
Message-ID: <52d9cee3.2gRBl3ylFAjEYpPT%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test module for the simple algorithm load balancer

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig                |    6 ++
 crypto/Makefile               |    1 +
 crypto/test_alg_loadbalance.c |  231 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+)
 create mode 100644 crypto/test_alg_loadbalance.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d..85e1bc2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1404,6 +1404,12 @@ config CRYPTO_USER_API_SKCIPHER
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_ALG_LOAD_BALANCE_TEST
+	tristate "Crypto Algorithm load balancer test module"
+	default n
+	help
+	  This option enables the crypto algorithm load balancer test module.
+
 source "drivers/crypto/Kconfig"
 source crypto/asymmetric_keys/Kconfig
 
diff --git a/crypto/Makefile b/crypto/Makefile
index b29402a..5a49e2a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_ALG_LOAD_BALANCE_TEST) += test_alg_loadbalance.o
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/test_alg_loadbalance.c b/crypto/test_alg_loadbalance.c
new file mode 100644
index 0000000..2637247
--- /dev/null
+++ b/crypto/test_alg_loadbalance.c
@@ -0,0 +1,231 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/string.h>
+#include <crypto/algapi.h>
+
+static int encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	return 0;
+}
+static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+{
+	return 0;
+}
+
+
+#define loops 3000000
+static struct crypto_ablkcipher *tfms[loops];
+
+static struct crypto_alg tmp = {
+		.cra_name		= "test",
+		.cra_driver_name	= "test_driver",
+		.cra_priority		= 1,
+		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.cra_module		= THIS_MODULE,
+		.cra_ctxsize		= 0,
+		.cra_type		= &crypto_blkcipher_type,
+		.cra_u = {
+			.blkcipher = {
+				.min_keysize	= 64,
+				.max_keysize	= 64,
+				.ivsize		= 64,
+				.setkey		= setkey,
+				.encrypt	= encrypt,
+				.decrypt	= encrypt,
+			},
+		},
+	};
+static struct crypto_alg algs[10] = {
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+	{ { 0 } },
+};
+
+static int __init cra_lbtest_init(void)
+{
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		algs[i] = tmp;
+		algs[i].cra_priority += i;
+	}
+
+	if (crypto_register_algs(algs, 10))
+		return -1;
+
+	for (i = 0; i < loops; i++) {
+		tfms[i] = crypto_alloc_ablkcipher("test", 0, 0);
+		if (IS_ERR(tfms[i]))
+			return PTR_ERR(tfms[i]);
+	}
+	pr_info("Algorithm load balancig test results for %d allocatoins\n",
+									loops);
+	pr_info("All different alg priorities:\n");
+	for (i = 0; i < 10; i++) {
+		unsigned long times = atomic_read(&algs[i].cra_refcnt);
+		unsigned long percent = (times * 100) / loops;
+
+		pr_info("Alg with cra_pri %d allocated %lu times. That's ~%lu%%\n",
+			algs[i].cra_priority, times, percent);
+
+	}
+	for (i = 0; i < loops; i++)
+		crypto_free_ablkcipher(tfms[i]);
+
+	crypto_unregister_algs(algs, 10);
+
+	for (i = 0; i < 10; i++) {
+		algs[i] = tmp;
+		algs[i].cra_priority = 10;
+	}
+	if (crypto_register_algs(algs, 10))
+		return -1;
+
+	for (i = 0; i < loops; i++) {
+		tfms[i] = crypto_alloc_ablkcipher("test", 0, 0);
+		if (IS_ERR(tfms[i]))
+			return PTR_ERR(tfms[i]);
+	}
+	pr_info("All same alg priorities:\n");
+	for (i = 0; i < 10; i++) {
+		unsigned long times = atomic_read(&algs[i].cra_refcnt);
+		unsigned long percent = (times * 100) / loops;
+
+		pr_info("Alg with cra_pri %d allocated %lu times. That's ~%lu%%\n",
+			algs[i].cra_priority, times, percent);
+	}
+	for (i = 0; i < loops; i++)
+		crypto_free_ablkcipher(tfms[i]);
+
+	crypto_unregister_algs(algs, 10);
+
+	for (i = 0; i < 10; i++)
+		algs[i] = tmp;
+
+	algs[0].cra_priority = 9;
+	algs[1].cra_priority = 4;
+	algs[2].cra_priority = 1;
+	algs[3].cra_priority = 4;
+	algs[4].cra_priority = 5;
+	algs[5].cra_priority = 20;
+	algs[6].cra_priority = 21;
+	algs[7].cra_priority = 10;
+	algs[8].cra_priority = 21;
+	algs[9].cra_priority = 7;
+
+	if (crypto_register_algs(algs, 10))
+		return -1;
+
+	for (i = 0; i < loops; i++) {
+		tfms[i] = crypto_alloc_ablkcipher("test", 0, 0);
+		if (IS_ERR(tfms[i]))
+			return PTR_ERR(tfms[i]);
+	}
+	pr_info("A mix alg priorities:\n");
+	for (i = 0; i < 10; i++) {
+		unsigned long times = atomic_read(&algs[i].cra_refcnt);
+		unsigned long percent = (times * 100) / loops;
+
+		pr_info("Alg with cra_pri %d allocated %lu times. That's ~%lu%%\n",
+			algs[i].cra_priority, times, percent);
+	}
+	for (i = 0; i < loops; i++)
+		crypto_free_ablkcipher(tfms[i]);
+	crypto_unregister_algs(algs, 10);
+
+	for (i = 0; i < 10; i++)
+		algs[i] = tmp;
+
+	algs[0].cra_priority = 9;
+	algs[1].cra_priority = 4;
+	algs[2].cra_priority = 1;
+	algs[3].cra_priority = 4;
+	algs[4].cra_priority = 500;
+	algs[5].cra_priority = 20;
+	algs[6].cra_priority = 21;
+	algs[7].cra_priority = 10;
+	algs[8].cra_priority = 21;
+	algs[9].cra_priority = 7;
+
+	if (crypto_register_algs(algs, 10))
+		return -1;
+
+	for (i = 0; i < loops; i++) {
+		tfms[i] = crypto_alloc_ablkcipher("test", 0, 0);
+		if (IS_ERR(tfms[i]))
+			return PTR_ERR(tfms[i]);
+	}
+	pr_info("A mix alg priorities with one very big:\n");
+	for (i = 0; i < 10; i++) {
+		unsigned long times = atomic_read(&algs[i].cra_refcnt);
+		unsigned long percent = (times * 100) / loops;
+
+		pr_info("Alg with cra_pri %d allocated %lu times. That's ~%lu%%\n",
+			algs[i].cra_priority, times, percent);
+	}
+
+	for (i = 0; i < loops; i++)
+		crypto_free_ablkcipher(tfms[i]);
+
+	crypto_unregister_algs(algs, 10);
+
+	pr_info("And lastly only one of a given alg:\n");
+	strcpy(tmp.cra_name, "TEST");
+
+	for (i = 0; i < 10; i++)
+		algs[i] = tmp;
+
+	strcpy(algs[0].cra_name, "test");
+
+	if (crypto_register_algs(algs, 10))
+		return -1;
+
+	for (i = 0; i < loops; i++) {
+		tfms[i] = crypto_alloc_ablkcipher("test", 0, 0);
+		if (IS_ERR(tfms[i]))
+			return PTR_ERR(tfms[i]);
+	}
+
+	for (i = 0; i < 10; i++) {
+
+		unsigned long times = atomic_read(&algs[i].cra_refcnt);
+		unsigned long percent = (times * 100) / loops;
+
+		pr_info("Alg with cra_pri %d allocated %lu times. That's ~%lu%%\n",
+			algs[i].cra_priority, times, percent);
+	}
+
+	for (i = 0; i < loops; i++)
+		crypto_free_ablkcipher(tfms[i]);
+
+	crypto_unregister_algs(algs, 10);
+	return 0;
+
+}
+
+static void __exit cra_lbtest_exit(void)
+{
+	crypto_unregister_algs(algs, 10);
+}
+
+module_init(cra_lbtest_init);
+module_exit(cra_lbtest_exit);
+MODULE_DESCRIPTION("Crypto Algorithm load balancer test module");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

