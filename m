Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271Ab3HHT3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:29:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966204Ab3HHT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:29:46 -0400
Date: Thu, 8 Aug 2013 21:29:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, AMD: simplify load_microcode_amd() to fix early
 microcode loading to no longer access uninitialized per-cpu data
Message-ID: <20130808192943.GF27974@pd.tnic>
References: <20130723230610.73bd048d@googlemail.com>
 <20130724193250.GO30777@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130724193250.GO30777@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 09:32:50PM +0200, Borislav Petkov wrote:
> Btw, this patch is the one that fixes the boot issue on your box,
> correct?
>
> If so, please put a minimal version of it in the next patch set you're
> sending right after

Ok, I've wiggled it ontop of the cpu_has_amd_erratum() patch, see below.
Can you guys - Torsten and Johannes - run this branch here:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git amd-ucode

to check whether you can boot your boxes with he failing configs? I
mean, I tried reproducing with your configs on my F10h box and no luck -
box boots just fine. And it is affected by E400 so...

In any case, the two patches make sense regardless so if they fix your
issues, I'd like to send them upwards soonish.

Thanks.

--
From: Torsten Kaiser <just.for.lkml@googlemail.com>
Date: Thu, 8 Aug 2013 19:38:18 +0200
Subject: [PATCH] x86, microcode, AMD: Fix early microcode loading

load_microcode_amd() (and the helper it is using) should not have an
cpu parameter. The microcode loading does not depend on the CPU wrt the
patches loaded since they will end up in a global list for all CPUs
anyway.

The change from cpu to x86family in load_microcode_amd()
now allows to drop the code messing with cpu_data(cpu) from
collect_cpu_info_amd_early(), which is wrong anyway because at that
point the per-cpu cpu_info is not yet setup (These values would later be
overwritten by smp_store_boot_cpu_info() / smp_store_cpu_info()).

Fold the rest of collect_cpu_info_amd_early() into load_ucode_amd_ap(),
because its only used at one place and without the cpuinfo_x86 accesses
it was not much left.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
[ Boris: adapt it to current tree. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode_amd.h  |  2 +-
 arch/x86/kernel/microcode_amd.c       | 23 +++++++++++------------
 arch/x86/kernel/microcode_amd_early.c | 27 +++++++++++++--------------
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 50e5c58ced23..4c019179a57d 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -59,7 +59,7 @@ static inline u16 find_equiv_id(struct equiv_cpu_entry *equiv_cpu_table,
 
 extern int __apply_microcode_amd(struct microcode_amd *mc_amd);
 extern int apply_microcode_amd(int cpu);
-extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size);
+extern enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 #ifdef CONFIG_MICROCODE_AMD_EARLY
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7a0adb7ee433..6e2010c0f86d 100644
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
 
@@ -373,14 +372,14 @@ static enum ucode_state __load_microcode_amd(int cpu, const u8 *data, size_t siz
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
@@ -441,7 +440,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(cpu, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 1d14ffee5749..6073104ccaa3 100644
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
 
-- 
1.8.3


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
