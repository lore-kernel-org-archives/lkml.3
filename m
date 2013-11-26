Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3KZUEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:04:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6674 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690Ab3KZUEV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:04:21 -0500
Date: Tue, 26 Nov 2013 15:04:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH] ima: Fix build failure of redefinition of
 integrity_init_keyring()
Message-ID: <20131126150415.2ecdb563@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_INTEGRITY_SIGNATURE is set, but
CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not, then we get the following
build failure:

linux.git/security/integrity/digsig.c:70:5: error: redefinition of ‘integrity_init_keyring’
linux.git/security/integrity/integrity.h:149:12: note: previous definition of ‘integrity_init_keyring’ was here
linux.git/security/integrity/integrity.h:149:12: warning: ‘integrity_init_keyring’ defined but not used distcc[8580] ERROR:
compile /home/rostedt/work/git/linux-trace.git/security/integrity/digsig.c on localhost failed

The problem is that CONFIG_INTEGRITY_SIGNATURE will compile digsig.o,
which defines integrity_init_keyring(), but when
CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not defined, the header will define
integrity_init_keyring() as a static inline.

Do not define integrity_init_keyring() when
CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not configured.

I also added the missing "inline" for the stub function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 77ca965..00bc3e1 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -67,6 +67,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int integrity_init_keyring(const unsigned int id)
 {
 	const struct cred *cred = current_cred();
@@ -84,3 +85,4 @@ int integrity_init_keyring(const unsigned int id)
 			keyring_name[id], PTR_ERR(keyring[id]));
 	return 0;
 }
+#endif
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index b9e7c13..c3d48dc 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -146,7 +146,7 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 	return -EOPNOTSUPP;
 }
 
-static int integrity_init_keyring(const unsigned int id)
+static inline int integrity_init_keyring(const unsigned int id)
 {
 	return 0;
 }
