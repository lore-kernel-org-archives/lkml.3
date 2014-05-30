Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbaE3V67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:58:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59786 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaE3V6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:58:54 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/2] x86,syscall: Add syscall_in_syscall to test whether we're in a syscall
Date: Fri, 30 May 2014 14:58:47 -0700
Message-Id: <0d75554db5eab82852470f82d984c096d93bd61f.1401486790.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401486790.git.luto@amacapital.net>
References: <cover.1401486790.git.luto@amacapital.net>
In-Reply-To: <cover.1401486790.git.luto@amacapital.net>
References: <cover.1401486790.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall_in_syscall will return true if we're in a real syscall and
will return false if we're not in a syscall.  If we're in a bad
syscall, the return value can vary.

The idea is to use this to come up with a much simpler replacement
for syscall auditing.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig               |  1 +
 arch/x86/include/asm/syscall.h | 21 +++++++++++++++++++++
 init/Kconfig                   |  3 +++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..e2602d4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -130,6 +130,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_SYSCALL_IN_SYSCALL
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d6a756a..91e38b3 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -23,6 +23,27 @@
 typedef void (*sys_call_ptr_t)(void);
 extern const sys_call_ptr_t sys_call_table[];
 
+/**
+ * syscall_in_syscall() - are we in a syscall context?
+ * @task: The task to query.
+ * @regs: The task's pt_regs.
+ *
+ * This checks whether we are in a syscall.  If it returns true, then
+ * syscall_get_nr(), etc are usable and the current task is guaranteed
+ * to either die or to go through the syscall exit path when the syscall
+ * is done.
+ *
+ * If it returns false, no particular guarantees are made.  In
+ * particular, a malicious task can issue a syscall that causes
+ * syscall_in_syscall to return false.  Such a syscall won't do much,
+ * but it can still cause tracing code and such to run.
+ */
+static inline bool syscall_in_syscall(struct task_struct *task,
+				      struct pt_regs *regs)
+{
+	return regs->orig_ax != -1;
+}
+
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
  * This importantly ignores the high bits on 64-bit, so comparisons
diff --git a/init/Kconfig b/init/Kconfig
index 9d3585b..bad2053 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -295,6 +295,9 @@ config AUDIT
 config HAVE_ARCH_AUDITSYSCALL
 	bool
 
+config HAVE_SYSCALL_IN_SYSCALL
+	bool
+
 config AUDITSYSCALL
 	bool "Enable system-call auditing support"
 	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL
-- 
1.9.3

