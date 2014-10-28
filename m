Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaJ1LPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:15:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaJ1LPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:15:01 -0400
Date: Tue, 28 Oct 2014 04:14:51 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-d4f829dd9026797bd5db8715a30192f23b22afaa@git.kernel.org>
Cc: hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Reply-To: luto@amacapital.net, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <a244daf7d3cbe71afc08ad09fdfe1866ca1f1978.1411494540.git.luto@amacapital.net>
References: <a244daf7d3cbe71afc08ad09fdfe1866ca1f1978.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vdso:
  Move getcpu code from vsyscall_64.c to vdso/vma.c
Git-Commit-ID: d4f829dd9026797bd5db8715a30192f23b22afaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4f829dd9026797bd5db8715a30192f23b22afaa
Gitweb:     http://git.kernel.org/tip/d4f829dd9026797bd5db8715a30192f23b22afaa
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:52 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:09 +0100

x86_64/vdso: Move getcpu code from vsyscall_64.c to vdso/vma.c

This is pure cut-and-paste.  At this point, vsyscall_64.c
contains only code needed for vsyscall emulation, but some of
the comments and function names are still confused.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/a244daf7d3cbe71afc08ad09fdfe1866ca1f1978.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsyscall_64.c | 57 ----------------------------------------
 arch/x86/vdso/vma.c           | 61 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 521d5ed..2f9ef0c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -332,49 +332,6 @@ int in_gate_area_no_mm(unsigned long addr)
 	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
-/*
- * Assume __initcall executes before all user space. Hopefully kmod
- * doesn't violate that. We'll find out if it does.
- */
-static void vsyscall_set_cpu(int cpu)
-{
-	unsigned long d;
-	unsigned long node = 0;
-#ifdef CONFIG_NUMA
-	node = cpu_to_node(cpu);
-#endif
-	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
-		write_rdtscp_aux((node << 12) | cpu);
-
-	/*
-	 * Store cpu number in limit so that it can be loaded quickly
-	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
-	 */
-	d = 0x0f40000000000ULL;
-	d |= cpu;
-	d |= (node & 0xf) << 12;
-	d |= (node >> 4) << 48;
-
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
-}
-
-static void cpu_vsyscall_init(void *arg)
-{
-	/* preemption should be already off */
-	vsyscall_set_cpu(raw_smp_processor_id());
-}
-
-static int
-cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
-{
-	long cpu = (long)arg;
-
-	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
-		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
-
-	return NOTIFY_DONE;
-}
-
 void __init map_vsyscall(void)
 {
 	extern char __vsyscall_page;
@@ -387,17 +344,3 @@ void __init map_vsyscall(void)
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
 		     (unsigned long)VSYSCALL_ADDR);
 }
-
-static int __init vsyscall_init(void)
-{
-	cpu_notifier_register_begin();
-
-	on_each_cpu(cpu_vsyscall_init, NULL, 1);
-	/* notifier priority > KVM */
-	__hotcpu_notifier(cpu_vsyscall_notifier, 30);
-
-	cpu_notifier_register_done();
-
-	return 0;
-}
-__initcall(vsyscall_init);
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 970463b..a155dca 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -10,12 +10,14 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/cpu.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
+#include <asm/desc.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -238,3 +240,62 @@ static __init int vdso_setup(char *s)
 }
 __setup("vdso=", vdso_setup);
 #endif
+
+#ifdef CONFIG_X86_64
+/*
+ * Assume __initcall executes before all user space. Hopefully kmod
+ * doesn't violate that. We'll find out if it does.
+ */
+static void vsyscall_set_cpu(int cpu)
+{
+	unsigned long d;
+	unsigned long node = 0;
+#ifdef CONFIG_NUMA
+	node = cpu_to_node(cpu);
+#endif
+	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
+		write_rdtscp_aux((node << 12) | cpu);
+
+	/*
+	 * Store cpu number in limit so that it can be loaded quickly
+	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
+	 */
+	d = 0x0f40000000000ULL;
+	d |= cpu;
+	d |= (node & 0xf) << 12;
+	d |= (node >> 4) << 48;
+
+	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
+}
+
+static void cpu_vsyscall_init(void *arg)
+{
+	/* preemption should be already off */
+	vsyscall_set_cpu(raw_smp_processor_id());
+}
+
+static int
+cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
+{
+	long cpu = (long)arg;
+
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
+		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+
+	return NOTIFY_DONE;
+}
+
+static int __init vsyscall_init(void)
+{
+	cpu_notifier_register_begin();
+
+	on_each_cpu(cpu_vsyscall_init, NULL, 1);
+	/* notifier priority > KVM */
+	__hotcpu_notifier(cpu_vsyscall_notifier, 30);
+
+	cpu_notifier_register_done();
+
+	return 0;
+}
+__initcall(vsyscall_init);
+#endif
