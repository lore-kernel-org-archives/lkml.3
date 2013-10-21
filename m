Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3JUWvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:51:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49430 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3JUWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:28 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 05/23] ima: pass full xattr with the signature
Date: Mon, 21 Oct 2013 18:42:50 -0400
Message-Id: <1382395388-8108-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-6688-0000-0000-000002BE7546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

For possibility to use xattr type for new signature formats,
pass full xattr to the signature verification function.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/digsig.c           | 5 +++--
 security/integrity/evm/evm_main.c     | 4 ++--
 security/integrity/ima/ima_appraise.c | 2 +-
 security/integrity/integrity.h        | 1 +
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 198e609..b4af4eb 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -44,9 +44,10 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		}
 	}
 
-	switch (sig[0]) {
+	switch (sig[1]) {
 	case 1:
-		return digsig_verify(keyring[id], sig, siglen,
+		/* v1 API expect signature without xattr type */
+		return digsig_verify(keyring[id], sig + 1, siglen - 1,
 				     digest, digestlen);
 	case 2:
 		return asymmetric_verify(keyring[id], sig, siglen,
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index af9b685..336b3dd 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -123,7 +123,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		goto out;
 	}
 
-	xattr_len = rc - 1;
+	xattr_len = rc;
 
 	/* check value type */
 	switch (xattr_data->type) {
@@ -143,7 +143,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		if (rc)
 			break;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
-					xattr_data->digest, xattr_len,
+					(const char *)xattr_data, xattr_len,
 					calc.digest, sizeof(calc.digest));
 		if (!rc) {
 			/* we probably want to replace rsa with hmac here */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 00708a3..e1865a6 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -205,7 +205,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	case EVM_IMA_XATTR_DIGSIG:
 		iint->flags |= IMA_DIGSIG;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     xattr_value->digest, rc - 1,
+					     (const char *)xattr_value, rc,
 					     iint->ima_hash.digest,
 					     iint->ima_hash.length);
 		if (rc == -EOPNOTSUPP) {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index ea23189..aead6b2 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -74,6 +74,7 @@ struct ima_digest_data {
  * signature format v2 - for using with asymmetric keys
  */
 struct signature_v2_hdr {
+	uint8_t type;		/* xattr type */
 	uint8_t version;	/* signature format version */
 	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
 	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific */
-- 
1.8.1.4

