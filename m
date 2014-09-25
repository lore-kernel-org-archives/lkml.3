Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaIYCvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:51:04 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62184 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaIYCu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:50:59 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 18/22] arm/iop13xx/MSI: Use MSI chip framework to configure MSI/MSI-X irq
Date: Thu, 25 Sep 2014 11:14:28 +0800
Message-ID: <1411614872-4009-19-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.5423830D.00AC,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8497adfa7941defe75d872dc140e6365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use MSI chip framework instead of arch MSI functions to configure
MSI/MSI-X irq. So we can manage MSI/MSI-X irq in a unified framework.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/arm/mach-iop13xx/include/mach/pci.h |    2 ++
 arch/arm/mach-iop13xx/iq81340mc.c        |    1 +
 arch/arm/mach-iop13xx/iq81340sc.c        |    1 +
 arch/arm/mach-iop13xx/msi.c              |    9 +++++++--
 arch/arm/mach-iop13xx/pci.c              |    6 ++++++
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-iop13xx/include/mach/pci.h b/arch/arm/mach-iop13xx/include/mach/pci.h
index 59f42b5..7a073cb 100644
--- a/arch/arm/mach-iop13xx/include/mach/pci.h
+++ b/arch/arm/mach-iop13xx/include/mach/pci.h
@@ -10,6 +10,8 @@ struct pci_bus *iop13xx_scan_bus(int nr, struct pci_sys_data *);
 void iop13xx_atu_select(struct hw_pci *plat_pci);
 void iop13xx_pci_init(void);
 void iop13xx_map_pci_memory(void);
+void iop13xx_add_bus(struct pci_bus *bus);
+extern struct msi_chip iop13xx_msi_chip;
 
 #define IOP_PCI_STATUS_ERROR (PCI_STATUS_PARITY |	     \
 			       PCI_STATUS_SIG_TARGET_ABORT | \
diff --git a/arch/arm/mach-iop13xx/iq81340mc.c b/arch/arm/mach-iop13xx/iq81340mc.c
index 9cd07d3..19d47cb 100644
--- a/arch/arm/mach-iop13xx/iq81340mc.c
+++ b/arch/arm/mach-iop13xx/iq81340mc.c
@@ -59,6 +59,7 @@ static struct hw_pci iq81340mc_pci __initdata = {
 	.map_irq	= iq81340mc_pcix_map_irq,
 	.scan		= iop13xx_scan_bus,
 	.preinit	= iop13xx_pci_init,
+	.add_bus	= iop13xx_add_bus;
 };
 
 static int __init iq81340mc_pci_init(void)
diff --git a/arch/arm/mach-iop13xx/iq81340sc.c b/arch/arm/mach-iop13xx/iq81340sc.c
index b3ec11c..4d56993 100644
--- a/arch/arm/mach-iop13xx/iq81340sc.c
+++ b/arch/arm/mach-iop13xx/iq81340sc.c
@@ -61,6 +61,7 @@ static struct hw_pci iq81340sc_pci __initdata = {
 	.scan		= iop13xx_scan_bus,
 	.map_irq	= iq81340sc_atux_map_irq,
 	.preinit	= iop13xx_pci_init
+	.add_bus	= iop13xx_add_bus;
 };
 
 static int __init iq81340sc_pci_init(void)
diff --git a/arch/arm/mach-iop13xx/msi.c b/arch/arm/mach-iop13xx/msi.c
index e7730cf..1a8cb2f 100644
--- a/arch/arm/mach-iop13xx/msi.c
+++ b/arch/arm/mach-iop13xx/msi.c
@@ -132,7 +132,7 @@ static struct irq_chip iop13xx_msi_chip = {
 	.irq_unmask = unmask_msi_irq,
 };
 
-int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+static int iop13xx_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
 	int id, irq = irq_alloc_desc_from(IRQ_IOP13XX_MSI_0, -1);
 	struct msi_msg msg;
@@ -159,7 +159,12 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	return 0;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+static void iop13xx_teardown_msi_irq(unsigned int irq)
 {
 	irq_free_desc(irq);
 }
+
+struct msi_chip iop13xx_chip = {
+	.setup_irq = iop13xx_setup_msi_irq,
+	.teardown_irq = iop13xx_teardown_msi_irq,
+};
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 9082b84..f498800 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -962,6 +962,12 @@ void __init iop13xx_atu_select(struct hw_pci *plat_pci)
 	}
 }
 
+void iop13xx_add_bus(struct pci_bus *bus)
+{
+	if (IS_ENABLED(CONFIG_PCI_MSI)) 
+		bus->msi = &iop13xx_msi_chip;
+}
+
 void __init iop13xx_pci_init(void)
 {
 	/* clear pre-existing south bridge errors */
-- 
1.7.1

