Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3EZVuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:50:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35044 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:50:03 -0400
From: Stephen Mell <sub.atomic.fusion@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: securebits: add exec_inherit flag to prevent changes to process credentials during execve
Date: Sun, 26 May 2013 21:51:50 +0000
Message-ID: <4537875.yLSqQy2YHM@pegasus>
User-Agent: KMail/4.9.5 (Linux/3.9.3; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Mell <sub.atomic.fusion@gmail.com>

Currently, it is nearly impossible to give a capability to a non-root user that will stick around after the first execve. This patch adds a new securebit, exec_inherit, which causes all credential modification logic to be skipped. This is already possible, in a hackish fashion, if a program reads another program into memory and jumps into it. This patch would allow this to be done in a more consistent and less hacky manner. Moreover, the sendmail exploit of old would not happen again, as setuid and capability bits on programs are disregarded when exec_inherit is active.
Use cases include allowing non-root users to bind to low numbered ports and use chroot. The securebit could be set in a pam module.

Signed-off-by: Stephen Mell <sub.atomic.fusion@gmail.com>
---
 include/uapi/linux/securebits.h | 12 +++++++++++-
 security/commoncap.c            |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)
diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
index 985aac9..b779489 100644
--- a/include/uapi/linux/securebits.h
+++ b/include/uapi/linux/securebits.h
@@ -40,12 +40,22 @@
 #define SECURE_KEEP_CAPS		4
 #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
 
+/* When set, a process retains its capabilities when performing an
+   execve(). No modifications, such as those from suid bits or file
+   capabilities, are made. */
+#define SECURE_EXEC_INHERIT		6
+#define SECURE_EXEC_INHERIT_LOCKED	7  /* make bit-6 immutable */
+
+#define SECBIT_EXEC_INHERIT	(issecure_mask(SECURE_EXEC_INHERIT))
+#define SECBIT_EXEC_INHERIT_LOCKED (issecure_mask(SECURE_EXEC_INHERIT_LOCKED))
+
 #define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
 #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
 
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
-				 issecure_mask(SECURE_KEEP_CAPS))
+				 issecure_mask(SECURE_KEEP_CAPS) | \
+				 issecure_mask(SECURE_EXEC_INHERIT))
 #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
 
 #endif /* _UAPI_LINUX_SECUREBITS_H */
diff --git a/security/commoncap.c b/security/commoncap.c
index c44b6fe..998ee6e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -484,6 +484,11 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	int ret;
 	kuid_t root_uid;
 
+	if (issecure(SECURE_EXEC_INHERIT)) {
+		*new = *old;
+		return 0;
+	}
+
 	effective = false;
 	ret = get_file_caps(bprm, &effective, &has_cap);
 	if (ret < 0)
