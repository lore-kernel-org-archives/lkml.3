Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCHXwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:52:10 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:26668 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaCHXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:50:50 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH 6/6] Add DRBG test code to testmgr
Date: Sun, 09 Mar 2014 00:50:27 +0100
Message-ID: <2089717.8vDROGZ4yA@myon.chronox.de>
User-Agent: KMail/4.12.2 (Linux/3.13.5-200.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <1447568.DPx3XIi38f@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3266401.GHYe0GEnsC@myon.chronox.de> <1447568.DPx3XIi38f@myon.chronox.de>
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

All currently implemented DRBG types and backend ciphers are definined
in SP800-90A. Therefore, the fips_allowed flag is set for all.

Signed-off-by: Stephan Mueller <smueller@chronox.de>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7795550..e8cd57c 100644
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
 
@@ -1712,6 +1719,104 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+
+static int drbg_cavs_test(struct drbg_testvec *test, int pr,
+			  const char *driver, u32 type, u32 mask)
+{
+	int ret = -EAGAIN;
+	struct crypto_rng *drng;
+	struct drbg_state *drbg;
+	struct drbg_test_data test_data;
+	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
+	if(!buf)
+		return -ENOMEM;
+
+	drng = crypto_alloc_rng(driver, type, mask);
+	if(IS_ERR(drng)) {
+		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for %s\n", driver);
+		return -ENOMEM;
+	}
+
+	drbg = crypto_tfm_ctx(crypto_rng_tfm(drng));
+	test_data.testentropy = test->entropy;
+	test_data.testentropylen = test->entropylen;
+	ret = crypto_drbg_reset_test(drng, test->pers, test->perslen,
+				     &test_data);
+	if (ret) {
+		printk(KERN_ERR "alg: drbg: Failed to reset rng\n");
+		goto outbuf;
+	}
+
+	if(pr) {
+		test_data.testentropy = test->entpra;
+		test_data.testentropylen = test->entprlen;
+		ret = crypto_drbg_get_bytes_addtl_test(drng,
+			buf, test->expectedlen,
+			test->addtla, test->addtllen,
+			&test_data);
+	} else {
+		ret = crypto_drbg_get_bytes_addtl(drng,
+			buf, test->expectedlen,
+			test->addtla, test->addtllen);
+	}
+	if(ret <= 0) {
+		printk(KERN_ERR "alg: drbg: could not obtain random data\n");
+		goto outbuf;
+	}
+
+	if(pr) {
+		test_data.testentropy = test->entprb;
+		test_data.testentropylen = test->entprlen;
+		ret = crypto_drbg_get_bytes_addtl_test(drng,
+			buf, test->expectedlen,
+			test->addtlb, test->addtllen,
+			&test_data);
+	} else {
+		ret = crypto_drbg_get_bytes_addtl(drng,
+			buf, test->expectedlen,
+			test->addtlb, test->addtllen);
+	}
+	if(ret <= 0) {
+		printk(KERN_ERR "alg: drbg: could not obtain random data\n");
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
+	if((0 == memcmp(driver, "drbg(pr(", 8)) ||
+	   (0 == memcmp(driver, "drbg_pr_", 8)))
+		pr = 1;
+
+	for (i = 0; i < tcount; i++)
+	{
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
@@ -2273,6 +2378,170 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "digest_null",
 		.test = alg_test_null,
 	}, {
+		.alg = "drbg(nopr(ctr(aes128)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes128_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes128_tv_template)
+			}
+		}
+	}, {
+		.alg = "drbg(nopr(ctr(aes192)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes192_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes192_tv_template)
+			}
+		}
+	}, {
+		.alg = "drbg(nopr(ctr(aes256)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_ctr_aes256_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_ctr_aes256_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(hmac(sha256))) test */
+		.alg = "drbg(nopr(hmac(sha1)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg(nopr(hmac(sha256)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_nopr_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(hmac(sha256))) test */
+		.alg = "drbg(nopr(hmac(sha384)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(hmac(sha256))) test */
+		.alg = "drbg(nopr(hmac(sha512)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(sha256)) test */
+		.alg = "drbg(nopr(sha1))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg(nopr(sha256))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg= {
+				.vecs = drbg_nopr_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_nopr_sha256_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(sha256)) test */
+		.alg = "drbg(nopr(sha384))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(nopr(sha256)) test */
+		.alg = "drbg(nopr(sha512))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg(pr(ctr(aes128)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_ctr_aes128_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_ctr_aes128_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(aes128)) test */
+		.alg = "drbg(pr(ctr(aes192)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(aes128)) test */
+		.alg = "drbg(pr(ctr(aes256)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(hmac(sha256))) test */
+		.alg = "drbg(pr(hmac(sha1)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg(pr(hmac(sha256)))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(hmac(sha256))) test */
+		.alg = "drbg(pr(hmac(sha384)))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(hmac(sha256))) test */
+		.alg = "drbg(pr(hmac(sha512)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(sha256)) test */
+		.alg = "drbg(pr(sha1))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		.alg = "drbg(pr(sha256))",
+		.test = alg_test_drbg,
+		.fips_allowed = 1,
+		.suite = {
+			.drbg = {
+				.vecs = drbg_pr_sha256_tv_template,
+				.count = ARRAY_SIZE(drbg_pr_sha256_tv_template)
+			}
+		}
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(sha256)) test */
+		.alg = "drbg(pr(sha384))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
+		/* There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg(pr(sha256)) test */
+		.alg = "drbg(pr(sha512))",
+		.fips_allowed = 1,
+		.test = alg_test_null,
+	}, {
 		.alg = "ecb(__aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-- 
1.8.5.3


