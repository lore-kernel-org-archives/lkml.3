Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3HSLYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:24:05 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55961 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3HSLYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:24:03 -0400
Date: Mon, 19 Aug 2013 13:23:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130819112358.GA763@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: ccb1f55e710b78e1ea1de769bcab2d1e1abe8457 Merge tag 'amd_ucode_fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/urgent

Two AMD microcode loader fixes and an OLPC firmware support 
fix.

 Thanks,

	Ingo

------------------>
Daniel Drake (1):
      x86: Don't clear olpc_ofw_header when sentinel is detected

Torsten Kaiser (2):
      x86, microcode, AMD: Make cpu_has_amd_erratum() use the correct struct cpuinfo_x86
      x86, microcode, AMD: Fix early microcode loading


 arch/x86/include/asm/bootparam_utils.h |  4 ++--
 arch/x86/include/asm/microcode_amd.h   |  2 +-
 arch/x86/kernel/cpu/amd.c              | 20 +++++---------------
 arch/x86/kernel/microcode_amd.c        | 27 +++++++++++++--------------
 arch/x86/kernel/microcode_amd_early.c  | 27 +++++++++++++--------------
 5 files changed, 34 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 653668d..4a8cb8d 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -35,9 +35,9 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 	 */
 	if (boot_params->sentinel) {
 		/* fields in boot_params are left uninitialized, clear them */
-		memset(&boot_params->olpc_ofw_header, 0,
+		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
-			(char *)&boot_params->olpc_ofw_header);
+			(char *)&boot_params->ext_ramdisk_image);
 		memset(&boot_params->kbd_status, 0,
 		       (char *)&boot_params->hdr -
 		       (char *)&boot_params->kbd_status);
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 50e5c58..4c01917 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 #ifdef CONFIG_MICROCODE_AMD_EARLY
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f654ece..08a0890 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -512,7 +512,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 
 static const int amd_erratum_383[];
 static const int amd_erratum_400[];
-static bool cpu_has_amd_erratum(const int *erratum);
+static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
 static void init_amd(struct cpuinfo_x86 *c)
 {
@@ -729,11 +729,11 @@ static void init_amd(struct cpuinfo_x86 *c)
 		value &= ~(1ULL << 24);
 		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
 
-		if (cpu_has_amd_erratum(amd_erratum_383))
+		if (cpu_has_amd_erratum(c, amd_erratum_383))
 			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 	}
 
-	if (cpu_has_amd_erratum(amd_erratum_400))
+	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
@@ -878,23 +878,13 @@ static const int amd_erratum_400[] =
 static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
