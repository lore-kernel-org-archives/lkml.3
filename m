Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaF3VzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:55:01 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62590 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaF3Vx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 08/10] x86_64,vdso: Clean up vgetcpu init and merge the vdso initcalls
Date: Mon, 30 Jun 2014 14:53:19 -0700
Message-Id: <8feed908d052bbd7a414bdb513a0a033f19aa588.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now vdso/vma.c has a single initcall and no references to
"vsyscall".

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c | 61 +++++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 8973b4e..84df79b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -1,7 +1,8 @@
 /*
- * Set up the VMAs to tell the VM about the vDSO.
  * Copyright 2007 Andi Kleen, SUSE Labs.
  * Subject to the GPL, v.2
+ *
+ * This contains most of the x86 vDSO kernel-side code.
  */
 #include <linux/mm.h>
 #include <linux/err.h>
@@ -11,7 +12,6 @@
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/cpu.h>
-#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
@@ -22,8 +22,6 @@
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
-
-extern unsigned short vdso_sync_cpuid;
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
@@ -41,20 +39,6 @@ void __init init_vdso_image(const struct vdso_image *image)
 						image->alt_len));
 }
 
-#if defined(CONFIG_X86_64)
-static int __init init_vdso(void)
-{
-	init_vdso_image(&vdso_image_64);
-
-#ifdef CONFIG_X86_X32_ABI
-	init_vdso_image(&vdso_image_x32);
-#endif
-
-	return 0;
-}
-subsys_initcall(init_vdso);
-#endif
-
 struct linux_binprm;
 
 /* Put the vdso above the (randomized) stack with another randomized offset.
@@ -237,12 +221,9 @@ __setup("vdso=", vdso_setup);
 #endif
 
 #ifdef CONFIG_X86_64
-/*
- * Assume __initcall executes before all user space. Hopefully kmod
- * doesn't violate that. We'll find out if it does.
- */
-static void vsyscall_set_cpu(int cpu)
+static void vgetcpu_cpu_init(void *arg)
 {
+	int cpu = smp_processor_id();
 	unsigned long d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
@@ -252,45 +233,47 @@ static void vsyscall_set_cpu(int cpu)
 		write_rdtscp_aux((node << 12) | cpu);
 
 	/*
-	 * Store cpu number in limit so that it can be loaded quickly
-	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
+	 * Store cpu number in limit so that it can be loaded quickly in
+	 * user space in vgetcpu. (12 bits for the CPU and 8 bits for
+	 * the node)
 	 */
 	d = 0x0f40000000000ULL;
 	d |= cpu;
 	d |= (node & 0xf) << 12;
 	d |= (node >> 4) << 48;
 
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
-}
-
-static void cpu_vsyscall_init(void *arg)
-{
-	/* preemption should be already off */
-	vsyscall_set_cpu(raw_smp_processor_id());
+	write_gdt_entry(get_cpu_gdt_table(cpu),
+			GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
 static int
-cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
+vgetcpu_cpu_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
-		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+		smp_call_function_single(cpu, vgetcpu_cpu_init, NULL, 1);
 
 	return NOTIFY_DONE;
 }
 
-static int __init vsyscall_init(void)
+static int __init init_vdso(void)
 {
+	init_vdso_image(&vdso_image_64);
+
+#ifdef CONFIG_X86_X32_ABI
+	init_vdso_image(&vdso_image_x32);
+#endif
+
 	cpu_notifier_register_begin();
 
-	on_each_cpu(cpu_vsyscall_init, NULL, 1);
+	on_each_cpu(vgetcpu_cpu_init, NULL, 1);
 	/* notifier priority > KVM */
-	__hotcpu_notifier(cpu_vsyscall_notifier, 30);
+	__hotcpu_notifier(vgetcpu_cpu_notifier, 30);
 
 	cpu_notifier_register_done();
 
 	return 0;
 }
-__initcall(vsyscall_init);
-#endif
+subsys_initcall(init_vdso);
+#endif /* CONFIG_X86_64 */
-- 
1.9.3

