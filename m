Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3AVK3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:29:46 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18380
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab3AVK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:29:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,513,1355094000"; 
   d="scan'208";a="169299125"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: use ERR_CAST
Date: Tue, 22 Jan 2013 12:29:26 +0100
Message-Id: <1358854166-3952-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358854166-3952-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358854166-3952-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace PTR_ERR followed by ERR_PTR by ERR_CAST, to be more concise.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression err,x;
@@
-       err = PTR_ERR(x);
        if (IS_ERR(x))
-                return ERR_PTR(err);
+                return ERR_CAST(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 crypto/aead.c       |    6 ++----
 crypto/algapi.c     |    4 +---
 crypto/authenc.c    |    3 +--
 crypto/authencesn.c |    3 +--
 crypto/blkcipher.c  |    6 ++----
 crypto/ccm.c        |   23 +++++++----------------
 crypto/chainiv.c    |    3 +--
 crypto/ctr.c        |    3 +--
 crypto/cts.c        |    3 +--
 crypto/gcm.c        |   29 +++++++++--------------------
 crypto/seqiv.c      |    3 +--
 11 files changed, 27 insertions(+), 59 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 0b8121e..4d04e12 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -282,18 +282,16 @@ struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV)) &
 	    algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(name);
 	if (IS_ERR(name))
-		return ERR_PTR(err);
+		return ERR_CAST(name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/algapi.c b/crypto/algapi.c
index c3b9bfe..08c57c8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -749,12 +749,10 @@ struct crypto_alg *crypto_attr_alg2(struct rtattr *rta,
 				    u32 type, u32 mask)
 {
 	const char *name;
-	int err;
 
 	name = crypto_attr_alg_name(rta);
-	err = PTR_ERR(name);
 	if (IS_ERR(name))
-		return ERR_PTR(err);
+		return ERR_CAST(name);
 
 	return crypto_find_alg(name, frontend, type, mask);
 }
diff --git a/crypto/authenc.c b/crypto/authenc.c
index d0583a4..ffce19d 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -592,9 +592,8 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 136b68b..ab53762 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -715,9 +715,8 @@ static struct crypto_instance *crypto_authenc_esn_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index a8d85a1..e9e7244 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -588,18 +588,16 @@ struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ (CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV)) &
 	    algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(name);
 	if (IS_ERR(name))
-		return ERR_PTR(err);
+		return ERR_CAST(name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 32fe1bb..499c917 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -484,18 +484,16 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	cipher = crypto_alg_mod_lookup(cipher_name,  CRYPTO_ALG_TYPE_CIPHER,
 				       CRYPTO_ALG_TYPE_MASK);
-	err = PTR_ERR(cipher);
 	if (IS_ERR(cipher))
-		return ERR_PTR(err);
+		return ERR_CAST(cipher);
 
 	err = -EINVAL;
 	if (cipher->cra_blocksize != 16)
@@ -573,15 +571,13 @@ out_put_cipher:
 
 static struct crypto_instance *crypto_ccm_alloc(struct rtattr **tb)
 {
-	int err;
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(cipher_name);
 	if (IS_ERR(cipher_name))
-		return ERR_PTR(err);
+		return ERR_CAST(cipher_name);
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -612,20 +608,17 @@ static struct crypto_template crypto_ccm_tmpl = {
 
 static struct crypto_instance *crypto_ccm_base_alloc(struct rtattr **tb)
 {
-	int err;
 	const char *ctr_name;
 	const char *cipher_name;
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(ctr_name);
 	if (IS_ERR(ctr_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ctr_name);
 
 	cipher_name = crypto_attr_alg_name(tb[2]);
-	err = PTR_ERR(cipher_name);
 	if (IS_ERR(cipher_name))
-		return ERR_PTR(err);
+		return ERR_CAST(cipher_name);
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm_base(%s,%s)",
 		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -760,17 +753,15 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(ccm_name);
 	if (IS_ERR(ccm_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index ba200b0..834d8dd 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -291,9 +291,8 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	err = crypto_get_default_rng();
 	if (err)
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 4ca7222..095dcb6 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -334,9 +334,8 @@ static struct crypto_instance *crypto_rfc3686_alloc(struct rtattr **tb)
 
 	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
-	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
-		return ERR_PTR(err);
+		return ERR_CAST(alg);
 
 	/* We only support 16-byte blocks. */
 	err = -EINVAL;
diff --git a/crypto/cts.c b/crypto/cts.c
index ccf9c5d..042223f 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -282,9 +282,8 @@ static struct crypto_instance *crypto_cts_alloc(struct rtattr **tb)
 
 	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
-	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
-		return ERR_PTR(err);
+		return ERR_CAST(alg);
 
 	inst = ERR_PTR(-EINVAL);
 	if (!is_power_of_2(alg->cra_blocksize))
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 1a25263..137ad1e 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -701,9 +701,8 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
@@ -711,9 +710,8 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
 				    CRYPTO_ALG_TYPE_HASH,
 				    CRYPTO_ALG_TYPE_AHASH_MASK);
-	err = PTR_ERR(ghash_alg);
 	if (IS_ERR(ghash_alg))
-		return ERR_PTR(err);
+		return ERR_CAST(ghash_alg);
 
 	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
@@ -787,15 +785,13 @@ out_put_ghash:
 
 static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 {
-	int err;
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(cipher_name);
 	if (IS_ERR(cipher_name))
-		return ERR_PTR(err);
+		return ERR_CAST(cipher_name);
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)", cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
@@ -826,20 +822,17 @@ static struct crypto_template crypto_gcm_tmpl = {
 
 static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 {
-	int err;
 	const char *ctr_name;
 	const char *ghash_name;
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(ctr_name);
 	if (IS_ERR(ctr_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ctr_name);
 
 	ghash_name = crypto_attr_alg_name(tb[2]);
-	err = PTR_ERR(ghash_name);
 	if (IS_ERR(ghash_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ghash_name);
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
 		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
@@ -971,17 +964,15 @@ static struct crypto_instance *crypto_rfc4106_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(ccm_name);
 	if (IS_ERR(ccm_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -1222,17 +1213,15 @@ static struct crypto_instance *crypto_rfc4543_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
-	err = PTR_ERR(ccm_name);
 	if (IS_ERR(ccm_name))
-		return ERR_PTR(err);
+		return ERR_CAST(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 4c44912..f2cba4e 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -305,9 +305,8 @@ static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
 	int err;
 
 	algt = crypto_get_attr_type(tb);
-	err = PTR_ERR(algt);
 	if (IS_ERR(algt))
-		return ERR_PTR(err);
+		return ERR_CAST(algt);
 
 	err = crypto_get_default_rng();
 	if (err)

