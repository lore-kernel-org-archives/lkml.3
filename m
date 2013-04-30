Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab3D3IiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:38:14 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:64306 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3D3IiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:38:09 -0400
Date: Tue, 30 Apr 2013 10:38:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] x86/ras changes for v3.10
Message-ID: <20130430083804.GA22564@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   HEAD: 5379f8c0d72cab43bbe6d974ceb3ad84dddc2b8e Merge tag 'edac_amd_f16h' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/ras

This merge:

 - Adds an Intel CMCI hotplug fix

 - Adds AMD family 16h EDAC support

 - Makes the AMD MCE banks code more flexible for virtual environments

 out-of-topic modifications in x86-ras-for-linus:
 ------------------------------------------------
 drivers/edac/amd64_edac.c          # 94c1acf: amd64_edac: Add Family 16h suppor
 drivers/edac/amd64_edac.h          # 94c1acf: amd64_edac: Add Family 16h suppor
 include/linux/pci_ids.h            # 94c1acf: amd64_edac: Add Family 16h suppor

 Thanks,

	Ingo

------------------>
Aravind Gopalakrishnan (1):
      amd64_edac: Add Family 16h support

Boris Ostrovsky (2):
      x86, MCE, AMD: Replace shared_bank array with is_shared_bank() helper
      x86, MCE, AMD: Use MCG_CAP MSR to find out number of banks on AMD

Srivatsa S. Bhat (1):
      x86/mce: Rework cmci_rediscover() to play well with CPU hotplug


 arch/x86/include/asm/mce.h             |  4 +--
 arch/x86/kernel/amd_nb.c               |  3 +-
 arch/x86/kernel/cpu/mcheck/mce.c       |  2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c   | 39 ++++++++++++--------
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 25 +++----------
 drivers/edac/amd64_edac.c              | 65 +++++++++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h              |  4 ++-
 include/linux/pci_ids.h                |  2 ++
 8 files changed, 103 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f4076af..fa5f71e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -146,13 +146,13 @@ DECLARE_PER_CPU(struct device *, mce_device);
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
-void cmci_rediscover(int dying);
+void cmci_rediscover(void);
 void cmci_recheck(void);
 #else
 static inline void mce_intel_feature_init(struct cpuinfo_x86 *c) { }
 static inline void cmci_clear(void) {}
 static inline void cmci_reenable(void) {}
-static inline void cmci_rediscover(int dying) {}
+static inline void cmci_rediscover(void) {}
 static inline void cmci_recheck(void) {}
 #endif
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf335..f1d0a14 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,12 +20,14 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 
@@ -81,7 +83,6 @@ int amd_cache_northbridges(void)
 			next_northbridge(link, amd_nb_link_ids);
         }
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
 	    boot_cpu_data.x86 == 0x15)
 		amd_northbridges.flags |= AMD_NB_GART;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7bc1263..9239504 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2358,7 +2358,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	if (action == CPU_POST_DEAD) {
 		/* intentionally ignoring frozen here */
-		cmci_rediscover(cpu);
+		cmci_rediscover();
 	}
 
 	return NOTIFY_OK;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1ac581f..9cb5276 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -33,7 +33,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
-#define NR_BANKS          6
 #define NR_BLOCKS         9
 #define THRESHOLD_MAX     0xFFF
 #define INT_TYPE_APIC     0x00020000
@@ -57,12 +56,7 @@ static const char * const th_names[] = {
 	"execution_unit",
 };
 
-static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
-
-static unsigned char shared_bank[NR_BANKS] = {
-	0, 0, 0, 0, 1
-};
-
+static DEFINE_PER_CPU(struct threshold_bank **, threshold_banks);
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
 static void amd_threshold_interrupt(void);
@@ -79,6 +73,12 @@ struct thresh_restart {
 	u16			old_limit;
 };
 
