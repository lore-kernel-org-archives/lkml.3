Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3KHVX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:23:29 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:36437 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932381Ab3KHVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:23:25 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: james.l.morris@oracle.com, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, dhowells@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH linux-next] security/integrity: Fix build error and warnings when CONFIG_INTEGRITY_ASYMMETRIC_KEYS is disabled
Date: Fri,  8 Nov 2013 14:23:20 -0700
Message-Id: <1383945800-12060-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed both linux-next build error and warnings with the following changes

- define integrity_init_keyring() only when CONFIG_INTEGRITY_ASYMMETRIC_KEYS
  is enabled
- move integrity_init_keyring() stub from integrity.h
- define integrity_init_keyring() prototype as an extern when
  CONFIG_INTEGRITY_ASYMMETRIC_KEYS

linux-next build fails with the following error when CONFIG_INTEGRITY_ASYMMETRIC_KEYS
is disabled.

  CC      security/integrity/digsig.o
security/integrity/digsig.c:70:5: error: redefinition of ‘integrity_init_keyring’
 int integrity_init_keyring(const unsigned int id)
     ^
In file included from security/integrity/digsig.c:22:0:
security/integrity/integrity.h:149:12: note: previous definition of ‘integrity_init_keyring’ was here
 static int integrity_init_keyring(const unsigned int id)
            ^
security/integrity/integrity.h:149:12: warning: ‘integrity_init_keyring’ defined but not used [-Wunused-function]
make[2]: *** [security/integrity/digsig.o] Error 1
make[1]: *** [security/integrity] Error 2
make: *** [security] Error 2

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 security/integrity/digsig.c    | 7 +++++++
 security/integrity/integrity.h | 8 ++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 77ca965..28bc1a7 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -67,6 +67,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int integrity_init_keyring(const unsigned int id)
 {
 	const struct cred *cred = current_cred();
@@ -84,3 +85,9 @@ int integrity_init_keyring(const unsigned int id)
 			keyring_name[id], PTR_ERR(keyring[id]));
 	return 0;
 }
+#else
+int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
+#endif
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index b9e7c13..99ac783 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -134,22 +134,18 @@ static inline int integrity_digsig_verify(const unsigned int id,
 
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
+extern int integrity_init_keyring(const unsigned int id);
+
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int asymmetric_verify(struct key *keyring, const char *sig,
 		      int siglen, const char *data, int datalen);
 
-int integrity_init_keyring(const unsigned int id);
 #else
 static inline int asymmetric_verify(struct key *keyring, const char *sig,
 				    int siglen, const char *data, int datalen)
 {
 	return -EOPNOTSUPP;
 }
-
-static int integrity_init_keyring(const unsigned int id)
-{
-	return 0;
-}
 #endif
 
 #ifdef CONFIG_INTEGRITY_AUDIT
-- 
1.8.3.2

