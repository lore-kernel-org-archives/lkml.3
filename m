Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3BCQPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:15:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42596 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3BCQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:14:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] x86, 32-bit: Drop new_cpu_data
Date: Sun,  3 Feb 2013 17:14:39 +0100
Message-Id: <1359908079-10469-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
In-Reply-To: <1359908079-10469-1-git-send-email-bp@alien8.de>
References: <1359908079-10469-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We copy it to boot_cpu_data anyway so use boot_cpu_data from the get-go.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/processor.h |  1 -
 arch/x86/kernel/head_32.S        | 17 ++++++++---------
 arch/x86/kernel/setup.c          |  3 ---
 arch/x86/lguest/boot.c           |  6 +++---
 arch/x86/xen/enlighten.c         |  8 ++++----
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cf500543f6ff..984223f93293 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -149,7 +149,6 @@ struct cpuinfo_x86 {
  * capabilities of CPUs
  */
 extern struct cpuinfo_x86	boot_cpu_data;
-extern struct cpuinfo_x86	new_cpu_data;
 
 extern struct tss_struct	doublefault_tss;
 extern __u32			cpu_caps_cleared[NCAPINTS];
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0dba3598cf02..fe77ec1202a5 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -27,17 +27,16 @@
 #define pa(X) ((X) - __PAGE_OFFSET)
 
 /*
- * References to members of the new_cpu_data structure.
+ * References to members of the boot_cpu_data structure.
  */
-#define X86		new_cpu_data+CPUINFO_x86
-#define X86_VENDOR	new_cpu_data+CPUINFO_x86_vendor
-#define X86_MODEL	new_cpu_data+CPUINFO_x86_model
-#define X86_MASK	new_cpu_data+CPUINFO_x86_mask
-#define X86_HARD_MATH	new_cpu_data+CPUINFO_hard_math
-#define X86_CAPABILITY	new_cpu_data+CPUINFO_x86_capability
-#define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
-
+#define X86		boot_cpu_data+CPUINFO_x86
+#define X86_VENDOR	boot_cpu_data+CPUINFO_x86_vendor
+#define X86_MODEL	boot_cpu_data+CPUINFO_x86_model
+#define X86_MASK	boot_cpu_data+CPUINFO_x86_mask
+#define X86_HARD_MATH	boot_cpu_data+CPUINFO_hard_math
 #define X86_CPUID	boot_cpu_data+CPUINFO_cpuid_level
+#define X86_CAPABILITY	boot_cpu_data+CPUINFO_x86_capability
+#define X86_VENDOR_ID	boot_cpu_data+CPUINFO_x86_vendor_id
 
 /*
  * This is how much memory in addition to the memory covered up to
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4f322b3eb078..548044f751fc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -171,8 +171,6 @@ static struct resource bss_resource = {
 
 
 #ifdef CONFIG_X86_32
-/* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 EXPORT_SYMBOL(boot_cpu_data);
@@ -749,7 +747,6 @@ early_param("reservelow", parse_reservelow);
 void __init setup_arch(char **cmdline_p)
 {
 #ifdef CONFIG_X86_32
-	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
 
 	/*
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 1cbd89ca5569..bd222f2495f4 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1404,12 +1404,12 @@ __init void lguest_init(void)
 	 * This is messy CPU setup stuff which the native boot code does before
 	 * start_kernel, so we have to do, too:
 	 */
-	cpu_detect(&new_cpu_data);
+	cpu_detect(&boot_cpu_data);
 	/* head.S usually sets up the first capability word, so do it here. */
-	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+	boot_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Math is always hard! */
-	new_cpu_data.hard_math = 1;
+	boot_cpu_data.hard_math = 1;
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 8b4c56d85ca0..85871df3cc68 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1454,10 +1454,10 @@ asmlinkage void __init xen_start_kernel(void)
 
 #ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
-	cpu_detect(&new_cpu_data);
-	new_cpu_data.hard_math = 1;
-	new_cpu_data.wp_works_ok = 1;
-	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+	cpu_detect(&boot_cpu_data);
+	boot_cpu_data.hard_math = 1;
+	boot_cpu_data.wp_works_ok = 1;
+	boot_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
 
 	/* Poke various useful things into boot_params */
-- 
1.8.1.2.422.g08c0e7f

