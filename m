Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaKEQlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:41:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:10969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbaKEQlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:41:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="627083257"
From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
To: linux-pm@vger.kernel.org, rafael.j.wysocki@intel.com, len.brown@intel.com,
        aubrey.li@intel.com
Cc: linux-kernel@vger.kernel.org, mahesh.kumar.p@intel.com
Subject: [PATCH 3/3] PMC Driver : Expose the power gate status for CHT
Date: Wed,  5 Nov 2014 22:05:34 +0530
Message-Id: <1415205334-6141-1-git-send-email-mahesh.kumar.p@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PSS register reflects the power state of each island on SoC.
It would be useful to know which of the islands is on or off at
the moment.
The patch adds the Pwr Gate status interface to CHT

Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
---
 arch/x86/include/asm/pmc_atom.h |   20 +++++++++++++++++++-
 arch/x86/kernel/pmc_atom.c      |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
index 7f09fe0..d634125 100644
--- a/arch/x86/include/asm/pmc_atom.h
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -47,13 +47,16 @@
 /* Power gate status register */
 #define	PMC_PSS			0x98
 
-#define PMC_PSS_BIT_GBE			BIT(0)
+/* common bit definition */
 #define PMC_PSS_BIT_SATA		BIT(1)
 #define PMC_PSS_BIT_HDA			BIT(2)
 #define PMC_PSS_BIT_SEC			BIT(3)
 #define PMC_PSS_BIT_PCIE		BIT(4)
 #define PMC_PSS_BIT_LPSS		BIT(5)
 #define PMC_PSS_BIT_LPE			BIT(6)
+
+/* BYT specific bits */
+#define PMC_PSS_BIT_GBE			BIT(0)
 #define PMC_PSS_BIT_DFX			BIT(7)
 #define PMC_PSS_BIT_USH_CTRL		BIT(8)
 #define PMC_PSS_BIT_USH_SUS		BIT(9)
@@ -66,6 +69,21 @@
 #define PMC_PSS_BIT_USB			BIT(16)
 #define PMC_PSS_BIT_USB_SUS		BIT(17)
 
+/* CHT specific bits */
+#define PMC_PSS_BIT_UFS			BIT(7)
+#define PMC_PSS_BIT_UXD			BIT(11)
+#define PMC_PSS_BIT_UXD_FD		BIT(12)
+#define PMC_PSS_BIT_UX_ENG		BIT(15)
+#define PMC_PSS_BIT_USB_SUS_CHT		BIT(16)
+#define PMC_PSS_BIT_GMM		BIT(17)
+#define PMC_PSS_BIT_ISH		BIT(18)
+#define PMC_PSS_BIT_DFX_MASTER		BIT(26)
+#define PMC_PSS_BIT_DFX_CLSTR1		BIT(27)
+#define PMC_PSS_BIT_DFX_CLSTR2		BIT(28)
+#define PMC_PSS_BIT_DFX_CLSTR3		BIT(29)
+#define PMC_PSS_BIT_DFX_CLSTR4		BIT(30)
+#define PMC_PSS_BIT_DFX_CLSTR5		BIT(31)
+
 
 /* The timers acumulate time spent in sleep state */
 #define	PMC_S0IR_TMR		0x80
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index b435e7c..50dde36 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -45,7 +45,10 @@ struct pmc_bit_map {
 };
 
 static  struct pmc_bit_map *dev_map;
+static  struct pmc_bit_map *pss_map;
 static int dev_num;
+static int pss_num;
+
 static  struct pmc_bit_map byt_dev_map[] = {
 	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
 	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
@@ -85,7 +88,7 @@ static  struct pmc_bit_map byt_dev_map[] = {
 	{"35 - DFX",			BIT_DFX_BYT},
 };
 
-static const struct pmc_bit_map pss_map[] = {
+static struct pmc_bit_map pss_map_vlv[] = {
 	{"0  - GBE",			PMC_PSS_BIT_GBE},
 	{"1  - SATA",			PMC_PSS_BIT_SATA},
 	{"2  - HDA",			PMC_PSS_BIT_HDA},
@@ -144,6 +147,28 @@ static struct pmc_bit_map cht_dev_map[] = {
 	{"34 - ISH",	BIT_ISH_CHT,	BIT_ISH_FD_CHT},
 };
 
+static struct pmc_bit_map pss_map_cht[] = {
+	{"1  - SATA",			PMC_PSS_BIT_SATA},
+	{"2  - HDA",			PMC_PSS_BIT_HDA},
+	{"3  - SEC",			PMC_PSS_BIT_SEC},
+	{"4  - PCIE",			PMC_PSS_BIT_PCIE},
+	{"5  - LPSS",			PMC_PSS_BIT_LPSS},
+	{"6  - LPE",			PMC_PSS_BIT_LPE},
+	{"7  - UFS",			PMC_PSS_BIT_UFS},
+	{"11  - UXD(xDCI)",		PMC_PSS_BIT_UXD},
+	{"12  - UXD FD SX(xDCI)",		PMC_PSS_BIT_UXD_FD},
+	{"15 -  UX Engine(xHCI) ",		PMC_PSS_BIT_UX_ENG},
+	{"16 - USB SUS ",		PMC_PSS_BIT_USB_SUS_CHT},
+	{"17 - GMM",		PMC_PSS_BIT_GMM},
+	{"18 - ISH",		PMC_PSS_BIT_ISH},
+	{"26 - DFX Master",		PMC_PSS_BIT_DFX_MASTER},
+	{"27 - DFX Cluster1",		PMC_PSS_BIT_DFX_CLSTR1},
+	{"28 - DFX Cluster2",		PMC_PSS_BIT_DFX_CLSTR2},
+	{"29 - DFX Cluster3",		PMC_PSS_BIT_DFX_CLSTR3},
+	{"30 - DFX Cluster4",		PMC_PSS_BIT_DFX_CLSTR4},
+	{"31 - DFX Cluster5",		PMC_PSS_BIT_DFX_CLSTR5},
+};
+
 static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
 {
 	return readl(pmc->regmap + reg_offset);
@@ -240,7 +265,7 @@ static int pmc_pss_state_show(struct seq_file *s, void *unused)
 	u32 pss = pmc_reg_read(pmc, PMC_PSS);
 	int pss_index;
 
-	for (pss_index = 0; pss_index < ARRAY_SIZE(pss_map); pss_index++) {
+	for (pss_index = 0; pss_index < pss_num; pss_index++) {
 		seq_printf(s, "Island: %-32s\tState: %s\n",
 			pss_map[pss_index].name,
 			pss_map[pss_index].d3_sts_bit & pss ? "Off" : "On");
@@ -414,10 +439,14 @@ static int __init pmc_atom_init(void)
 			case PCI_DEVICE_ID_BYT_PMC:
 				dev_map = byt_dev_map;
 				dev_num = ARRAY_SIZE(byt_dev_map);
+				pss_map = pss_map_vlv;
+				pss_num = ARRAY_SIZE(pss_map_vlv);
 				break;
 			case PCI_DEVICE_ID_CHT_PMC:
 				dev_map = cht_dev_map;
 				dev_num = ARRAY_SIZE(cht_dev_map);
+				pss_map = pss_map_cht;
+				pss_num = ARRAY_SIZE(pss_map_cht);
 				break;
 			}
 			err = pmc_setup_dev(pdev);
-- 
1.7.9.5

