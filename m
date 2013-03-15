Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3COUlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab3COUlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:41:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@redhat.com
Subject: [PATCH 1/4] integrity: Identify asymmetric digital signature using new type
Date: Fri, 15 Mar 2013 16:35:55 -0400
Message-Id: <1363379758-10071-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there seem to be two types of digital signatures. Old one and
that is RSA and new one which is being called asymmetric. Right now they
both fall in the categorty of EVM_IMA_XATTR_DIGSIG and one differentiates
between two using signature version. Version 1 is old type and version 2
is new type.

How about asymmetric signature using a new type say
EVM_IMA_XATTR_DIGSIG_ASYMMETRIC. And version numbering can be used for
structure variation with-in signature type.

This can allow to export signature type to other subsystems. And these
subsystems will call into ima/integrity for verification only if signature
are of certain type.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/digsig.c           |   11 +++++++----
 security/integrity/evm/evm_main.c     |    4 +++-
 security/integrity/ima/ima_appraise.c |    7 +++++--
 security/integrity/integrity.h        |   14 +++++---------
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 0b759e1..268c4cc 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -27,7 +27,8 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 	"_ima",
 };
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
+int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+			const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen)
 {
 	if (id >= INTEGRITY_KEYRING_MAX)
@@ -44,13 +45,15 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		}
 	}
 
-	switch (sig[0]) {
-	case 1:
+	switch (sig_type) {
+	case EVM_IMA_XATTR_DIGSIG:
 		return digsig_verify(keyring[id], sig, siglen,
 				     digest, digestlen);
-	case 2:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		return asymmetric_verify(keyring[id], sig, siglen,
 					 digest, digestlen);
+	default:
+		break;
 	}
 
 	return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index cdbde17..cf798cb 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -134,11 +134,13 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 			rc = -EINVAL;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
 				xattr_value_len, calc.digest);
 		if (rc)
 			break;
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
+		rc = integrity_digsig_verify(xattr_data->type,
+					INTEGRITY_KEYRING_EVM,
 					xattr_data->digest, xattr_len,
 					calc.digest, sizeof(calc.digest));
 		if (!rc) {
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 2d4beca..9bc0723 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -169,8 +169,10 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		status = INTEGRITY_PASS;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		iint->flags |= IMA_DIGSIG;
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+		rc = integrity_digsig_verify(xattr_value->type,
+					     INTEGRITY_KEYRING_IMA,
 					     xattr_value->digest, rc - 1,
 					     iint->ima_xattr.digest,
 					     IMA_DIGEST_SIZE);
@@ -193,7 +195,8 @@ out:
 	if (status != INTEGRITY_PASS) {
 		if ((ima_appraise & IMA_APPRAISE_FIX) &&
 		    (!xattr_value ||
-		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
+		     (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
+		      xattr_value->type != EVM_IMA_XATTR_DIGSIG_ASYMMETRIC))) {
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 84c37c4..8392d18 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -50,12 +50,6 @@
 #define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
 				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
 
-enum evm_ima_xattr_type {
-	IMA_XATTR_DIGEST = 0x01,
-	EVM_XATTR_HMAC,
-	EVM_IMA_XATTR_DIGSIG,
-};
-
 struct evm_ima_xattr_data {
 	u8 type;
 	u8 digest[SHA1_DIGEST_SIZE];
@@ -88,12 +82,14 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
-					const char *digest, int digestlen);
+int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+	const unsigned int id, const char *sig, int siglen,
+	const char *digest, int digestlen);
 
 #else
 
-static inline int integrity_digsig_verify(const unsigned int id,
+static inline int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+					  const unsigned int id,
 					  const char *sig, int siglen,
 					  const char *digest, int digestlen)
 {
-- 
1.7.7.6

