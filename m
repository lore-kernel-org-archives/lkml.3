Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbbATVuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:50:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:42064 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbbATVue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,437,1418112000"; 
   d="scan'208";a="664869727"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/4] PMC driver: Add Cherrytrail PMC interface
Date: Tue, 20 Jan 2015 23:50:03 +0200
Message-Id: <1421790603-30097-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds CHT PMC interface. This exposes all the South IP device power
states and S0ix states for CHT. The bit map of FUNC_DIS and D3_STS_0 registers
for SoCs are consistent. The D3_STS_1 and FUNC_DIS_2 registers, however, are
not aligned. This is fixed by splitting a common mapping on per register basis.

Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/include/asm/pmc_atom.h |  25 +++++++++
 arch/x86/kernel/pmc_atom.c      | 118 ++++++++++++++++++++++++++++++----------
 2 files changed, 114 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
index bc0fc08..000a223 100644
--- a/arch/x86/include/asm/pmc_atom.h
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -18,6 +18,8 @@
 
 /* ValleyView Power Control Unit PCI Device ID */
 #define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
+/* CherryTrail Power Control Unit PCI Device ID */
+#define	PCI_DEVICE_ID_CHT_PMC	0x229C
 
 /* PMC Memory mapped IO registers */
 #define	PMC_BASE_ADDR_OFFSET	0x44
@@ -29,6 +31,10 @@
 #define	PMC_FUNC_DIS		0x34
 #define	PMC_FUNC_DIS_2		0x38
 
+/* CHT specific bits in FUNC_DIS2 register */
+#define	BIT_FD_GMM		BIT(3)
+#define	BIT_FD_ISH		BIT(4)
+
 /* S0ix wake event control */
 #define	PMC_S0IX_WAKE_EN	0x3C
 
@@ -75,6 +81,21 @@
 #define PMC_PSS_BIT_USB			BIT(16)
 #define PMC_PSS_BIT_USB_SUS		BIT(17)
 
+/* CHT specific bits in PSS register */
+#define	PMC_PSS_BIT_CHT_UFS		BIT(7)
+#define	PMC_PSS_BIT_CHT_UXD		BIT(11)
+#define	PMC_PSS_BIT_CHT_UXD_FD		BIT(12)
+#define	PMC_PSS_BIT_CHT_UX_ENG		BIT(15)
+#define	PMC_PSS_BIT_CHT_USB_SUS		BIT(16)
+#define	PMC_PSS_BIT_CHT_GMM		BIT(17)
+#define	PMC_PSS_BIT_CHT_ISH		BIT(18)
+#define	PMC_PSS_BIT_CHT_DFX_MASTER	BIT(26)
+#define	PMC_PSS_BIT_CHT_DFX_CLUSTER1	BIT(27)
+#define	PMC_PSS_BIT_CHT_DFX_CLUSTER2	BIT(28)
+#define	PMC_PSS_BIT_CHT_DFX_CLUSTER3	BIT(29)
+#define	PMC_PSS_BIT_CHT_DFX_CLUSTER4	BIT(30)
+#define	PMC_PSS_BIT_CHT_DFX_CLUSTER5	BIT(31)
+
 /* These registers reflect D3 status of functions */
 #define	PMC_D3_STS_0		0xA0
 
@@ -117,6 +138,10 @@
 #define	BIT_USH_SS_PHY		BIT(2)
 #define	BIT_DFX			BIT(3)
 
+/* CHT specific bits in PMC_D3_STS_1 register */
+#define	BIT_STS_GMM		BIT(1)
+#define	BIT_STS_ISH		BIT(2)
+
 /* PMC I/O Registers */
 #define	ACPI_BASE_ADDR_OFFSET	0x40
 #define	ACPI_BASE_ADDR_MASK	0xFFFFFE00
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0f24ef7..41f4a33 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -31,7 +31,10 @@ struct pmc_bit_map {
 };
 
 struct pmc_reg_map {
-	const struct pmc_bit_map *dev;
+	const struct pmc_bit_map *d3_sts_0;
+	const struct pmc_bit_map *d3_sts_1;
+	const struct pmc_bit_map *func_dis;
+	const struct pmc_bit_map *func_dis_2;
 	const struct pmc_bit_map *pss;
 };
 
