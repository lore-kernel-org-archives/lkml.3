Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaBCG5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:57:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59503 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaBCG5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:57:12 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, patches@linaro.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 2/3] arm64: Add audit support
Date: Mon,  3 Feb 2014 15:56:29 +0900
Message-Id: <1391410590-4884-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AArch64, audit is supported through generic lib/audit.c and
compat_audit.c, and so this patch adds arch specific definitions required.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/syscall.h |   15 +++++++++++++++
 include/uapi/linux/audit.h       |    1 +
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d4dd22..3c21405 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -19,6 +19,7 @@ config ARM64
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
+	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 70ba9d4..6900183 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -16,7 +16,9 @@
 #ifndef __ASM_SYSCALL_H
 #define __ASM_SYSCALL_H
 
+#include <linux/audit.h>
 #include <linux/err.h>
+#include <asm/compat.h>
 
 
 static inline int syscall_get_nr(struct task_struct *task,
@@ -104,4 +106,17 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->regs[i], args, n * sizeof(args[0]));
 }
 
+/*
+ * We don't care about endianness (__AUDIT_ARCH_LE bit) here because
+ * AArch64 has the same system calls both on little- and big- endian.
+ */
+static inline int syscall_get_arch(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	if (is_compat_thread(task_thread_info(task)))
+		return AUDIT_ARCH_ARM;
+
+	return AUDIT_ARCH_AARCH64;
+}
+
 #endif	/* __ASM_SYSCALL_H */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 0a73cf3..cf27cae 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -327,6 +327,7 @@ enum {
 /* distinguish syscall tables */
 #define __AUDIT_ARCH_64BIT 0x80000000
 #define __AUDIT_ARCH_LE	   0x40000000
+#define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARMEB	(EM_ARM)
-- 
1.7.9.5

