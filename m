Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaLFPcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:32:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54227 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbaLFPbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:31:52 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86, microcode: Reload microcode on resume
Date: Sat,  6 Dec 2014 16:31:48 +0100
Message-Id: <1417879908-4851-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1417879908-4851-1-git-send-email-bp@alien8.de>
References: <1417879908-4851-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Normally, we do reapply microcode on resume. However, in the cases where
that microcode comes from the early loader and the late loader hasn't
been utilized yet, there's no easy way for us to go and apply the patch
applied during boot by the early loader.

Thus, reuse the patch stashed by the early loader for the BSP.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode.h            |  2 ++
 arch/x86/include/asm/microcode_amd.h        |  2 ++
 arch/x86/include/asm/microcode_intel.h      |  2 ++
 arch/x86/kernel/cpu/microcode/amd_early.c   | 18 +++++++++++
 arch/x86/kernel/cpu/microcode/core.c        |  8 +----
 arch/x86/kernel/cpu/microcode/core_early.c  | 21 +++++++++++++
 arch/x86/kernel/cpu/microcode/intel_early.c | 47 +++++++++++++++++++++++------
 7 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 64dc362506b7..201b520521ed 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -78,6 +78,7 @@ static inline void __exit exit_amd_microcode(void) {}
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
 extern int __init save_microcode_in_initrd(void);
+void reload_early_microcode(void);
 #else
 static inline void __init load_ucode_bsp(void) {}
 static inline void load_ucode_ap(void) {}
@@ -85,6 +86,7 @@ static inline int __init save_microcode_in_initrd(void)
 {
 	return 0;
 }
+static inline void reload_early_microcode(void) {}
 #endif
 
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 48a48024ebe4..af935397e053 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -68,10 +68,12 @@ extern u8 amd_ucode_patch[PATCH_MAX_SIZE];
 extern void __init load_ucode_amd_bsp(void);
 extern void load_ucode_amd_ap(void);
 extern int __init save_microcode_in_initrd_amd(void);
+void reload_ucode_amd(void);
 #else
 static inline void __init load_ucode_amd_bsp(void) {}
 static inline void load_ucode_amd_ap(void) {}
 static inline int __init save_microcode_in_initrd_amd(void) { return -EINVAL; }
+void reload_ucode_amd(void) {}
 #endif
 
 #endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index bbe296e0bce1..dd4c20043ce7 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -68,11 +68,13 @@ extern void __init load_ucode_intel_bsp(void);
 extern void load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
 extern int __init save_microcode_in_initrd_intel(void);
+void reload_ucode_intel(void);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
 static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
+static inline void reload_ucode_intel(void) {}
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 3d988a30a21d..737737edbd1e 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -402,3 +402,21 @@ int __init save_microcode_in_initrd_amd(void)
 
 	return retval;
 }
+
+void reload_ucode_amd(void)
+{
+	struct microcode_amd *mc;
+	u32 rev, eax;
+
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
+
+	mc = (struct microcode_amd *)amd_ucode_patch;
+
+	if (mc && rev < mc->hdr.patch_id) {
+		if (!__apply_microcode_amd(mc)) {
+			ucode_new_rev = mc->hdr.patch_id;
+			pr_info("microcode: reload patch_level=0x%08x\n",
+				ucode_new_rev);
+		}
+	}
+}
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index ebd232d7de4d..15c29096136b 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -466,13 +466,7 @@ static void mc_bp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		/*
-		 * We might resume and not have applied late microcode but still
-		 * have a newer patch stashed from the early loader. We don't
-		 * have it in uci->mc so we have to load it the same way we're
-		 * applying patches early on the APs.
-		 */
-		load_ucode_ap();
+		reload_early_microcode();
 }
 
 static struct syscore_ops mc_syscore_ops = {
diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
index 2c017f242a78..d45df4bd16ab 100644
--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -176,3 +176,24 @@ int __init save_microcode_in_initrd(void)
 
 	return 0;
 }
