Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaJMHrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:47:35 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63893 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaJMHr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:47:29 -0400
Date: Mon, 13 Oct 2014 09:47:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform tree changes for v3.18
Message-ID: <20141013074724.GA15544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: aece118e487a744eafcdd0c77fe32b55ee2092a1 x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()

The main changes in this tree are:

 - Fix and update Intel Quark [Galileo] SoC platform support

 - Update IOSF chipset side band interface and make it available 
   via debugfs

 - Enable HPETs on Soekris net6501 and other e6xx based systems


  out-of-topic modifications in x86-platform-for-linus:
  -------------------------------------------------------
  include/linux/pci_ids.h            # 2e151c70dfb0: x86: HPET force enable for e

 Thanks,

	Ingo

------------------>
Bryan O'Donoghue (3):
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
      x86: Quark: Comment setup_arch() to document TLB/PGE bug
      x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()

David E. Box (5):
      x86/iosf: Add Kconfig prompt for IOSF_MBI selection
      x86/iosf: Add debugfs support
      x86/platform/intel/iosf: Add Braswell PCI ID
      x86/platform/intel/iosf: Add better description of IOSF driver in config
      x86/platform/intel/iosf: Add debugfs config option for IOSF

Martin Kelly (1):
      x86/platform/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n

Peter Neubauer (1):
      x86: HPET force enable for e6xx based systems


 arch/x86/Kconfig            | 35 ++++++++++++++---
 arch/x86/kernel/cpu/intel.c | 32 +++++++++++++++-
 arch/x86/kernel/iosf_mbi.c  | 91 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pmc_atom.c  | 11 ++++--
 arch/x86/kernel/quirks.c    | 18 +++++++++
 arch/x86/kernel/setup.c     |  9 +++++
 include/linux/pci_ids.h     |  1 +
 7 files changed, 187 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5d0bf1aa9dcb..6354964ff949 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -479,6 +479,36 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
+config IOSF_MBI
+	tristate "Intel SoC IOSF Sideband support for SoC platforms"
+	depends on PCI
+	---help---
+	  This option enables sideband register access support for Intel SoC
+	  platforms. On these platforms the IOSF sideband is used in lieu of
+	  MSR's for some register accesses, mostly but not limited to thermal
+	  and power. Drivers may query the availability of this device to
+	  determine if they need the sideband in order to work on these
+	  platforms. The sideband is available on the following SoC products.
+	  This list is not meant to be exclusive.
+	   - BayTrail
+	   - Braswell
+	   - Quark
+
+	  You should say Y if you are running a kernel on one of these SoC's.
+
+config IOSF_MBI_DEBUG
+	bool "Enable IOSF sideband access through debugfs"
+	depends on IOSF_MBI && DEBUG_FS
+	---help---
+	  Select this option to expose the IOSF sideband access registers (MCR,
+	  MDR, MCRX) through debugfs to write and read register information from
+	  different units on the SoC. This is most useful for obtaining device
+	  state information for debug and analysis. As this is a general access
+	  mechanism, users of this option would have specific knowledge of the
+	  device they want to access.
+
+	  If you don't require the option or are in doubt, say N.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
@@ -2432,11 +2462,6 @@ config X86_DMA_REMAP
 	bool
 	depends on STA2X11
 
-config IOSF_MBI
-	tristate
-	default m
-	depends on PCI
-
 config PMC_ATOM
 	def_bool y
         depends on PCI
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 74e804ddc5c7..1ef456273172 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -144,6 +144,21 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
 		}
 	}
+
+	/*
+	 * Intel Quark Core DevMan_001.pdf section 6.4.11
+	 * "The operating system also is required to invalidate (i.e., flush)
+	 *  the TLB when any changes are made to any of the page table entries.
+	 *  The operating system must reload CR3 to cause the TLB to be flushed"
+	 *
+	 * As a result cpu_has_pge() in arch/x86/include/asm/tlbflush.h should
+	 * be false so that __flush_tlb_all() causes CR3 insted of CR4.PGE
+	 * to be modified
+	 */
+	if (c->x86 == 5 && c->x86_model == 9) {
+		pr_info("Disabling PGE capability bit\n");
+		setup_clear_cpu_cap(X86_FEATURE_PGE);
+	}
 }
 
 #ifdef CONFIG_X86_32
@@ -382,6 +397,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 	}
 
 	l2 = init_intel_cacheinfo(c);
+
+	/* Detect legacy cache sizes if init_intel_cacheinfo did not */
+	if (l2 == 0) {
+		cpu_detect_cache_sizes(c);
+		l2 = c->x86_cache_size;
+	}
+
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
@@ -485,6 +507,13 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	 */
 	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
 		size = 256;
+
+	/*
+	 * Intel Quark SoC X1000 contains a 4-way set associative
+	 * 16K cache with a 16 byte cache line and 256 lines per tag
+	 */
+	if ((c->x86 == 5) && (c->x86_model == 9))
+		size = 16;
 	return size;
 }
 #endif
@@ -686,7 +715,8 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [3] = "OverDrive PODP5V83",
 			  [4] = "Pentium MMX",
 			  [7] = "Mobile Pentium 75 - 200",
-			  [8] = "Mobile Pentium MMX"
+			  [8] = "Mobile Pentium MMX",
+			  [9] = "Quark SoC X1000",
 		  }
 		},
 		{ .family = 6, .model_names =
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index 9030e83db6ee..82f8d02f0df2 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -22,10 +22,13 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/debugfs.h>
+#include <linux/capability.h>
 
 #include <asm/iosf_mbi.h>
 
 #define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_BRASWELL		0x2280
 #define PCI_DEVICE_ID_QUARK_X1000	0x0958
 
 static DEFINE_SPINLOCK(iosf_mbi_lock);
@@ -187,6 +190,89 @@ bool iosf_mbi_available(void)
 }
 EXPORT_SYMBOL(iosf_mbi_available);
 
