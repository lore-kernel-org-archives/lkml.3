Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3KSOyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:54:10 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39013 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3KSOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:54:04 -0500
From: Dan Aloni <alonid@stratoscale.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        Muli Ben-Yehuda <muli@stratoscale.com>
Subject: [PATCH linux-next 1/2] kgdb-x86: allow to temporarily disable trap activation
Date: Tue, 19 Nov 2013 16:53:29 +0200
Message-Id: <1384872810-29492-2-git-send-email-alonid@stratoscale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
References: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some users that would like the ability of a temporary
per-cpu deactivation of the debugger trap.

More specifically, we have seen that when kvm-unit-tests runs with
kgdb enabled, the kernel halts on the debugger during the KVM x86
instruction emulation that performs a test of a division by zero,
and also during fwait.

A second patch depending on this one addresses that issue.

Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Signed-off-by: Muli Ben-Yehuda <muli@stratoscale.com>
---
 arch/x86/include/asm/kgdb.h |  8 ++++++++
 arch/x86/kernel/kgdb.c      | 21 +++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index 332f98c..35bec81 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -86,4 +86,12 @@ static inline void arch_kgdb_breakpoint(void)
 extern int kgdb_ll_trap(int cmd, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig);
 
+#ifdef CONFIG_KGDB
+extern void kgdb_ll_local_disable(void);
+extern void kgdb_ll_local_enable(void);
+#else
+#define kgdb_ll_local_disable() do {} while (0)
+#define kgdb_ll_local_enable() do {} while (0)
+#endif
+
 #endif /* _ASM_X86_KGDB_H */
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 836f832..c269ad8 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -587,6 +587,22 @@ int kgdb_ll_trap(int cmd, const char *str,
 	return __kgdb_notify(&args, cmd);
 }
 
+static DEFINE_PER_CPU(bool, kgdb_swallow_traps);
+
+void kgdb_ll_local_disable(void)
+{
+	__this_cpu_write(kgdb_swallow_traps, true);
+}
+
+EXPORT_SYMBOL(kgdb_ll_local_disable);
+
+void kgdb_ll_local_enable(void)
+{
+	__this_cpu_write(kgdb_swallow_traps, false);
+}
+
+EXPORT_SYMBOL(kgdb_ll_local_enable);
+
 static int
 kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 {
@@ -594,6 +610,11 @@ kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 	int ret;
 
 	local_irq_save(flags);
+	if (__this_cpu_read(kgdb_swallow_traps) && cmd == DIE_TRAP) {
+		local_irq_restore(flags);
+		return NOTIFY_DONE;
+	}
+
 	ret = __kgdb_notify(ptr, cmd);
 	local_irq_restore(flags);
 
-- 
1.8.3.1

