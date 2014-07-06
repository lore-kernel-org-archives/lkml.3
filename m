Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaGFAoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:44:21 -0400
Received: from mail.eperm.de ([89.247.134.16]:58234 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaGFAoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:44:20 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: joe@perches.com, dan.carpenter@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, fengguang.wu@intel.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, aris@redhat.com
Subject: [PATCH 1/6] DRBG: cleanup of preprocessor macros
Date: Sun, 06 Jul 2014 02:23:03 +0200
Message-ID: <9435610.CPPimQpbzb@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
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

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index acc7523..cce915b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -356,6 +356,7 @@ static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
  ******************************************************************/
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
+#define CRYPTO_DRBG_CTR_STRING "CTR "
 static int drbg_kcapi_sym(struct drbg_state *drbg, const unsigned char *key,
 			  unsigned char *outval, const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
@@ -717,6 +718,7 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 #endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
+#define CRYPTO_DRBG_HMAC_STRING "HMAC "
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 			    int reseed)
@@ -836,6 +838,7 @@ static struct drbg_state_ops drbg_hmac_ops = {
  ******************************************************************/
 
 #ifdef CONFIG_CRYPTO_DRBG_HASH
+#define CRYPTO_DRBG_HASH_STRING "HASH "
 /*
  * scratchpad usage: as drbg_hash_update and drbg_hash_df are used
  * interlinked, the scratchpad is used as follows:
@@ -1867,7 +1870,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 	drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
-#elif CONFIG_CRYPTO_DRBG_HASH
+#elif defined CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
 #else
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref, &pr);
@@ -2009,16 +2012,19 @@ void __exit drbg_exit(void)
 
 module_init(drbg_init);
 module_exit(drbg_exit);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) using following cores:"
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
-"HMAC "
+#ifndef CRYPTO_DRBG_HASH_STRING
+#define CRYPTO_DRBG_HASH_STRING ""
 #endif
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-"Hash "
+#ifndef CRYPTO_DRBG_HMAC_STRING
+#define CRYPTO_DRBG_HMAC_STRING ""
 #endif
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-"CTR"
+#ifndef CRYPTO_DRBG_CTR_STRING
+#define CRYPTO_DRBG_CTR_STRING ""
 #endif
-);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
+		   "using following cores: "
+		   CRYPTO_DRBG_HASH_STRING
+		   CRYPTO_DRBG_HMAC_STRING
+		   CRYPTO_DRBG_CTR_STRING);
-- 
1.9.3


