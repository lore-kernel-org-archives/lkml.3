Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaF1ULQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:11:16 -0400
Received: from mail.eperm.de ([89.247.134.16]:43638 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbaF1ULP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:11:15 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Date: Sat, 28 Jun 2014 22:00:07 +0200
Message-ID: <1949550.LXKdkPOvgm@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <4927386.WYHrRe3NJm@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure used to construct the module description line was marked
problematic by the sparse code analysis tool. The module line
description now does not contain any ifdefs to prevent error reports
from sparse.

The preprocessor warning declaration was reported by sparse. It is
replaced in favor of an init function reporting the erroneous built of
the DRBG.

Lastly, a fix of the use use of CONFIG_CRYPTO_DRBG_HASH has been
applied.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 6679a26..03a230e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -102,8 +102,13 @@
 #if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
 	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
 	!defined(CONFIG_CRYPTO_DRBG_CTR)
-#warning "The DRBG code is useless without compiling at least one DRBG type"
-#endif
+#define CRYPTO_DRBG_NONE_STRING "none "
+static int __init drbg_init(void)
+{
+	pr_warn("DRBG: no DRBG core was compiled!\n");
+	return -EFAULT;
+}
+#else
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
@@ -362,6 +367,7 @@ static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
  ******************************************************************/
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
+#define CRYPTO_DRBG_CTR_STRING "CTR "
 static int drbg_kcapi_sym(struct drbg_state *drbg, const unsigned char *key,
 			  unsigned char *outval, const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
@@ -715,6 +721,7 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 #endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
+#define CRYPTO_DRBG_HMAC_STRING "HMAC "
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 			    int reseed)
@@ -834,6 +841,7 @@ static struct drbg_state_ops drbg_hmac_ops = {
  ******************************************************************/
 
 #ifdef CONFIG_CRYPTO_DRBG_HASH
+#define CRYPTO_DRBG_HASH_STRING "HASH "
 /*
  * scratchpad usage: as drbg_hash_update and drbg_hash_df are used
  * interlinked, the scratchpad is used as follows:
@@ -1865,7 +1873,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 	drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
-#elif CONFIG_CRYPTO_DRBG_HASH
+#elif defined CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
 #else
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref, &pr);
@@ -2005,18 +2013,29 @@ void __exit drbg_exit(void)
 	crypto_unregister_algs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
-module_init(drbg_init);
 module_exit(drbg_exit);
+#endif /* !defined(CONFIG_CRYPTO_DRBG_HASH) && \
+	  !defined(CONFIG_CRYPTO_DRBG_HMAC) && \
+	  !defined(CONFIG_CRYPTO_DRBG_CTR) */
+
+module_init(drbg_init);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) using following cores:"
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
-"HMAC "
+#ifndef CRYPTO_DRBG_NONE_STRING
+#define CRYPTO_DRBG_NONE_STRING ""
 #endif
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-"Hash "
+#ifndef CRYPTO_DRBG_HASH_STRING
+#define CRYPTO_DRBG_HASH_STRING ""
 #endif
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-"CTR"
+#ifndef CRYPTO_DRBG_HMAC_STRING
+#define CRYPTO_DRBG_HMAC_STRING ""
+#endif
+#ifndef CRYPTO_DRBG_CTR_STRING
+#define CRYPTO_DRBG_CTR_STRING ""
 #endif
-);
+MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
+		   "using following cores: "
+		   CRYPTO_DRBG_NONE_STRING
+		   CRYPTO_DRBG_HMAC_STRING
+		   CRYPTO_DRBG_HASH_STRING
+		   CRYPTO_DRBG_CTR_STRING);
-- 
1.9.3