@@ -48,7 +51,7 @@ struct pmc_dev {
 static struct pmc_dev pmc_device;
 static u32 acpi_base_addr;
 
-static const struct pmc_bit_map dev_map[] = {
+static const struct pmc_bit_map d3_sts_0_map[] = {
 	{"LPSS1_F0_DMA",	BIT_LPSS1_F0_DMA},
 	{"LPSS1_F1_PWM1",	BIT_LPSS1_F1_PWM1},
 	{"LPSS1_F2_PWM2",	BIT_LPSS1_F2_PWM2},
@@ -81,6 +84,10 @@ static const struct pmc_bit_map dev_map[] = {
 	{"LPSS2_F5_I2C5",	BIT_LPSS2_F5_I2C5},
 	{"LPSS2_F6_I2C6",	BIT_LPSS2_F6_I2C6},
 	{"LPSS2_F7_I2C7",	BIT_LPSS2_F7_I2C7},
+	{},
+};
+
+static struct pmc_bit_map byt_d3_sts_1_map[] = {
 	{"SMB",			BIT_SMB},
 	{"OTG_SS_PHY",		BIT_OTG_SS_PHY},
 	{"USH_SS_PHY",		BIT_USH_SS_PHY},
@@ -88,7 +95,21 @@ static const struct pmc_bit_map dev_map[] = {
 	{},
 };
 
-static const struct pmc_bit_map pss_map[] = {
+static struct pmc_bit_map cht_d3_sts_1_map[] = {
+	{"SMB",			BIT_SMB},
+	{"GMM",			BIT_STS_GMM},
+	{"ISH",			BIT_STS_ISH},
+	{},
+};
+
+static struct pmc_bit_map cht_func_dis_2_map[] = {
+	{"SMB",			BIT_SMB},
+	{"GMM",			BIT_FD_GMM},
+	{"ISH",			BIT_FD_ISH},
+	{},
+};
+
+static const struct pmc_bit_map byt_pss_map[] = {
 	{"GBE",			PMC_PSS_BIT_GBE},
 	{"SATA",		PMC_PSS_BIT_SATA},
 	{"HDA",			PMC_PSS_BIT_HDA},
@@ -110,9 +131,43 @@ static const struct pmc_bit_map pss_map[] = {
 	{},
 };
 
-static const struct pmc_reg_map reg_map = {
-	.dev		= dev_map,
-	.pss		= pss_map,
+static const struct pmc_bit_map cht_pss_map[] = {
+	{"SATA",		PMC_PSS_BIT_SATA},
+	{"HDA",			PMC_PSS_BIT_HDA},
+	{"SEC",			PMC_PSS_BIT_SEC},
+	{"PCIE",		PMC_PSS_BIT_PCIE},
+	{"LPSS",		PMC_PSS_BIT_LPSS},
+	{"LPE",			PMC_PSS_BIT_LPE},
+	{"UFS",			PMC_PSS_BIT_CHT_UFS},
+	{"UXD",			PMC_PSS_BIT_CHT_UXD},
+	{"UXD_FD",		PMC_PSS_BIT_CHT_UXD_FD},
+	{"UX_ENG",		PMC_PSS_BIT_CHT_UX_ENG},
+	{"USB_SUS",		PMC_PSS_BIT_CHT_USB_SUS},
+	{"GMM",			PMC_PSS_BIT_CHT_GMM},
+	{"ISH",			PMC_PSS_BIT_CHT_ISH},
+	{"DFX_MASTER",		PMC_PSS_BIT_CHT_DFX_MASTER},
+	{"DFX_CLUSTER1",	PMC_PSS_BIT_CHT_DFX_CLUSTER1},
+	{"DFX_CLUSTER2",	PMC_PSS_BIT_CHT_DFX_CLUSTER2},
+	{"DFX_CLUSTER3",	PMC_PSS_BIT_CHT_DFX_CLUSTER3},
+	{"DFX_CLUSTER4",	PMC_PSS_BIT_CHT_DFX_CLUSTER4},
+	{"DFX_CLUSTER5",	PMC_PSS_BIT_CHT_DFX_CLUSTER5},
+	{},
+};
+
+static const struct pmc_reg_map byt_reg_map = {
+	.d3_sts_0	= d3_sts_0_map,
+	.d3_sts_1	= byt_d3_sts_1_map,
+	.func_dis	= d3_sts_0_map,
+	.func_dis_2	= byt_d3_sts_1_map,
+	.pss		= byt_pss_map,
+};
+
+static const struct pmc_reg_map cht_reg_map = {
+	.d3_sts_0	= d3_sts_0_map,
+	.d3_sts_1	= cht_d3_sts_1_map,
+	.func_dis	= d3_sts_0_map,
+	.func_dis_2	= cht_func_dis_2_map,
+	.pss		= cht_pss_map,
 };
 
 static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
@@ -156,36 +211,39 @@ static void pmc_hw_reg_setup(struct pmc_dev *pmc)
 }
 
 #ifdef CONFIG_DEBUG_FS
+static void pmc_dev_state_print(struct seq_file *s, int reg_index,
+				u32 sts, const struct pmc_bit_map *sts_map,
+				u32 fd, const struct pmc_bit_map *fd_map)
+{
+	int offset = PMC_REG_BIT_WIDTH * reg_index;
+	int index;
+
+	for (index = 0; sts_map[index].name; index++) {
+		seq_printf(s, "Dev: %-2d - %-32s\tState: %s [%s]\n",
+			offset + index, sts_map[index].name,
+			fd_map[index].bit_mask & fd ?  "Disabled" : "Enabled ",
+			sts_map[index].bit_mask & sts ?  "D3" : "D0");
+	}
+}
+
 static int pmc_dev_state_show(struct seq_file *s, void *unused)
 {
 	struct pmc_dev *pmc = s->private;
-	const struct pmc_bit_map *map = pmc->map->dev;
-	u32 func_dis, func_dis_2, func_dis_index;
-	u32 d3_sts_0, d3_sts_1, d3_sts_index;
-	int index, reg_index;
+	const struct pmc_reg_map *m = pmc->map;
+	u32 func_dis, func_dis_2;
+	u32 d3_sts_0, d3_sts_1;
 
 	func_dis = pmc_reg_read(pmc, PMC_FUNC_DIS);
 	func_dis_2 = pmc_reg_read(pmc, PMC_FUNC_DIS_2);
 	d3_sts_0 = pmc_reg_read(pmc, PMC_D3_STS_0);
 	d3_sts_1 = pmc_reg_read(pmc, PMC_D3_STS_1);
 
-	for (index = 0; map[index].name; index++) {
-		reg_index = index / PMC_REG_BIT_WIDTH;
-		if (reg_index) {
-			func_dis_index = func_dis_2;
-			d3_sts_index = d3_sts_1;
-		} else {
-			func_dis_index = func_dis;
-			d3_sts_index = d3_sts_0;
-		}
+	/* Low part */
+	pmc_dev_state_print(s, 0, d3_sts_0, m->d3_sts_0, func_dis, m->func_dis);
+
+	/* High part */
+	pmc_dev_state_print(s, 1, d3_sts_1, m->d3_sts_1, func_dis_2, m->func_dis_2);
 
-		seq_printf(s, "Dev: %-2d - %-32s\tState: %s [%s]\n",
-			index, map[index].name,
-			map[index].bit_mask & func_dis_index ?
-			"Disabled" : "Enabled ",
-			map[index].bit_mask & d3_sts_index ?
-			"D3" : "D0");
-	}
 	return 0;
 }
 
@@ -307,9 +365,10 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc)
 }
 #endif /* CONFIG_DEBUG_FS */
 
-static int pmc_setup_dev(struct pci_dev *pdev, const struct pmc_reg_map *map)
+static int pmc_setup_dev(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct pmc_dev *pmc = &pmc_device;
+	const struct pmc_reg_map *map = (struct pmc_reg_map *)ent->driver_data;
 	int ret;
 
 	/* Obtain ACPI base address */
@@ -351,7 +410,8 @@ static int pmc_setup_dev(struct pci_dev *pdev, const struct pmc_reg_map *map)
  * a driver on the same PCI id.
  */
 static const struct pci_device_id pmc_pci_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_VLV_PMC) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_VLV_PMC), (kernel_ulong_t)&byt_reg_map },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_CHT_PMC), (kernel_ulong_t)&cht_reg_map },
 	{ 0, },
 };
 
@@ -373,7 +433,7 @@ static int __init pmc_atom_init(void)
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pmc_pci_ids, pdev);
 		if (ent)
-			return pmc_setup_dev(pdev, &reg_map);
+			return pmc_setup_dev(pdev, ent);
 	}
 	/* Device not found. */
 	return -ENODEV;
-- 
2.1.4

