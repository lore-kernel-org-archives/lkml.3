Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaD3J6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:58:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64832 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaD3J6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:58:35 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v9 1/2] arm64: Add audit support
Date: Wed, 30 Apr 2014 18:57:22 +0900
Message-Id: <1398851843-16435-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851843-16435-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862548-29060-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851843-16435-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AArch64, audit is supported through generic lib/audit.c and
compat_audit.c, and so this patch adds arch specific definitions required.

Acked-by Will Deacon <will.deacon@arm.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |    2 ++
 arch/arm64/include/asm/syscall.h |   14 ++++++++++++++
 include/uapi/linux/audit.h       |    1 +
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0e9b8ce..0d3a003 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -9,6 +9,7 @@ config ARM64
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
+	select AUDIT_ARCH_COMPAT_GENERIC
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
@@ -27,6 +28,7 @@ config ARM64
 	select GENERIC_STRNLEN_USER
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
+	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 383771e..709a574 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -16,6 +16,8 @@
 #ifndef __ASM_SYSCALL_H
 #define __ASM_SYSCALL_H
 
+#include <uapi/linux/audit.h>
+#include <linux/compat.h>
 #include <linux/err.h>
 
 extern const void *sys_call_table[];
@@ -105,4 +107,16 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	memcpy(&regs->regs[i], args, n * sizeof(args[0]));
 }
 
+/*
+ * We don't care about endianness (__AUDIT_ARCH_LE bit) here because
+ * AArch64 has the same system calls both on little- and big- endian.
+ */
+static inline int syscall_get_arch(void)
+{
+	if (is_compat_task())
+		return AUDIT_ARCH_ARM;
+
+	return AUDIT_ARCH_AARCH64;
+}
+
 #endif	/* __ASM_SYSCALL_H */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 11917f7..e7df2e3 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -334,6 +334,7 @@ enum {
 /* distinguish syscall tables */
 #define __AUDIT_ARCH_64BIT 0x80000000
 #define __AUDIT_ARCH_LE	   0x40000000
+#define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARMEB	(EM_ARM)
-- 
1.7.9.5

