Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaIEXGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:06:24 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34408 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaIEXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:06:22 -0400
From: behanw@converseincode.com
To: zohar@linux.vnet.ibm.com
Cc: d.kasatkin@samsung.com, james.l.morris@oracle.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
Subject: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
Date: Fri,  5 Sep 2014 16:06:00 -0700
Message-Id: <1409958360-8061-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This patch allocates the appropriate amount of memory
using an char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 security/integrity/ima/ima_crypto.c | 53 +++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 0bd7328..a6aa2b0 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -380,17 +380,16 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	loff_t i_size, offset = 0;
 	char *rbuf;
 	int rc, read = 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 
-	desc.shash.tfm = tfm;
-	desc.shash.flags = 0;
+	shash->tfm = tfm;
+	shash->flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
-	rc = crypto_shash_init(&desc.shash);
+	rc = crypto_shash_init(shash);
 	if (rc != 0)
 		return rc;
 
@@ -420,7 +419,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
 			break;
 		offset += rbuf_len;
 
-		rc = crypto_shash_update(&desc.shash, rbuf, rbuf_len);
+		rc = crypto_shash_update(shash, rbuf, rbuf_len);
 		if (rc)
 			break;
 	}
@@ -429,7 +428,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	kfree(rbuf);
 out:
 	if (!rc)
-		rc = crypto_shash_final(&desc.shash, hash->digest);
+		rc = crypto_shash_final(shash, hash->digest);
 	return rc;
 }
 
@@ -487,18 +486,17 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 					 struct ima_digest_data *hash,
 					 struct crypto_shash *tfm)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	int rc, i;
 
-	desc.shash.tfm = tfm;
-	desc.shash.flags = 0;
+	shash->tfm = tfm;
+	shash->flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
-	rc = crypto_shash_init(&desc.shash);
+	rc = crypto_shash_init(shash);
 	if (rc != 0)
 		return rc;
 
@@ -508,7 +506,7 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 		u32 datalen = field_data[i].len;
 
 		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
-			rc = crypto_shash_update(&desc.shash,
+			rc = crypto_shash_update(shash,
 						(const u8 *) &field_data[i].len,
 						sizeof(field_data[i].len));
 			if (rc)
@@ -518,13 +516,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 			data_to_hash = buffer;
 			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
 		}
-		rc = crypto_shash_update(&desc.shash, data_to_hash, datalen);
+		rc = crypto_shash_update(shash, data_to_hash, datalen);
 		if (rc)
 			break;
 	}
 
 	if (!rc)
-		rc = crypto_shash_final(&desc.shash, hash->digest);
+		rc = crypto_shash_final(shash, hash->digest);
 
 	return rc;
 }
@@ -565,15 +563,14 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc, i;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 
-	desc.shash.tfm = tfm;
-	desc.shash.flags = 0;
+	shash->tfm = tfm;
+	shash->flags = 0;
 
-	rc = crypto_shash_init(&desc.shash);
+	rc = crypto_shash_init(shash);
 	if (rc != 0)
 		return rc;
 
@@ -581,10 +578,10 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
-		rc = crypto_shash_update(&desc.shash, pcr_i, TPM_DIGEST_SIZE);
+		rc = crypto_shash_update(shash, pcr_i, TPM_DIGEST_SIZE);
 	}
 	if (!rc)
-		crypto_shash_final(&desc.shash, digest);
+		crypto_shash_final(shash, digest);
 	return rc;
 }
 
-- 
1.9.1

