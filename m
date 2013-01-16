Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3APGl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:41:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47907 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3APGlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:41:55 -0500
Date: Tue, 15 Jan 2013 22:41:23 -0800
Message-Id: <201301160641.r0G6fNC8020143@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.8-rc4
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is mainly a workaround for a bug in Sandy Bridge graphics which
cause corruption of certain memory pages.

The following changes since commit 787314c35fbb97e02823a1b8eb8cfa58f366cd49:

  Merge tag 'iommu-updates-v3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu (2012-12-20 10:07:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

The head of this tree is e43b3cec711a61edf047adf6204d542f3a659ef8:
  x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI (2013-01-13 20:58:57 -0800)

----------------------------------------------------------------
H. Peter Anvin (2):
      x86/Sandy Bridge: mark arrays in __init functions as __initconst
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Sasha Levin (1):
      x86, efi: correct precedence of operators in setup_efi_pci

 arch/x86/boot/compressed/eboot.c |  2 +-
 arch/x86/kernel/setup.c          | 80 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..18e329c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -302,7 +302,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
+		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
 			continue;
 
 		if (!pci->romimage || !pci->romsize)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 23ddd55..00f6c14 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -610,6 +610,83 @@ static __init void reserve_ibft_region(void)
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
+static bool __init snb_gfx_workaround_needed(void)
+{
+#ifdef CONFIG_PCI
+	int i;
+	u16 vendor, devid;
+	static const __initconst u16 snb_ids[] = {
+		0x0102,
+		0x0112,
+		0x0122,
+		0x0106,
+		0x0116,
+		0x0126,
+		0x010a,
+	};
+
+	/* Assume no if something weird is going on with PCI */
+	if (!early_pci_allowed())
+		return false;
+
+	vendor = read_pci_config_16(0, 2, 0, PCI_VENDOR_ID);
+	if (vendor != 0x8086)
+		return false;
+
+	devid = read_pci_config_16(0, 2, 0, PCI_DEVICE_ID);
+	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
+		if (devid == snb_ids[i])
+			return true;
+#endif
+
+	return false;
+}
+
+/*
+ * Sandy Bridge graphics has trouble with certain ranges, exclude
+ * them from allocation.
+ */
+static void __init trim_snb_memory(void)
+{
+	static const __initconst unsigned long bad_pages[] = {
+		0x20050000,
+		0x20110000,
+		0x20130000,
+		0x20138000,
+		0x40004000,
+	};
+	int i;
+
+	if (!snb_gfx_workaround_needed())
+		return;
+
+	printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
+
+	/*
+	 * Reserve all memory below the 1 MB mark that has not
+	 * already been reserved.
+	 */
+	memblock_reserve(0, 1<<20);
+	
+	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
+		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
+			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
+			       bad_pages[i]);
+	}
+}
+
+/*
+ * Here we put platform-specific memory range workarounds, i.e.
+ * memory known to be corrupt or otherwise in need to be reserved on
+ * specific platforms.
+ *
+ * If this gets used more widely it could use a real dispatch mechanism.
+ */
+static void __init trim_platform_memory_ranges(void)
+{
+	trim_snb_memory();
+}
+
 static void __init trim_bios_range(void)
 {
 	/*
@@ -630,6 +707,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
@@ -908,6 +986,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
+	trim_platform_memory_ranges();
+
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
