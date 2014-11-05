Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaKEQj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:39:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:44561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaKEQjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:39:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="632024798"
From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
To: linux-pm@vger.kernel.org, rafael.j.wysocki@intel.com, len.brown@intel.com,
        aubrey.li@intel.com
Cc: linux-kernel@vger.kernel.org, mahesh.kumar.p@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] PMC Driver : Expose the power gate status for BYT
Date: Wed,  5 Nov 2014 22:04:58 +0530
Message-Id: <1415205298-6047-1-git-send-email-mahesh.kumar.p@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PSS register reflects the power state of each island on SoC.
It would be useful to know which of the islands is on or off at the momemnt.
This interface would help indicate the S0ix blocker IPs in the system.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
---
 arch/x86/include/asm/pmc_atom.h |   23 ++++++++++++++
 arch/x86/kernel/pmc_atom.c      |   63 +++++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
index 581ad43..7f09fe0 100644
--- a/arch/x86/include/asm/pmc_atom.h
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -44,6 +44,29 @@
 				BIT_ORED_DEDICATED_IRQ_GPSC | \
 				BIT_SHARED_IRQ_GPSS)
 
+/* Power gate status register */
+#define	PMC_PSS			0x98
+
+#define PMC_PSS_BIT_GBE			BIT(0)
+#define PMC_PSS_BIT_SATA		BIT(1)
+#define PMC_PSS_BIT_HDA			BIT(2)
+#define PMC_PSS_BIT_SEC			BIT(3)
+#define PMC_PSS_BIT_PCIE		BIT(4)
+#define PMC_PSS_BIT_LPSS		BIT(5)
+#define PMC_PSS_BIT_LPE			BIT(6)
+#define PMC_PSS_BIT_DFX			BIT(7)
+#define PMC_PSS_BIT_USH_CTRL		BIT(8)
+#define PMC_PSS_BIT_USH_SUS		BIT(9)
+#define PMC_PSS_BIT_USH_VCCS		BIT(10)
+#define PMC_PSS_BIT_USH_VCCA		BIT(11)
+#define PMC_PSS_BIT_OTG_CTRL		BIT(12)
+#define PMC_PSS_BIT_OTG_VCCS		BIT(13)
+#define PMC_PSS_BIT_OTG_VCCA_CLK	BIT(14)
+#define PMC_PSS_BIT_OTG_VCCA		BIT(15)
+#define PMC_PSS_BIT_USB			BIT(16)
+#define PMC_PSS_BIT_USB_SUS		BIT(17)
+
+
 /* The timers acumulate time spent in sleep state */
 #define	PMC_S0IR_TMR		0x80
 #define	PMC_S0I1_TMR		0x84
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 822fb6a..b435e7c 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -38,15 +38,15 @@ struct pmc_dev {
 static struct pmc_dev pmc_device;
 static u32 acpi_base_addr;
 
-struct pmc_dev_map {
+struct pmc_bit_map {
 	const char *name;
 	u32 d3_sts_bit;
 	u32 fn_dis_bit;
 };
 
-static  struct pmc_dev_map *dev_map;
+static  struct pmc_bit_map *dev_map;
 static int dev_num;
-static  struct pmc_dev_map byt_dev_map[] = {
+static  struct pmc_bit_map byt_dev_map[] = {
 	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
 	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
 	{"2  - LPSS1_F2_PWM2",		BIT_LPSS1_F2_PWM2},
@@ -85,7 +85,28 @@ static  struct pmc_dev_map byt_dev_map[] = {
 	{"35 - DFX",			BIT_DFX_BYT},
 };
 
-static struct pmc_dev_map cht_dev_map[] = {
+static const struct pmc_bit_map pss_map[] = {
+	{"0  - GBE",			PMC_PSS_BIT_GBE},
+	{"1  - SATA",			PMC_PSS_BIT_SATA},
+	{"2  - HDA",			PMC_PSS_BIT_HDA},
+	{"3  - SEC",			PMC_PSS_BIT_SEC},
+	{"4  - PCIE",			PMC_PSS_BIT_PCIE},
+	{"5  - LPSS",			PMC_PSS_BIT_LPSS},
+	{"6  - LPE",			PMC_PSS_BIT_LPE},
+	{"7  - DFX",			PMC_PSS_BIT_DFX},
+	{"8  - USH_CTRL",		PMC_PSS_BIT_USH_CTRL},
+	{"9  - USH_SUS",		PMC_PSS_BIT_USH_SUS},
+	{"10 - USH_VCCS",		PMC_PSS_BIT_USH_VCCS},
+	{"11 - USH_VCCA",		PMC_PSS_BIT_USH_VCCA},
+	{"12 - OTG_CTRL",		PMC_PSS_BIT_OTG_CTRL},
+	{"13 - OTG_VCCS",		PMC_PSS_BIT_OTG_VCCS},
+	{"14 - OTG_VCCA_CLK",		PMC_PSS_BIT_OTG_VCCA_CLK},
+	{"15 - OTG_VCCA",		PMC_PSS_BIT_OTG_VCCA},
+	{"16 - USB",			PMC_PSS_BIT_USB},
+	{"17 - USB_SUS",		PMC_PSS_BIT_USB_SUS},
+};
+
+static struct pmc_bit_map cht_dev_map[] = {
 	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
 	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
 	{"2  - LPSS1_F2_PWM2",		BIT_LPSS1_F2_PWM2},
@@ -213,6 +234,32 @@ static const struct file_operations pmc_dev_state_ops = {
 	.release	= single_release,
 };
 
+static int pmc_pss_state_show(struct seq_file *s, void *unused)
+{
+	struct pmc_dev *pmc = s->private;
+	u32 pss = pmc_reg_read(pmc, PMC_PSS);
+	int pss_index;
+
+	for (pss_index = 0; pss_index < ARRAY_SIZE(pss_map); pss_index++) {
+		seq_printf(s, "Island: %-32s\tState: %s\n",
+			pss_map[pss_index].name,
+			pss_map[pss_index].d3_sts_bit & pss ? "Off" : "On");
+	}
+	return 0;
+}
+
+static int pmc_pss_state_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmc_pss_state_show, inode->i_private);
+}
+
+static const struct file_operations pmc_pss_state_ops = {
+	.open		= pmc_pss_state_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int pmc_sleep_tmr_show(struct seq_file *s, void *unused)
 {
 	struct pmc_dev *pmc = s->private;
@@ -264,7 +311,7 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 	f = debugfs_create_file("dev_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_dev_state_ops);
 	if (!f) {
-		dev_err(&pdev->dev, "dev_states register failed\n");
+		dev_err(&pdev->dev, "dev_state register failed\n");
 		goto err;
 	}
 	f = debugfs_create_file("sleep_state", S_IFREG | S_IRUGO,
@@ -273,6 +320,12 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 		dev_err(&pdev->dev, "sleep_state register failed\n");
 		goto err;
 	}
+	f = debugfs_create_file("pss_state", S_IFREG | S_IRUGO,
+				dir, pmc, &pmc_pss_state_ops);
+	if (!f) {
+		dev_err(&pdev->dev, "pss_state register failed\n");
+		goto err;
+	}
 	pmc->dbgfs_dir = dir;
 	return 0;
 err:
-- 
1.7.9.5

