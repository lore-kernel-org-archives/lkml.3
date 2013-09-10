Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IJVtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab3IJVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 04/16] integrity: Allow digital signature verification with a given keyring ptr
Date: Tue, 10 Sep 2013 17:44:19 -0400
Message-Id: <1378849471-10521-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently digital signature verification code assumes that it can be
used only with 3 keyrings. IMA, EVM and MODULE keyring. Provide another
variant where one can pass in a pointer to keyring (struct key *), and
integrity code can try to find key in that keyring and verify signature.

This will be useful at two places.

- elf binary loader can use system keyring and call into integrity
  subsystem for signature verification.
- In later patches I am extending keyctl() to allow signature of
  a user buffer against specified keyring. That logic can make use
  of this code too.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/digsig.c    | 26 ++++++++++++++++----------
 security/integrity/integrity.h |  9 +++++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 160fec7..f1259bd 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -44,6 +44,20 @@ int integrity_get_digsig_size(char *sig)
 	return -EBADMSG;
 }
 
+int integrity_digsig_verify_keyring(struct key *keyring, const char *sig,
+			int siglen, const char *digest, int digestlen)
+{
+	switch (sig[0]) {
+	case 1:
+		return digsig_verify(keyring, sig, siglen,
+				     digest, digestlen);
+	case 2:
+		return asymmetric_verify(keyring, sig, siglen,
+					 digest, digestlen);
+	}
+	return -EOPNOTSUPP;
+}
+
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen)
 {
@@ -61,14 +75,6 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		}
 	}
 
-	switch (sig[0]) {
-	case 1:
-		return digsig_verify(keyring[id], sig, siglen,
-				     digest, digestlen);
-	case 2:
-		return asymmetric_verify(keyring[id], sig, siglen,
-					 digest, digestlen);
-	}
-
-	return -EOPNOTSUPP;
+	return integrity_digsig_verify_keyring(keyring[id], sig, siglen,
+						digest, digestlen);
 }
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 4246417..130eb3b 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -101,6 +101,8 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen);
+int integrity_digsig_verify_keyring(struct key *keyring, const char *sig,
+			int siglen, const char *digest, int digestlen);
 extern int integrity_get_digsig_size(char *sig);
 
 #else
@@ -112,6 +114,13 @@ static inline int integrity_digsig_verify(const unsigned int id,
 	return -EOPNOTSUPP;
 }
 
+static inline int integrity_digsig_verify_keyring(struct key *keyring,
+			const char *sig, int siglen, const char *digest,
+			int digestlen)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int integrity_get_digsig_size(char *sig) { return -EOPNOTSUPP; }
 
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
-- 
1.8.3.1

