Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967550Ab3E3F6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:58:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:38199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967532Ab3E3F6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="321749921"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH] x86, tboot: enable SMX operation
Date: Thu, 30 May 2013 13:48:45 +0800
Message-Id: <1369892925-13118-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Safer Mode Extensions (SMX) provide a programming interface for
system software to establish a measured environment within the
platform to support trust decisions by end users.

We need enable SMX operation by setting CR4.SMXE[Bit 14] = 1,
if system has txt supported and lives in messured environment.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/uapi/asm/processor-flags.h |    1 +
 arch/x86/kernel/tboot.c                     |  100 ++++++++++++++-------------
 2 files changed, 53 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index 54991a7..9edd51f 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -61,6 +61,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+#define X86_CR4_SMXE	0x00004000 /* enable SMX operation */
 #define X86_CR4_RDWRGSFS 0x00010000 /* enable RDWRGSFS support */
 #define X86_CR4_PCIDE	0x00020000 /* enable PCID support */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..184c546 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -58,51 +58,6 @@ EXPORT_SYMBOL(tboot);
 
 static u8 tboot_uuid[16] __initdata = TBOOT_UUID;
 
-void __init tboot_probe(void)
-{
-	/* Look for valid page-aligned address for shared page. */
-	if (!boot_params.tboot_addr)
-		return;
-	/*
-	 * also verify that it is mapped as we expect it before calling
-	 * set_fixmap(), to reduce chance of garbage value causing crash
-	 */
-	if (!e820_any_mapped(boot_params.tboot_addr,
-			     boot_params.tboot_addr, E820_RESERVED)) {
-		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
-		return;
-	}
-
-	/* only a natively booted kernel should be using TXT */
-	if (paravirt_enabled()) {
-		pr_warning("non-0 tboot_addr but pv_ops is enabled\n");
-		return;
-	}
-
-	/* Map and check for tboot UUID. */
-	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
-	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
-	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
-		pr_warning("tboot at 0x%llx is invalid\n",
-			   boot_params.tboot_addr);
-		tboot = NULL;
-		return;
-	}
-	if (tboot->version < 5) {
-		pr_warning("tboot version is invalid: %u\n", tboot->version);
-		tboot = NULL;
-		return;
-	}
-
-	pr_info("found shared page at phys addr 0x%llx:\n",
-		boot_params.tboot_addr);
-	pr_debug("version: %d\n", tboot->version);
-	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
-	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
-	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
-	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
-}
-
 static pgd_t *tboot_pg_dir;
 static struct mm_struct tboot_mm = {
 	.mm_rb          = RB_ROOT,
@@ -329,6 +284,10 @@ static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
 			if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
 				return NOTIFY_BAD;
 		break;
+
+	case CPU_STARTING:
+		set_in_cr4(X86_CR4_SMXE);
+		break;
 	}
 	return NOTIFY_OK;
 }
@@ -338,6 +297,54 @@ static struct notifier_block tboot_cpu_notifier __cpuinitdata =
 	.notifier_call = tboot_cpu_callback,
 };
 
+void __init tboot_probe(void)
+{
+	/* Look for valid page-aligned address for shared page. */
+	if (!boot_params.tboot_addr)
+		return;
+	/*
+	 * also verify that it is mapped as we expect it before calling
+	 * set_fixmap(), to reduce chance of garbage value causing crash
+	 */
+	if (!e820_any_mapped(boot_params.tboot_addr,
+			     boot_params.tboot_addr, E820_RESERVED)) {
+		pr_warn("non-0 tboot_addr but it is not of type E820_RESERVED\n");
+		return;
+	}
+
+	/* only a natively booted kernel should be using TXT */
+	if (paravirt_enabled()) {
+		pr_warn("non-0 tboot_addr but pv_ops is enabled\n");
+		return;
+	}
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
+	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
+	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
+		pr_warn("tboot at 0x%llx is invalid\n",
+			   boot_params.tboot_addr);
+		tboot = NULL;
+		return;
+	}
+	if (tboot->version < 5) {
+		pr_warn("tboot version is invalid: %u\n", tboot->version);
+		tboot = NULL;
+		return;
+	}
+
+	atomic_set(&ap_wfs_count, 0);
+	register_cpu_notifier(&tboot_cpu_notifier);
+
+	pr_info("found shared page at phys addr 0x%llx:\n",
+		boot_params.tboot_addr);
+	pr_debug("version: %d\n", tboot->version);
+	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
+	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
+	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
+	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
+}
+
 static __init int tboot_late_init(void)
 {
 	if (!tboot_enabled())
@@ -345,9 +352,6 @@ static __init int tboot_late_init(void)
 
 	tboot_create_trampoline();
 
-	atomic_set(&ap_wfs_count, 0);
-	register_hotcpu_notifier(&tboot_cpu_notifier);
-
 	acpi_os_set_prepare_sleep(&tboot_sleep);
 	return 0;
 }
-- 
1.7.9.5

