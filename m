Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3HEVTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:19:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3HEVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:19:17 -0400
Date: Mon, 5 Aug 2013 14:18:21 -0700
Message-Id: <201308052118.r75LILIt008981@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.11-rc5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: andrew.cooper3@citrix.com, bp@suse.de, ddutile@redhat.com,
        dzickus@redhat.com, hpa@linux.intel.com, hpa@zytor.com,
        jbeulich@suse.com, joro@8bytes.org, just.for.lkml@googlemail.com,
        linux-kernel@vger.kernel.org, malcolm.crossley@citrix.com,
        matt.fleming@intel.com, mingo@kernel.org, nhorman@tuxdriver.com,
        prarit@redhat.com, roy.franz@linaro.org, stable@vger.kernel.org,
        tglx@linutronix.de
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 05 Aug 2013 14:18:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b3a3a9c441e2c8f6b6760de9331023a7906a4ac6:

  Merge tag 'trace-3.11-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2013-07-22 19:07:24 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to d982057f631df04f8d78321084a1a71ca51f3364:

  x86, amd, microcode: Fix error path in apply_microcode_amd() (2013-07-31 08:37:14 -0700)

----------------------------------------------------------------
H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Ingo Molnar (1):
      Merge tag 'efi-urgent' of git://git.kernel.org/.../mfleming/efi into x86/urgent

Neil Horman (1):
      x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset

Roy Franz (1):
      x86, efi: correct call to free_pages

Torsten Kaiser (1):
      x86, amd, microcode: Fix error path in apply_microcode_amd()

 arch/x86/boot/compressed/eboot.c |  2 +-
 arch/x86/kernel/early-quirks.c   | 14 ++++++++++++--
 arch/x86/kernel/i387.c           |  2 +-
 arch/x86/kernel/microcode_amd.c  |  9 +++++----
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index d606463..b7388a4 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -225,7 +225,7 @@ static void low_free(unsigned long size, unsigned long addr)
 	unsigned long nr_pages;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table->boottime->free_pages, addr, size);
+	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
 }
 
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 94ab6b9..63bdb29 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -196,15 +196,23 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 static void __init intel_remapping_check(int num, int slot, int func)
 {
 	u8 revision;
+	u16 device;
 
+	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
 
 	/*
-	 * Revision 0x13 of this chipset supports irq remapping
-	 * but has an erratum that breaks its behavior, flag it as such
+ 	 * Revision 13 of all triggering devices id in this quirk have
+	 * a problem draining interrupts when irq remapping is enabled,
+	 * and should be flagged as broken.  Additionally revisions 0x12
+	 * and 0x22 of device id 0x3405 has this problem.
 	 */
 	if (revision == 0x13)
 		set_irq_remapping_broken();
+	else if ((device == 0x3405) &&
+	    ((revision == 0x12) ||
+	     (revision == 0x22)))
+		set_irq_remapping_broken();
 
 }
 
@@ -239,6 +247,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3405, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{}
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 202d24f..5d576ab 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -116,7 +116,7 @@ static void mxcsr_feature_mask_init(void)
 
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		asm volatile("fxsave %0" : "+m" (fx_scratch));
 		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 47ebb1d..7a0adb7 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -220,12 +220,13 @@ int apply_microcode_amd(int cpu)
 		return 0;
 	}
 
-	if (__apply_microcode_amd(mc_amd))
+	if (__apply_microcode_amd(mc_amd)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
-	else
-		pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
-			mc_amd->hdr.patch_id);
+		return -1;
+	}
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
+		mc_amd->hdr.patch_id);
 
 	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
 	c->microcode = mc_amd->hdr.patch_id;
