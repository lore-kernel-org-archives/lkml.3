Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3IJVpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3IJVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 05/16] integrity: Export a function to retrieve hash algo used in digital signature
Date: Tue, 10 Sep 2013 17:44:20 -0400
Message-Id: <1378849471-10521-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A function to retrieve hash algo used in digital signature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/digsig.c    | 26 ++++++++++++++++++++++++++
 security/integrity/integrity.h |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index f1259bd..153cff4 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -16,6 +16,8 @@
 #include <linux/rbtree.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <crypto/hash.h>
+#include <crypto/public_key.h>
 
 #include "integrity.h"
 
@@ -27,6 +29,30 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 	"_ima",
 };
 
+int integrity_digsig_get_hash_algo(char *sig)
+{
+	uint8_t hash_algo;
+
+	if (sig[0] == 1) {
+		hash_algo = ((struct signature_hdr *)sig)->hash;
+		switch (hash_algo) {
+		case 0:
+			return PKEY_HASH_SHA1;
+		case 1:
+			return PKEY_HASH_SHA256;
+		default:
+			return -ENOPKG;
+		}
+	} else if (sig[0] == 2 ) {
+		hash_algo = ((struct signature_v2_hdr *)sig)->hash_algo;
+		if (hash_algo >= PKEY_HASH__LAST)
+			return -ENOPKG;
+		return hash_algo;
+	}
+
+	return -EBADMSG;
+}
+
 /* Get size of digital signature */
 int integrity_get_digsig_size(char *sig)
 {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 130eb3b..284bb8d 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -15,6 +15,7 @@
 #include <linux/integrity.h>
 #include <crypto/sha.h>
 #include <linux/key.h>
+#include <crypto/public_key.h>
 
 /* iint action cache flags */
 #define IMA_MEASURE		0x00000001
@@ -105,8 +106,14 @@ int integrity_digsig_verify_keyring(struct key *keyring, const char *sig,
 			int siglen, const char *digest, int digestlen);
 extern int integrity_get_digsig_size(char *sig);
 
+extern int integrity_digsig_get_hash_algo(char *sig);
 #else
 
+static inline int integrity_digsig_get_hash_algo(char *sig)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int integrity_digsig_verify(const unsigned int id,
 					  const char *sig, int siglen,
 					  const char *digest, int digestlen)
-- 
1.8.3.1