-static bool cpu_has_amd_erratum(const int *erratum)
+
+static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {
-	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
 	int osvw_id = *erratum++;
 	u32 range;
 	u32 ms;
 
-	/*
-	 * If called early enough that current_cpu_data hasn't been initialized
-	 * yet, fall back to boot_cpu_data.
-	 */
-	if (cpu->x86 == 0)
-		cpu = &boot_cpu_data;
-
-	if (cpu->x86_vendor != X86_VENDOR_AMD)
-		return false;
-
 	if (osvw_id >= 0 && osvw_id < 65536 &&
 	    cpu_has(cpu, X86_FEATURE_OSVW)) {
 		u64 osvw_len;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7a0adb7..7123b5d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -145,10 +145,9 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	return 0;
 }
 
-static unsigned int verify_patch_size(int cpu, u32 patch_size,
+static unsigned int verify_patch_size(u8 family, u32 patch_size,
 				      unsigned int size)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 max_size;
 
 #define F1XH_MPB_MAX_SIZE 2048
@@ -156,7 +155,7 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 #define F15H_MPB_MAX_SIZE 4096
 #define F16H_MPB_MAX_SIZE 3458
 
-	switch (c->x86) {
+	switch (family) {
 	case 0x14:
 		max_size = F14H_MPB_MAX_SIZE;
 		break;
@@ -277,9 +276,8 @@ static void cleanup(void)
  * driver cannot continue functioning normally. In such cases, we tear
  * down everything we've used up so far and exit.
  */
-static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
+static int verify_and_add_patch(u8 family, u8 *fw, unsigned int leftover)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct microcode_header_amd *mc_hdr;
 	struct ucode_patch *patch;
 	unsigned int patch_size, crnt_size, ret;
@@ -299,7 +297,7 @@ static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
 
 	/* check if patch is for the current family */
 	proc_fam = ((proc_fam >> 8) & 0xf) + ((proc_fam >> 20) & 0xff);
-	if (proc_fam != c->x86)
+	if (proc_fam != family)
 		return crnt_size;
 
 	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
@@ -308,7 +306,7 @@ static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
 		return crnt_size;
 	}
 
-	ret = verify_patch_size(cpu, patch_size, leftover);
+	ret = verify_patch_size(family, patch_size, leftover);
 	if (!ret) {
 		pr_err("Patch-ID 0x%08x: size mismatch.\n", mc_hdr->patch_id);
 		return crnt_size;
@@ -339,7 +337,8 @@ static int verify_and_add_patch(unsigned int cpu, u8 *fw, unsigned int leftover)
 	return crnt_size;
 }
 
-static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t size)
+static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
+					     size_t size)
 {
 	enum ucode_state ret = UCODE_ERROR;
 	unsigned int leftover;
@@ -362,7 +361,7 @@ static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t siz
 	}
 
 	while (leftover) {
-		crnt_size = verify_and_add_patch(cpu, fw, leftover);
+		crnt_size = verify_and_add_patch(family, fw, leftover);
 		if (crnt_size < 0)
 			return ret;
 
@@ -373,22 +372,22 @@ static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t siz
 	return UCODE_OK;
 }
 
-enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
+enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
 	enum ucode_state ret;
 
 	/* free old equiv table */
 	free_equiv_cpu_table();
 
-	ret = __load_microcode_amd(cpu, data, size);
+	ret = __load_microcode_amd(family, data, size);
 
 	if (ret != UCODE_OK)
 		cleanup();
 
 #if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
 	/* save BSP's matching patch for early load */
-	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
-		struct ucode_patch *p = find_patch(cpu);
+	if (cpu_data(smp_processor_id()).cpu_index == boot_cpu_data.cpu_index) {
+		struct ucode_patch *p = find_patch(smp_processor_id());
 		if (p) {
 			memset(amd_bsp_mpb, 0, MPB_MAX_SIZE);
 			memcpy(amd_bsp_mpb, p->data, min_t(u32, ksize(p->data),
@@ -441,7 +440,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 1d14ffe..6073104 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -238,25 +238,17 @@ static void __init collect_cpu_sig_on_bsp(void *arg)
 	uci->cpu_sig.sig = cpuid_eax(0x00000001);
 }
 #else
-static void collect_cpu_info_amd_early(struct cpuinfo_x86 *c,
-						 struct ucode_cpu_info *uci)
+void load_ucode_amd_ap(void)
 {
+	unsigned int cpu = smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	u32 rev, eax;
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 	eax = cpuid_eax(0x00000001);
 
-	uci->cpu_sig.sig = eax;
 	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
-	c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
-}
-
-void load_ucode_amd_ap(void)
-{
-	unsigned int cpu = smp_processor_id();
-
-	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
+	uci->cpu_sig.sig = eax;
 
 	if (cpu && !ucode_loaded) {
 		void *ucode;
@@ -265,8 +257,10 @@ void load_ucode_amd_ap(void)
 			return;
 
 		ucode = (void *)(initrd_start + ucode_offset);
-		if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
+		eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
+		if (load_microcode_amd(eax, ucode, ucode_size) != UCODE_OK)
 			return;
+
 		ucode_loaded = true;
 	}
 
@@ -278,6 +272,8 @@ int __init save_microcode_in_initrd_amd(void)
 {
 	enum ucode_state ret;
 	void *ucode;
+	u32 eax;
+
 #ifdef CONFIG_X86_32
 	unsigned int bsp = boot_cpu_data.cpu_index;
 	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
@@ -293,7 +289,10 @@ int __init save_microcode_in_initrd_amd(void)
 		return 0;
 
 	ucode = (void *)(initrd_start + ucode_offset);
-	ret = load_microcode_amd(0, ucode, ucode_size);
+	eax   = cpuid_eax(0x00000001);
+	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
+
+	ret = load_microcode_amd(eax, ucode, ucode_size);
 	if (ret != UCODE_OK)
 		return -EINVAL;
 
