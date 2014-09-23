Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaIWRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:51:16 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63520 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaIWRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:51:11 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/8] x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
Date: Tue, 23 Sep 2014 10:50:52 -0700
Message-Id: <a244daf7d3cbe71afc08ad09fdfe1866ca1f1978.1411494540.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is pure cut-and-paste.  At this point, vsyscall_64.c contains
only code needed for vsyscall emulation, but some of the comments
and function names are still confused.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 57 ----------------------------------------
 arch/x86/vdso/vma.c           | 61 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 420c4688c78a..31ce584981f3 100644
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
index 970463b566cf..a155dca5edb5 100644
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
-- 
1.9.3

