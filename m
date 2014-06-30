Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaF3GJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:09:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:51813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaF3GJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="555109420"
Message-ID: <53B0FF22.5080403@linux.intel.com>
Date: Mon, 30 Jun 2014 14:09:38 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Resend PATCH 2/3] x86/pmc_atom: disable a few S0ix wake up events
 for S0ix residency
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable PMC S0IX_WAKE_EN events coming from LPC block(unused) and
also from GPIO_SUS ored dedicated IRQs (must be disabled as per PMC
programming rule), GPIOSCORE ored dedicated IRQs (must be disabled
as per PMC programming rule), GPIO_SUS shared IRQ (not necessary
since the IOAPIC_DS wake event will still work), GPIO_SCORE shared
IRQ (not necessary since the IOAPIC_DS wake event will still work).

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Olivier Leveque <olivier.leveque@intel.com>
---
 arch/x86/include/asm/pmc_atom.h |   21 ++++++++++++++++++++
 arch/x86/kernel/pmc_atom.c      |   42 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
index 03a2769..8e47e5d 100644
--- a/arch/x86/include/asm/pmc_atom.h
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -19,6 +19,27 @@
 /* ValleyView Power Control Unit PCI Device ID */
 #define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
 
+/* PMC Memory mapped IO registers */
+#define	PMC_BASE_ADDR_OFFSET	0x44
+#define	PMC_BASE_ADDR_MASK	0xFFFFFE00
+#define	PMC_MMIO_REG_LEN	0x100
+#define	PMC_REG_BIT_WIDTH	32
+
+/* S0ix wake event control */
+#define	PMC_S0IX_WAKE_EN	0x3C
+
+#define	BIT_LPC_CLOCK_RUN		BIT(4)
+#define	BIT_SHARED_IRQ_GPSC		BIT(5)
+#define	BIT_ORED_DEDICATED_IRQ_GPSS	BIT(18)
+#define	BIT_ORED_DEDICATED_IRQ_GPSC	BIT(19)
+#define	BIT_SHARED_IRQ_GPSS		BIT(20)
+
+#define	PMC_WAKE_EN_SETTING	~(BIT_LPC_CLOCK_RUN | \
+				BIT_SHARED_IRQ_GPSC | \
+				BIT_ORED_DEDICATED_IRQ_GPSS | \
+				BIT_ORED_DEDICATED_IRQ_GPSC | \
+				BIT_SHARED_IRQ_GPSS)
+
 /* PMC I/O Registers */
 #define	ACPI_BASE_ADDR_OFFSET	0x40
 #define	ACPI_BASE_ADDR_MASK	0xFFFFFE00
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 9eb79f6..d6cc0e9 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -23,8 +23,24 @@
 
 #include <asm/pmc_atom.h>
 
+struct pmc_dev {
+	u32 base_addr;
+	void __iomem *regmap;
+};
+
+static struct pmc_dev pmc_device;
 static u32 acpi_base_addr;
 
+static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
+{
+	return readl(pmc->regmap + reg_offset);
+}
+
+static inline void pmc_reg_write(struct pmc_dev *pmc, int reg_offset, u32 val)
+{
+	writel(val, pmc->regmap + reg_offset);
+}
+
 static void pmc_power_off(void)
 {
 	u16	pm1_cnt_port;
@@ -42,8 +58,23 @@ static void pmc_power_off(void)
 	outl(pm1_cnt_value, pm1_cnt_port);
 }
 
+static void pmc_hw_reg_setup(struct pmc_dev *pmc)
+{
+	/*
+	 * Disable PMC S0IX_WAKE_EN events coming from:
+	 * - LPC clock run
+	 * - GPIO_SUS ored dedicated IRQs
+	 * - GPIO_SCORE ored dedicated IRQs
+	 * - GPIO_SUS shared IRQ
+	 * - GPIO_SCORE shared IRQ
+	 */
+	pmc_reg_write(pmc, PMC_S0IX_WAKE_EN, (u32)PMC_WAKE_EN_SETTING);
+}
+
 static int pmc_setup_dev(struct pci_dev *pdev)
 {
+	struct pmc_dev *pmc = &pmc_device;
+
 	/* Obtain ACPI base address */
 	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
 	acpi_base_addr &= ACPI_BASE_ADDR_MASK;
@@ -52,6 +83,17 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 	if (acpi_base_addr != 0 && pm_power_off == NULL)
 		pm_power_off = pmc_power_off;
 
+	pci_read_config_dword(pdev, PMC_BASE_ADDR_OFFSET, &pmc->base_addr);
+	pmc->base_addr &= PMC_BASE_ADDR_MASK;
+
+	pmc->regmap = ioremap_nocache(pmc->base_addr, PMC_MMIO_REG_LEN);
+	if (!pmc->regmap) {
+		dev_err(&pdev->dev, "error: ioremap failed\n");
+		return -ENOMEM;
+	}
+
+	/* PMC hardware registers setup */
+	pmc_hw_reg_setup(pmc);
 	return 0;
 }
 
-- 
1.7.10.4
