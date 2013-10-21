Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3JUWo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:44:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36906 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3JUWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 23/23] ima: provide hash algo info in the xattr
Date: Mon, 21 Oct 2013 18:43:08 -0400
Message-Id: <1382395388-8108-24-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-0928-0000-0000-000002A8F562
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

All files labeled with 'security.ima' hashes, are hashed using the
same hash algorithm.  Changing from one hash algorithm to another,
requires relabeling the filesystem.  This patch defines a new xattr
type, which includes the hash algorithm, permitting different files
to be hashed with different algorithms.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 61 +++++++++++++++++++++++++++--------
 security/integrity/integrity.h        | 13 +++++++-
 2 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 116630c..734e946 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -15,6 +15,7 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <crypto/hash_info.h>
 
 #include "ima.h"
 
@@ -45,10 +46,22 @@ int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func)
 static int ima_fix_xattr(struct dentry *dentry,
 			 struct integrity_iint_cache *iint)
 {
-	iint->ima_hash->type = IMA_XATTR_DIGEST;
-	return __vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
-				     &iint->ima_hash->type,
-				     1 + iint->ima_hash->length, 0);
+	int rc, offset;
+	u8 algo = iint->ima_hash->algo;
+
+	if (algo <= HASH_ALGO_SHA1) {
+		offset = 1;
+		iint->ima_hash->xattr.sha1.type = IMA_XATTR_DIGEST;
+	} else {
+		offset = 0;
+		iint->ima_hash->xattr.ng.type = IMA_XATTR_DIGEST_NG;
+		iint->ima_hash->xattr.ng.algo = algo;
+	}
+	rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
+				   &iint->ima_hash->xattr.data[offset],
+				   (sizeof(iint->ima_hash->xattr) - offset) +
+				   iint->ima_hash->length, 0);
+	return rc;
 }
 
 /* Return specific func appraised cached result */
@@ -112,15 +125,31 @@ void ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value, int xattr_len,
 {
 	struct signature_v2_hdr *sig;
 
-	if (!xattr_value || xattr_len < 0 || xattr_len <= 1 + sizeof(*sig))
+	if (!xattr_value || xattr_len < 2)
 		return;
 
-	sig = (typeof(sig)) xattr_value->digest;
-
-	if (xattr_value->type != EVM_IMA_XATTR_DIGSIG || sig->version != 2)
-		return;
-
-	hash->algo = sig->hash_algo;
+	switch (xattr_value->type) {
+	case EVM_IMA_XATTR_DIGSIG:
+		sig = (typeof(sig))xattr_value;
+		if (sig->version != 2 || xattr_len <= sizeof(*sig))
+			return;
+		hash->algo = sig->hash_algo;
+		break;
+	case IMA_XATTR_DIGEST_NG:
+		hash->algo = xattr_value->digest[0];
+		break;
+	case IMA_XATTR_DIGEST:
+		/* this is for backward compatibility */
+		if (xattr_len == 21) {
+			unsigned int zero = 0;
+			if (!memcmp(&xattr_value->digest[16], &zero, 4))
+				hash->algo = HASH_ALGO_MD5;
+			else
+				hash->algo = HASH_ALGO_SHA1;
+		} else if (xattr_len == 17)
+			hash->algo = HASH_ALGO_MD5;
+		break;
+	}
 }
 
 int ima_read_xattr(struct dentry *dentry,
@@ -153,7 +182,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
-	int rc = xattr_len;
+	int rc = xattr_len, hash_start = 0;
 
 	if (!ima_appraise)
 		return 0;
@@ -180,17 +209,21 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		goto out;
 	}
 	switch (xattr_value->type) {
+	case IMA_XATTR_DIGEST_NG:
+		/* first byte contains algorithm id */
+		hash_start = 1;
 	case IMA_XATTR_DIGEST:
 		if (iint->flags & IMA_DIGSIG_REQUIRED) {
 			cause = "IMA signature required";
 			status = INTEGRITY_FAIL;
 			break;
 		}
-		if (xattr_len - 1 >= iint->ima_hash->length)
+		if (xattr_len - sizeof(xattr_value->type) - hash_start >=
+				iint->ima_hash->length)
 			/* xattr length may be longer. md5 hash in previous
 			   version occupied 20 bytes in xattr, instead of 16
 			 */
-			rc = memcmp(xattr_value->digest,
+			rc = memcmp(&xattr_value->digest[hash_start],
 				    iint->ima_hash->digest,
 				    iint->ima_hash->length);
 		else
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 5429ca5..2fb5e53 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -54,6 +54,7 @@ enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
 	EVM_XATTR_HMAC,
 	EVM_IMA_XATTR_DIGSIG,
+	IMA_XATTR_DIGEST_NG,
 };
 
 struct evm_ima_xattr_data {
@@ -66,7 +67,17 @@ struct evm_ima_xattr_data {
 struct ima_digest_data {
 	u8 algo;
 	u8 length;
-	u8 type;
+	union {
+		struct {
+			u8 unused;
+			u8 type;
+		} sha1;
+		struct {
+			u8 type;
+			u8 algo;
+		} ng;
+		u8 data[2];
+	} xattr;
 	u8 digest[0];
 } __packed;
 
-- 
1.8.1.4

