Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaF3Vxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:53:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44769 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaF3Vxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:49 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 06/10] x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
Date: Mon, 30 Jun 2014 14:53:17 -0700
Message-Id: <7104a2e08de8bddb52d4714fad63d8a7977ea7f2.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
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
index dd1b322..5029be3 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -332,49 +332,6 @@ int in_gate_area_no_mm(unsigned long addr)
 	return vsyscall_mode != NONE && (addr & PAGE_MASK) == VSYSCALL_ADDR;
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
@@ -389,17 +346,3 @@ void __init map_vsyscall(void)
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
index 67a8b6c..8973b4e 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/cpu.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
@@ -17,6 +18,7 @@
 #include <asm/page.h>
 #include <asm/hpet.h>
 #include <asm/vvar.h>
+#include <asm/desc.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -233,3 +235,62 @@ static __init int vdso_setup(char *s)
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

