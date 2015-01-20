Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbbATL40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:56:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbATL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:56:21 -0500
Date: Tue, 20 Jan 2015 03:56:10 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-0e1540208ef34a2246822fa56f751efe23748e7a@git.kernel.org>
Cc: andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        hpa@zytor.com, aubrey.li@linux.intel.com, mahesh.kumar.p@intel.com,
        mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        mahesh.kumar.p@intel.com, mingo@kernel.org, aubrey.li@linux.intel.com,
        hpa@zytor.com
In-Reply-To: <1421253575-22509-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-6-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: pmc_atom: Expose contents of PSS
Git-Commit-ID: 0e1540208ef34a2246822fa56f751efe23748e7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e1540208ef34a2246822fa56f751efe23748e7a
Gitweb:     http://git.kernel.org/tip/0e1540208ef34a2246822fa56f751efe23748e7a
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 14 Jan 2015 18:39:35 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:50:14 +0100

x86: pmc_atom: Expose contents of PSS

The PSS register reflects the power state of each island on SoC. It would be
useful to know which of the islands is on or off at the momemnt.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Kumar P. Mahesh <mahesh.kumar.p@intel.com>
Link: http://lkml.kernel.org/r/1421253575-22509-6-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pmc_atom.h | 22 +++++++++++++++
 arch/x86/kernel/pmc_atom.c      | 61 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
index fc7a17c..bc0fc08 100644
--- a/arch/x86/include/asm/pmc_atom.h
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -53,6 +53,28 @@
 /* Sleep state counter is in units of of 32us */
 #define	PMC_TMR_SHIFT		5
 
+/* Power status of power islands */
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
 /* These registers reflect D3 status of functions */
 #define	PMC_D3_STS_0		0xA0
 
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index f8becc4..d66a4fe 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -36,12 +36,12 @@ struct pmc_dev {
 static struct pmc_dev pmc_device;
 static u32 acpi_base_addr;
 
-struct pmc_dev_map {
+struct pmc_bit_map {
 	const char *name;
 	u32 bit_mask;
 };
 
-static const struct pmc_dev_map dev_map[] = {
+static const struct pmc_bit_map dev_map[] = {
 	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
 	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
 	{"2  - LPSS1_F2_PWM2",		BIT_LPSS1_F2_PWM2},
@@ -80,6 +80,27 @@ static const struct pmc_dev_map dev_map[] = {
 	{"35 - DFX",			BIT_DFX},
 };
 
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
 static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
 {
 	return readl(pmc->regmap + reg_offset);
@@ -167,6 +188,32 @@ static const struct file_operations pmc_dev_state_ops = {
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
+			pss_map[pss_index].bit_mask & pss ? "Off" : "On");
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
@@ -216,9 +263,17 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 	f = debugfs_create_file("dev_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_dev_state_ops);
 	if (!f) {
-		dev_err(&pdev->dev, "dev_states register failed\n");
+		dev_err(&pdev->dev, "dev_state register failed\n");
 		goto err;
 	}
+
+	f = debugfs_create_file("pss_state", S_IFREG | S_IRUGO,
+				dir, pmc, &pmc_pss_state_ops);
+	if (!f) {
+		dev_err(&pdev->dev, "pss_state register failed\n");
+		goto err;
+	}
+
 	f = debugfs_create_file("sleep_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_sleep_tmr_ops);
 	if (!f) {