+#ifdef CONFIG_IOSF_MBI_DEBUG
+static u32	dbg_mdr;
+static u32	dbg_mcr;
+static u32	dbg_mcrx;
+
+static int mcr_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+
+static int mcr_set(void *data, u64 val)
+{
+	u8 command = ((u32)val & 0xFF000000) >> 24,
+	   port	   = ((u32)val & 0x00FF0000) >> 16,
+	   offset  = ((u32)val & 0x0000FF00) >> 8;
+	int err;
+
+	*(u32 *)data = val;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
+	if (command & 1u)
+		err = iosf_mbi_write(port,
+			       command,
+			       dbg_mcrx | offset,
+			       dbg_mdr);
+	else
+		err = iosf_mbi_read(port,
+			      command,
+			      dbg_mcrx | offset,
+			      &dbg_mdr);
+
+	return err;
+}
+DEFINE_SIMPLE_ATTRIBUTE(iosf_mcr_fops, mcr_get, mcr_set , "%llx\n");
+
+static struct dentry *iosf_dbg;
+
+static void iosf_sideband_debug_init(void)
+{
+	struct dentry *d;
+
+	iosf_dbg = debugfs_create_dir("iosf_sb", NULL);
+	if (IS_ERR_OR_NULL(iosf_dbg))
+		return;
+
+	/* mdr */
+	d = debugfs_create_x32("mdr", 0660, iosf_dbg, &dbg_mdr);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	/* mcrx */
+	debugfs_create_x32("mcrx", 0660, iosf_dbg, &dbg_mcrx);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	/* mcr - initiates mailbox tranaction */
+	debugfs_create_file("mcr", 0660, iosf_dbg, &dbg_mcr, &iosf_mcr_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto cleanup;
+
+	return;
+
+cleanup:
+	debugfs_remove_recursive(d);
+}
+
+static void iosf_debugfs_init(void)
+{
+	iosf_sideband_debug_init();
+}
+
+static void iosf_debugfs_remove(void)
+{
+	debugfs_remove_recursive(iosf_dbg);
+}
+#else
+static inline void iosf_debugfs_init(void) { }
+static inline void iosf_debugfs_remove(void) { }
+#endif /* CONFIG_IOSF_MBI_DEBUG */
+
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
 {
@@ -204,6 +290,7 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 
 static const struct pci_device_id iosf_mbi_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BRASWELL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
@@ -217,11 +304,15 @@ static struct pci_driver iosf_mbi_pci_driver = {
 
 static int __init iosf_mbi_init(void)
 {
+	iosf_debugfs_init();
+
 	return pci_register_driver(&iosf_mbi_pci_driver);
 }
 
 static void __exit iosf_mbi_exit(void)
 {
+	iosf_debugfs_remove();
+
 	pci_unregister_driver(&iosf_mbi_pci_driver);
 	if (mbi_pdev) {
 		pci_dev_put(mbi_pdev);
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0c424a67985d..0ee5025e0fa4 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -235,6 +235,11 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 	pmc_dbgfs_unregister(pmc);
 	return -ENODEV;
 }
+#else
+static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
+{
+	return 0;
+}
 #endif /* CONFIG_DEBUG_FS */
 
 static int pmc_setup_dev(struct pci_dev *pdev)
@@ -262,14 +267,12 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 	/* PMC hardware registers setup */
 	pmc_hw_reg_setup(pmc);
 
-#ifdef CONFIG_DEBUG_FS
 	ret = pmc_dbgfs_register(pmc, pdev);
 	if (ret) {
 		iounmap(pmc->regmap);
-		return ret;
 	}
-#endif /* CONFIG_DEBUG_FS */
-	return 0;
+
+	return ret;
 }
 
 /*
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index ff898bbf579d..176a0f99d4da 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -498,6 +498,24 @@ void force_hpet_resume(void)
 }
 
 /*
+ * According to the datasheet e6xx systems have the HPET hardwired to
+ * 0xfed00000
+ */
+static void e6xx_force_enable_hpet(struct pci_dev *dev)
+{
+	if (hpet_address || force_hpet_address)
+		return;
+
+	force_hpet_address = 0xFED00000;
+	force_hpet_resume_type = NONE_FORCE_HPET_RESUME;
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+		"0x%lx\n", force_hpet_address);
+	return;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E6XX_CU,
+			 e6xx_force_enable_hpet);
+
+/*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
  * See erratum #27 (Misinterpreted MSI Requests May Result in
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d3bc0b..235cfd39e0d7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -879,6 +879,15 @@ void __init setup_arch(char **cmdline_p)
 			KERNEL_PGD_PTRS);
 
 	load_cr3(swapper_pg_dir);
+	/*
+	 * Note: Quark X1000 CPUs advertise PGE incorrectly and require
+	 * a cr3 based tlb flush, so the following __flush_tlb_all()
+	 * will not flush anything because the cpu quirk which clears
+	 * X86_FEATURE_PGE has not been invoked yet. Though due to the
+	 * load_cr3() above the TLB has been flushed already. The
+	 * quirk is invoked before subsequent calls to __flush_tlb_all()
+	 * so proper operation is guaranteed.
+	 */
 	__flush_tlb_all();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb73a864..aa0d39073e9c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2860,6 +2860,7 @@
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
 #define PCI_DEVICE_ID_INTEL_ITC_LPC	0x8186
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5
