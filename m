Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaLJMnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:43:02 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60860 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaLJMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:43:00 -0500
Date: Wed, 10 Dec 2014 13:42:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86/microcode tree changes for v3.19
Message-ID: <20141210124254.GA25436@gmail.com>
References: <20141209132745.GA31656@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209132745.GA31656@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest x86-microcode-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus
> 
>    # HEAD: e913b8cd4548cd0a407b7debd6ec9104e84d050d Merge tag 'microcode_fixes_for_3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/microcode
> 
> The main changes in this cycle are:
> 
>   - Reload microcode when resuming and the case when only the 
>     early loader has been utilized. (Borislav Petkov)
> 
>   - Also, do not load the driver on paravirt guests.
>     (Boris Ostrovsky)

There's one more fix from Boris that I forgot to apply - find the 
updated pull request below.

(If you already pulled the previous tree then you can safely pull 
this tree on top of it.)

Thanks,

	Ingo

=====================================>

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

   # HEAD: 25cdb9c86826f8d035d8aaa07fc36832e76bd8a0 x86/microcode/intel: Fish out the stashed microcode for the BSP

The main changes in this cycle are:
 
  - Reload microcode when resuming and the case when only the 
    early loader has been utilized. (Borislav Petkov)

  - Also, do not load the driver on paravirt guests.
    (Boris Ostrovsky)

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (1):
      x86, microcode: Don't initialize microcode code on paravirt

Borislav Petkov (4):
      x86, microcode, AMD: Do not use smp_processor_id() in preemtible context
      x86, microcode, intel: Drop unused parameter
      x86, microcode: Reload microcode on resume
      x86/microcode/intel: Fish out the stashed microcode for the BSP


 arch/x86/include/asm/microcode.h            |  2 ++
 arch/x86/include/asm/microcode_amd.h        |  4 ++-
 arch/x86/include/asm/microcode_intel.h      |  2 ++
 arch/x86/kernel/cpu/microcode/amd.c         |  8 +++---
 arch/x86/kernel/cpu/microcode/amd_early.c   | 20 +++++++++++++-
 arch/x86/kernel/cpu/microcode/core.c        | 10 ++-----
 arch/x86/kernel/cpu/microcode/core_early.c  | 21 +++++++++++++++
 arch/x86/kernel/cpu/microcode/intel_early.c | 42 +++++++++++++++++++++++------
 8 files changed, 87 insertions(+), 22 deletions(-)

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
index b7b10b82d3e5..af935397e053 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size);
 
 #define PATCH_MAX_SIZE PAGE_SIZE
 extern u8 amd_ucode_patch[PATCH_MAX_SIZE];
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
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 8fffd845e22b..bfbbe6195e2d 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -376,7 +376,7 @@ static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
 	return UCODE_OK;
 }
 
-enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
+enum ucode_state load_microcode_amd(int cpu, u8 family, const u8 *data, size_t size)
 {
 	enum ucode_state ret;
 
@@ -390,8 +390,8 @@ enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 
 #if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
 	/* save BSP's matching patch for early load */
-	if (cpu_data(smp_processor_id()).cpu_index == boot_cpu_data.cpu_index) {
-		struct ucode_patch *p = find_patch(smp_processor_id());
+	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p = find_patch(cpu);
 		if (p) {
 			memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
 			memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data),
@@ -444,7 +444,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(cpu, c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 06674473b0e6..737737edbd1e 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -389,7 +389,7 @@ int __init save_microcode_in_initrd_amd(void)
 	eax   = cpuid_eax(0x00000001);
 	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
 
-	ret = load_microcode_amd(eax, container, container_size);
+	ret = load_microcode_amd(smp_processor_id(), eax, container, container_size);
 	if (ret != UCODE_OK)
 		retval = -EINVAL;
 
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
index 2ce9051174e6..15c29096136b 100644
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
@@ -557,7 +551,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (dis_ucode_ldr)
+	if (paravirt_enabled() || dis_ucode_ldr)
 		return 0;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
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
index b88343f7a3b3..ec9df6f9cd47 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -650,8 +650,7 @@ static inline void print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
-				 struct ucode_cpu_info *uci)
+static int apply_microcode_early(struct ucode_cpu_info *uci, bool early)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -680,7 +679,10 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 #endif
 	uci->cpu_sig.rev = val[1];
 
-	print_ucode(uci);
+	if (early)
+		print_ucode(uci);
+	else
+		print_ucode_info(uci, mc_intel->hdr.date);
 
 	return 0;
 }
@@ -715,12 +717,17 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 		      unsigned long initrd_end_early,
 		      struct ucode_cpu_info *uci)
 {
+	enum ucode_state ret;
+
 	collect_cpu_info_early(uci);
 	scan_microcode(initrd_start_early, initrd_end_early, mc_saved_data,
 		       mc_saved_in_initrd, uci);
-	load_microcode(mc_saved_data, mc_saved_in_initrd,
-		       initrd_start_early, uci);
-	apply_microcode_early(mc_saved_data, uci);
+
+	ret = load_microcode(mc_saved_data, mc_saved_in_initrd,
+			     initrd_start_early, uci);
+
+	if (ret == UCODE_OK)
+		apply_microcode_early(uci, true);
 }
 
 void __init
@@ -749,7 +756,8 @@ load_ucode_intel_bsp(void)
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
 	_load_ucode_intel_bsp(&mc_saved_data, mc_saved_in_initrd,
-			      initrd_start_early, initrd_end_early, &uci);
+			      initrd_start_early, initrd_end_early,
+			      &uci);
 #endif
 }
 
@@ -783,5 +791,23 @@ void load_ucode_intel_ap(void)
 	collect_cpu_info_early(&uci);
 	load_microcode(mc_saved_data_p, mc_saved_in_initrd_p,
 		       initrd_start_addr, &uci);
-	apply_microcode_early(mc_saved_data_p, &uci);
+	apply_microcode_early(&uci, true);
+}
+
+void reload_ucode_intel(void)
+{
+	struct ucode_cpu_info uci;
+	enum ucode_state ret;
+
+	if (!mc_saved_data.mc_saved_count)
+		return;
+
+	collect_cpu_info_early(&uci);
+
+	ret = generic_load_microcode_early(mc_saved_data.mc_saved,
+					   mc_saved_data.mc_saved_count, &uci);
+	if (ret != UCODE_OK)
+		return;
+
+	apply_microcode_early(&uci, false);
 }