+
+void reload_early_microcode(void)
+{
+	int vendor, x86;
+
+	vendor = x86_vendor();
+	x86 = x86_family();
+
+	switch (vendor) {
+	case X86_VENDOR_INTEL:
+		if (x86 >= 6)
+			reload_ucode_intel();
+		break;
+	case X86_VENDOR_AMD:
+		if (x86 >= 0x10)
+			reload_ucode_amd();
+		break;
+	default:
+		break;
+	}
+}
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 31e7576a123c..f04d0d6638ca 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -34,6 +34,8 @@ static struct mc_saved_data {
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
 
+static struct microcode_intel bsp_patch;
+
 static enum ucode_state
 generic_load_microcode_early(struct microcode_intel **mc_saved_p,
 			     unsigned int mc_saved_count,
@@ -650,7 +652,7 @@ static inline void print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int apply_microcode_early(struct ucode_cpu_info *uci)
+static int apply_microcode_early(struct ucode_cpu_info *uci, bool early)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -679,7 +681,10 @@ static int apply_microcode_early(struct ucode_cpu_info *uci)
 #endif
 	uci->cpu_sig.rev = val[1];
 
-	print_ucode(uci);
+	if (early)
+		print_ucode(uci);
+	else
+		print_ucode_info(uci, mc_intel->hdr.date);
 
 	return 0;
 }
@@ -712,14 +717,22 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 		      unsigned long *mc_saved_in_initrd,
 		      unsigned long initrd_start_early,
 		      unsigned long initrd_end_early,
-		      struct ucode_cpu_info *uci)
+		      struct ucode_cpu_info *uci,
+		      struct microcode_intel *bsp)
 {
+	enum ucode_state ret;
+
 	collect_cpu_info_early(uci);
 	scan_microcode(initrd_start_early, initrd_end_early, mc_saved_data,
 		       mc_saved_in_initrd, uci);
-	load_microcode(mc_saved_data, mc_saved_in_initrd,
-		       initrd_start_early, uci);
-	apply_microcode_early(uci);
+
+	ret = load_microcode(mc_saved_data, mc_saved_in_initrd,
+			     initrd_start_early, uci);
+
+	if (ret == UCODE_OK) {
+		apply_microcode_early(uci, true);
+		memcpy(bsp, uci->mc, sizeof(*bsp));
+	}
 }
 
 void __init
@@ -728,10 +741,12 @@ load_ucode_intel_bsp(void)
 	u64 ramdisk_image, ramdisk_size;
 	unsigned long initrd_start_early, initrd_end_early;
 	struct ucode_cpu_info uci;
+	struct microcode_intel *bsp_p;
 #ifdef CONFIG_X86_32
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
+	bsp_p	      = (struct microcode_intel *)__pa_nodebug(&bsp_patch);
 	ramdisk_image = boot_params_p->hdr.ramdisk_image;
 	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image;
@@ -740,15 +755,17 @@ load_ucode_intel_bsp(void)
 	_load_ucode_intel_bsp(
 		(struct mc_saved_data *)__pa_nodebug(&mc_saved_data),
 		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
-		initrd_start_early, initrd_end_early, &uci);
+		initrd_start_early, initrd_end_early, &uci, bsp_p);
 #else
+	bsp_p	      = &bsp_patch;
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
 	_load_ucode_intel_bsp(&mc_saved_data, mc_saved_in_initrd,
-			      initrd_start_early, initrd_end_early, &uci);
+			      initrd_start_early, initrd_end_early,
+			      &uci, bsp_p);
 #endif
 }
 
@@ -782,5 +799,17 @@ void load_ucode_intel_ap(void)
 	collect_cpu_info_early(&uci);
 	load_microcode(mc_saved_data_p, mc_saved_in_initrd_p,
 		       initrd_start_addr, &uci);
-	apply_microcode_early(&uci);
+	apply_microcode_early(&uci, true);
+}
+
+void reload_ucode_intel(void)
+{
+	struct ucode_cpu_info uci;
+
+	if (!bsp_patch.hdr.rev)
+		return;
+
+	uci.mc = &bsp_patch;
+
+	apply_microcode_early(&uci, false);
 }
-- 
2.0.0

