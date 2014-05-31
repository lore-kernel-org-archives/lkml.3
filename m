Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbaFAMBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:01:01 -0400
Received: from mail.eperm.de ([89.247.134.16]:45706 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaFAMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:01:00 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, aquini@redhat.com, joe@perches.com,
        pwalten@au1.ibm.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de
Subject: [PATCH v9 6/6] Add DRBG test code to testmgr
Date: Sat, 31 May 2014 17:25:36 +0200
Message-ID: <4475600.bmUR6kBdJr@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <22272963.fKEMicLVWl@myon.chronox.de>
References: <22272963.fKEMicLVWl@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DRBG test code implements the CAVS test approach.

As discussed for the test vectors, all DRBG types are covered with
testing. However, not every backend cipher is covered with testing. To
prevent the testmgr from logging missing testing, the NULL test is
registered for all backend ciphers not covered with specific test cases.

All currently implemented DRBG types and backend ciphers are defined
in SP800-90A. Therefore, the fips_allowed flag is set for all.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 247 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 247 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index dc3cf35..4b1f512 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <crypto/rng.h>
+#include <crypto/drbg.h>
 
 #include "internal.h"
 
@@ -108,6 +109,11 @@ struct cprng_test_suite {
 	unsigned int count;
 };
 
+struct drbg_test_suite {
+	struct drbg_testvec *vecs;
+	unsigned int count;
+};
+
 struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
@@ -121,6 +127,7 @@ struct alg_test_desc {
 		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
 		struct cprng_test_suite cprng;
+		struct drbg_test_suite drbg;
 	} suite;
 };
 
@@ -1712,6 +1719,100 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+
+static int drbg_cavs_test(struct drbg_testvec *test, int pr,
+			  const char *driver, u32 type, u32 mask)
+{
+	int ret = -EAGAIN;
+	struct crypto_rng *drng;
+	struct drbg_test_data test_data;
+	struct drbg_string addtl, pers, testentropy;
+	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	drng = crypto_alloc_rng(driver, type, mask);
+	if (IS_ERR(drng)) {
+		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for"
+		       "%s\n", driver);
+		kzfree(buf);
+		return -ENOMEM;
+	}
+
+	test_data.testentropy = &testentropy;
+	drbg_string_fill(&testentropy, test->entropy, test->entropylen);
+	drbg_string_fill(&pers, test->pers, test->perslen);
+	ret = crypto_drbg_reset_test(drng, &pers, &test_data);
+	if (ret) {
+		printk(KERN_ERR "alg: drbg: Failed to reset rng\n");
+		goto outbuf;
+	}
+
+	drbg_string_fill(&addtl, test->addtla, test->addtllen);
+	if (pr) {
+		drbg_string_fill(&testentropy, test->entpra, test->entprlen);
+		ret = crypto_drbg_get_bytes_addtl_test(drng,
+			buf, test->expectedlen, &addtl,	&test_data);
+	} else {
+		ret = crypto_drbg_get_bytes_addtl(drng,
+			buf, test->expectedlen, &addtl);
+	}
+	if (ret <= 0) {
+		printk(KERN_ERR "alg: drbg: could not obtain random data for"
+		       "driver %s\n", driver);
+		goto outbuf;
+	}
+
+	drbg_string_fill(&addtl, test->addtlb, test->addtllen);
+	if (pr) {
+		drbg_string_fill(&testentropy, test->entprb, test->entprlen);
+		ret = crypto_drbg_get_bytes_addtl_test(drng,
+			buf, test->expectedlen, &addtl, &test_data);
+	} else {
+		ret = crypto_drbg_get_bytes_addtl(drng,
+			buf, test->expectedlen, &addtl);
+	}
+	if (ret <= 0) {
+		printk(KERN_ERR "alg: drbg: could not obtain random data for"
+		       "driver %s\n", driver);
+		goto outbuf;
+	}
+
+	ret = memcmp(test->expected, buf, test->expectedlen);
+
+outbuf:
+	crypto_free_rng(drng);
+	kzfree(buf);
+	return ret;
+}
+
+
+static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
+{
+	int err = 0;
+	int pr = 0;
+	int i = 0;
+	struct drbg_testvec *template = desc->suite.drbg.vecs;
+	unsigned int tcount = desc->suite.drbg.count;
+
+	if (0 == memcmp(driver, "drbg_pr_", 8))
+		pr = 1;
+
+	for (i = 0; i < tcount; i++) {
+		err = drbg_cavs_test(&template[i], pr, driver, type, mask);
+		if (err) {
+			printk(KERN_ERR "alg: drbg: Test %d failed for %s\n",
+			       i, driver);
+			err = -EINVAL;
+			break;
+		}
+	}
+	return err;
+
+}
+
 static int alg_test_null(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -2305,6 +2406,152 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "digest_null",
 		.test = alg_test_null,
 	}, {
+		.alg = "drbg_nopr_ctr_aes128",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes128_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes128_tv_template)
+			}
+		}
+	}, {
+		.alg = "drbg_nopr_ctr_aes192",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes192_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes192_tv_template)
+			}
+		}
+	}, {
+		.alg = "drbg_nopr_ctr_aes256",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes256_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes256_tv_template)
+			}
+		}
+	}, {
+		/*
+		 * There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg_nopr_hmac_sha256 test
+		 */
+		.alg = "drbg_nopr_hmac_sha1",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_nopr_hmac_sha256",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_hmac_sha256_tv_template,
+				.count =
+				ARRAY_SIZE(drbg_nopr_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		/* covered by drbg_nopr_hmac_sha256 test */
+		.alg = "drbg_nopr_hmac_sha384",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_nopr_hmac_sha512",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "drbg_nopr_sha1",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_nopr_sha256",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_sha256_tv_template)
+			}
+		}
+	}, {
+		/* covered by drbg_nopr_sha256 test */
+		.alg = "drbg_nopr_sha384",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_nopr_sha512",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_ctr_aes128",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_ctr_aes128_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_ctr_aes128_tv_template)
+			}
+		}
+	}, {
+		/* covered by drbg_pr_ctr_aes128 test */
+		.alg = "drbg_pr_ctr_aes192",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_ctr_aes256",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_hmac_sha1",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_hmac_sha256",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		/* covered by drbg_pr_hmac_sha256 test */
+		.alg = "drbg_pr_hmac_sha384",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_hmac_sha512",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "drbg_pr_sha1",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_sha256",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_sha256_tv_template)
+			}
+		}
+	}, {
+		/* covered by drbg_pr_sha256 test */
+		.alg = "drbg_pr_sha384",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg_pr_sha512",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
 		.alg = "ecb(__aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-- 
1.9.3


