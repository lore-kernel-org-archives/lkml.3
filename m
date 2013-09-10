Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3IJVpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3IJVpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 02/16] integrity: Add a function to determine digital signature length
Date: Tue, 10 Sep 2013 17:44:17 -0400
Message-Id: <1378849471-10521-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if security.ima has digital signature, there is only one
structure in there. Either version 1 or version 2 of digital signature.
So all the functions assume that whole of the security.ima xattr contains
digital signautre and uses the length accordingly.

But, now I am planning to add more metadata in security.ima xattr. Apart
from signature, I am also planning to add additional info which tells
whether to memlock an executable file during execution or not. In that
case all functions need to know the size of digital signature as rest
of the data might be something else.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/digsig.c            | 17 +++++++++++++++++
 security/integrity/digsig_asymmetric.c | 11 -----------
 security/integrity/ima/ima_appraise.c  |  6 +++---
 security/integrity/integrity.h         | 14 ++++++++++++++
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 0b759e1..160fec7 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -27,6 +27,23 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 	"_ima",
 };
 
+/* Get size of digital signature */
+int integrity_get_digsig_size(char *sig)
+{
+	uint16_t sz;
+
+	if (sig[0] == 1) {
+		sz = *((uint16_t *)(sig + sizeof(struct signature_hdr)));
+		sz = __be16_to_cpu(sz);
+		return sizeof(struct signature_hdr) + 2 + (sz >> 3);
+	} else if (sig[0] == 2 ) {
+		sz = ((struct signature_v2_hdr *)sig)->sig_size;
+		return sizeof(struct signature_v2_hdr) + __be16_to_cpu(sz);
+	}
+
+	return -EBADMSG;
+}
+
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen)
 {
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index b475466..9eae480 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -20,17 +20,6 @@
 #include "integrity.h"
 
 /*
- * signature format v2 - for using with asymmetric keys
- */
-struct signature_v2_hdr {
-	uint8_t version;	/* signature format version */
-	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
-	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific*/
-	uint16_t sig_size;	/* signature size */
-	uint8_t sig[0];		/* signature payload */
-} __packed;
-
-/*
  * Request an asymmetric key.
  */
 static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 2d4beca..a9206d1 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -171,9 +171,9 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	case EVM_IMA_XATTR_DIGSIG:
 		iint->flags |= IMA_DIGSIG;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     xattr_value->digest, rc - 1,
-					     iint->ima_xattr.digest,
-					     IMA_DIGEST_SIZE);
+				xattr_value->digest,
+				integrity_get_digsig_size(xattr_value->digest),
+				iint->ima_xattr.digest, IMA_DIGEST_SIZE);
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
 		} else if (rc) {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index c42fb7a..4246417 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -75,6 +75,17 @@ struct integrity_iint_cache {
 	enum integrity_status evm_status:4;
 };
 
+/*
+ * signature format v2 - for using with asymmetric keys
+ */
+struct signature_v2_hdr {
+	uint8_t version;	/* signature format version */
+	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
+	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific*/
+	uint16_t sig_size;	/* signature size */
+	uint8_t sig[0];		/* signature payload */
+} __packed;
+
 /* rbtree tree calls to lookup, insert, delete
  * integrity data associated with an inode.
  */
@@ -90,6 +101,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen);
+extern int integrity_get_digsig_size(char *sig);
 
 #else
 
@@ -100,6 +112,8 @@ static inline int integrity_digsig_verify(const unsigned int id,
 	return -EOPNOTSUPP;
 }
 
+static inline int integrity_get_digsig_size(char *sig) { return -EOPNOTSUPP; }
+
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
-- 
1.8.3.1