+static inline bool is_shared_bank(int bank)
+{
+	/* Bank 4 is for northbridge reporting and is thus shared */
+	return (bank == 4);
+}
+
 static const char * const bank4_names(struct threshold_block *b)
 {
 	switch (b->address) {
@@ -214,7 +214,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int bank, block;
 	int offset = -1;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
 				address = MSR_IA32_MC0_MISC + bank * 4;
@@ -276,7 +276,7 @@ static void amd_threshold_interrupt(void)
 	mce_setup(&m);
 
 	/* assume first bank caused it */
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -467,7 +467,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	u32 low, high;
 	int err;
 
-	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
+	if ((bank >= mca_cfg.banks) || (block >= NR_BLOCKS))
 		return 0;
 
 	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
@@ -575,7 +575,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	const char *name = th_names[bank];
 	int err = 0;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
 
 		/* threshold descriptor already initialized on this node? */
@@ -609,7 +609,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
@@ -635,9 +635,17 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 static __cpuinit int threshold_create_device(unsigned int cpu)
 {
 	unsigned int bank;
+	struct threshold_bank **bp;
 	int err = 0;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	bp = kzalloc(sizeof(struct threshold_bank *) * mca_cfg.banks,
+		     GFP_KERNEL);
+	if (!bp)
+		return -ENOMEM;
+
+	per_cpu(threshold_banks, cpu) = bp;
+
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(cpu, bank);
@@ -691,7 +699,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	if (!b->blocks)
 		goto free_out;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		if (!atomic_dec_and_test(&b->cpus)) {
 			__threshold_remove_blocks(b);
 			per_cpu(threshold_banks, cpu)[bank] = NULL;
@@ -719,11 +727,12 @@ static void threshold_remove_device(unsigned int cpu)
 {
 	unsigned int bank;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		threshold_remove_bank(cpu, bank);
 	}
+	kfree(per_cpu(threshold_banks, cpu));
 }
 
 /* get notified when a cpu comes on/off */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 402c454..ae1697c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -285,39 +285,24 @@ void cmci_clear(void)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
-static long cmci_rediscover_work_func(void *arg)
+static void cmci_rediscover_work_func(void *arg)
 {
 	int banks;
 
 	/* Recheck banks in case CPUs don't all have the same */
 	if (cmci_supported(&banks))
 		cmci_discover(banks);
-
-	return 0;
 }
 
-/*
- * After a CPU went down cycle through all the others and rediscover
- * Must run in process context.
- */
-void cmci_rediscover(int dying)
+/* After a CPU went down cycle through all the others and rediscover */
+void cmci_rediscover(void)
 {
-	int cpu, banks;
+	int banks;
 
 	if (!cmci_supported(&banks))
 		return;
 
-	for_each_online_cpu(cpu) {
-		if (cpu == dying)
-			continue;
-
-		if (cpu == smp_processor_id()) {
-			cmci_rediscover_work_func(NULL);
-			continue;
-		}
-
-		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
-	}
+	on_each_cpu(cmci_rediscover_work_func, NULL, 1);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e1d13c4..8b6a034 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -98,6 +98,7 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
  *
  * F15h: we select which DCT we access using F1x10C[DctCfgSel]
  *
+ * F16h: has only 1 DCT
  */
 static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 			       const char *func)
@@ -340,6 +341,27 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
 		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
 		addr_shift	= 4;
+
+	/*
+	* F16h needs two addr_shift values: 8 for high and 6 for low
+	* (cf. F16h BKDG).
+	*/
+	} else if (boot_cpu_data.x86 == 0x16) {
+		csbase          = pvt->csels[dct].csbases[csrow];
+		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
+
+		*base  = (csbase & GENMASK(5,  15)) << 6;
+		*base |= (csbase & GENMASK(19, 30)) << 8;
+
+		*mask = ~0ULL;
+		/* poke holes for the csmask */
+		*mask &= ~((GENMASK(5, 15)  << 6) |
+			   (GENMASK(19, 30) << 8));
+
+		*mask |= (csmask & GENMASK(5, 15))  << 6;
+		*mask |= (csmask & GENMASK(19, 30)) << 8;
+
+		return;
 	} else {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
@@ -1150,6 +1172,21 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 	return ddr3_cs_size(cs_mode, false);
 }
 
+/*
+ * F16h has only limited cs_modes
+ */
+static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				unsigned cs_mode)
+{
+	WARN_ON(cs_mode > 12);
+
+	if (cs_mode == 6 || cs_mode == 8 ||
+	    cs_mode == 9 || cs_mode == 12)
+		return -1;
+	else
+		return ddr3_cs_size(cs_mode, false);
+}
+
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1587,6 +1624,17 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
+	[F16_CPUS] = {
+		.ctl_name = "F16h",
+		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_16H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f16_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
+		}
+	},
 };
 
 /*
@@ -1939,7 +1987,9 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	if (c->x86 >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+		if (c->x86 != 0x16)
+			/* F16h has only DCT0 */
+			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
 		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
@@ -2356,6 +2406,11 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
 		break;
 
+	case 0x16:
+		fam_type		= &amd64_family_types[F16_CPUS];
+		pvt->ops		= &amd64_family_types[F16_CPUS].ops;
+		break;
+
 	default:
 		amd64_err("Unsupported family!\n");
 		return NULL;
@@ -2581,6 +2636,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
 		.class		= 0,
 		.class_mask	= 0,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
 
 	{0, }
 };
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 35637d8..2c6f113 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -172,7 +172,8 @@
  */
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-
+#define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
+#define PCI_DEVICE_ID_AMD_16H_NB_F2	0x1532
 
 /*
  * Function 1 - Address Map
@@ -296,6 +297,7 @@ enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
 	F15_CPUS,
+	F16_CPUS,
 	NUM_FAMILIES,
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f11c1c2..9b3b858 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -524,6 +524,8 @@
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
 #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
+#define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
