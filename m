Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaJ1LQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:16:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJ1LQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:16:28 -0400
Date: Tue, 28 Oct 2014 04:16:17 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-1c0c1b93df4dad43b8050db005bb1c03bc7e09bf@git.kernel.org>
Cc: luto@amacapital.net, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <945c463e2804fedd8b08d63a040cbe85d55195aa.1411494540.git.luto@amacapital.net>
References: <945c463e2804fedd8b08d63a040cbe85d55195aa.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vdso:
  Clean up vgetcpu init and merge the vdso initcalls
Git-Commit-ID: 1c0c1b93df4dad43b8050db005bb1c03bc7e09bf
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

Commit-ID:  1c0c1b93df4dad43b8050db005bb1c03bc7e09bf
Gitweb:     http://git.kernel.org/tip/1c0c1b93df4dad43b8050db005bb1c03bc7e09bf
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:57 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:14 +0100

x86_64/vdso: Clean up vgetcpu init and merge the vdso initcalls

Now vdso/vma.c has a single initcall and no references to
"vsyscall".

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/945c463e2804fedd8b08d63a040cbe85d55195aa.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vma.c | 54 ++++++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 32ca60c..a280b11 100644
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
@@ -11,18 +12,16 @@
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/cpu.h>
-#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
+#include <asm/vvar.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
 #include <asm/desc.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
-
-extern unsigned short vdso_sync_cpuid;
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
@@ -40,20 +39,6 @@ void __init init_vdso_image(const struct vdso_image *image)
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
@@ -242,12 +227,9 @@ __setup("vdso=", vdso_setup);
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
 	struct desc_struct d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
@@ -274,34 +256,34 @@ static void vsyscall_set_cpu(int cpu)
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
-static void cpu_vsyscall_init(void *arg)
-{
-	/* preemption should be already off */
-	vsyscall_set_cpu(raw_smp_processor_id());
-}
-
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
