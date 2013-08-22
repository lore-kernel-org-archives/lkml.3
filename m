Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3HVLDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:03:35 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39308 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3HVLDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:03:30 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 02/18] asymmetric keys: implement EMSA_PKCS1-v1_5-ENCODE in rsa
Date: Thu, 22 Aug 2013 19:01:41 +0800
Message-Id: <1377169317-5959-3-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
first step of signature generation operation (RSASSA-PKCS1-v1_5-SIGN).

This patch is temporary set emLen to pks->k, and temporary set EM to
pks->S for debugging. We will replace the above values to real signature
after implement RSASP1.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |  158 +++++++++++++++++++++++++++++++++++++++++-
 include/crypto/public_key.h  |    2 +
 2 files changed, 158 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 95aab83..6996ff7 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <crypto/hash.h>
 #include "public_key.h"
 #include "private_key.h"
 
@@ -152,6 +153,125 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 }
 
 /*
+ * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
+ * @M: message to be signed, and octet string
+ * @emLen: intended length in octets of the encoded message
+ * @hash_algo: hash function (option)
+ * @hash: true means hash M, otherwise M is digest
+ * @EM: encoded message, an octet string of length emLen
+ */
+static int EMSA_PKCS1_v1_5_ENCODE(const u8 *M, size_t emLen,
+		enum pkey_hash_algo hash_algo, const bool hash,
+		u8 **_EM, struct public_key_signature *pks)
+{
+	u8 *digest;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t digest_size, desc_size;
+	size_t tLen;
+	u8 *T, *PS, *EM;
+	int i, ret;
+
+	pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
+
+	if (!RSA_ASN1_templates[hash_algo].data)
+		ret = -ENOTSUPP;
+	else
+		pks->pkey_hash_algo = hash_algo;
+
+	/* 1) Apply the hash function to the message M to produce a hash value H */
+	tfm = crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0);
+	if (IS_ERR(tfm))
+		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	ret = -ENOMEM;
+
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest)
+		goto error_digest;
+	pks->digest = digest;
+	pks->digest_size = digest_size;
+
+	if (hash) {
+		desc = (void *) digest + digest_size;
+		desc->tfm = tfm;
+		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+		ret = crypto_shash_init(desc);
+		if (ret < 0)
+			goto error_shash;
+		ret = crypto_shash_finup(desc, M, sizeof(M), pks->digest);
+		if (ret < 0)
+			goto error_shash;
+	} else {
+		memcpy(pks->digest, M, pks->digest_size);
+		pks->digest_size = digest_size;
+	}
+	crypto_free_shash(tfm);
+
+	/* 2) Encode the algorithm ID for the hash function and the hash value into
+	 * an ASN.1 value of type DigestInfo with the DER. Let T be the DER encoding of
+	 * the DigestInfo value and let tLen be the length in octets of T.
+	 */
+	tLen = RSA_ASN1_templates[hash_algo].size + pks->digest_size;
+	T = kmalloc(tLen, GFP_KERNEL);
+	if (!T)
+		goto error_T;
+
+	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
+	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
+
+	/* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
+	if (emLen < tLen + 11) {
+		ret = EINVAL;
+		goto error_emLen;
+	}
+
+	/* 4) Generate an octet string PS consisting of emLen - tLen - 3 octets with 0xff. */
+	PS = kmalloc(emLen - tLen - 3, GFP_KERNEL);
+	if (!PS)
+		goto error_P;
+
+	for (i = 0; i < (emLen - tLen - 3); i++)
+		PS[i] = 0xff;
+
+	/* 5) Concatenate PS, the DER encoding T, and other padding to form the encoded
+	 * message EM as EM = 0x00 || 0x01 || PS || 0x00 || T
+	 */
+	EM = kmalloc(3 + emLen - tLen - 3 + tLen, GFP_KERNEL);
+	if (!EM)
+		goto error_EM;
+
+	EM[0] = 0x00;
+	EM[1] = 0x01;
+	memcpy(EM + 2, PS, emLen - tLen - 3);
+	EM[2 + emLen - tLen - 3] = 0x00;
+	memcpy(EM + 2 + emLen - tLen - 3 + 1, T, tLen);
+
+	*_EM = EM;
+
+	kfree(PS);
+	kfree(T);
+
+	return 0;
+
+error_EM:
+	kfree(PS);
+error_P:
+error_emLen:
+	kfree(T);
+error_T:
+error_shash:
+	kfree(digest);
+error_digest:
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+/*
  * Perform the RSA signature verification.
  * @H: Value of hash of data and metadata
  * @EM: The computed signature value
@@ -275,9 +395,43 @@ static struct public_key_signature *RSA_generate_signature(
 		const struct private_key *key, u8 *M,
 		enum pkey_hash_algo hash_algo, const bool hash)
 {
-	pr_info("RSA_generate_signature start");
+	struct public_key_signature *pks;
+	u8 *EM = NULL;
+	size_t emLen;
+	int ret;
 
-	return 0;
+	pr_info("RSA_generate_signature start\n");
+
+	ret = -ENOMEM;
+	pks = kzalloc(sizeof(*pks), GFP_KERNEL);
+	if (!pks)
+		goto error_no_pks;
+
+	/* 1): EMSA-PKCS1-v1_5 encoding: */
+	/* Use the private key modulus size to be EM length */
+	emLen = mpi_get_nbits(key->rsa.n);
+	emLen = (emLen + 7) / 8;
+
+	ret = EMSA_PKCS1_v1_5_ENCODE(M, emLen, hash_algo, hash, &EM, pks);
+	if (ret < 0)
+		goto error_v1_5_encode;
+
+	/* TODO 2): m = OS2IP (EM) */
+
+	/* TODO 3): s = RSASP1 (K, m) */
+
+	/* TODO 4): S = I2OSP (s, k) */
+
+	/* TODO: signature S to a u8* S or set to sig->rsa.s? */
+	pks->S = EM;		/* TODO: temporary set S to EM */
+
+	return pks;
+
+error_v1_5_encode:
+	kfree(pks);
+error_no_pks:
+	pr_info("<==%s() = %d\n", __func__, ret);
+	return ERR_PTR(ret);
 }
 
 const struct public_key_algorithm RSA_public_key_algorithm = {
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index d44b29f..1cdf457 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
 struct public_key_signature {
 	u8 *digest;
 	u8 digest_size;			/* Number of bytes in digest */
+	u8 *S;				/* signature S of length k octets */
+	size_t k;			/* length k of signature S */
 	u8 nr_mpi;			/* Occupancy of mpi[] */
 	enum pkey_hash_algo pkey_hash_algo : 8;
 	union {
-- 
1.6.4.2

