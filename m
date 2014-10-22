Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaJVUxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:53:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50447 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaJVUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:53:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Wed, 22 Oct 2014 22:52:19 +0200
Message-ID: <2148776.X8NPqiYA6S@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <3256560.C0cZnIlnAv@wuerfel> <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PI+jqVgBzeTnK+JLJovjRS8kJETx4SdM+JAykZIXsuE
 yaa0Au7L6hlSIij9tMIv37JcXPmnIulq7bgJoJlao4STmzK6vf
 qOIfS5fGolx7BU9l0q9yXbVDtgY6TCftIztLAqdZ4tJ4pHzmpq
 JE9lqqmxmK/8sO3hl/j1enEk2GV5dMyWl65DPiBpZYffwM3iK6
 7vdgGZYekMQ9THxsvOUgMuiLL7pk/DwR5opUOAN85XqGeLIYei
 VocaKvBo+rCQiOvgz2XIBn8SeI4jKi57XAQIYWKoH0pmSqRlow
 Z9LzruopyFDbxP/ZkWnvbOwdmauAMJlU0aLRQLfodQKtNzMXAU
 gdRuBpP5tprF1jp4prg8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2014 16:59:14 Lorenzo Pieralisi wrote:
> On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> 
> [...]
> 
> > The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
> > removed if we change the arm32 pcibios_init_hw function to call the new
> > interfaces that set the domain number.
> 
> I wished, but it is a bit more complicated than I thought unfortunately,
> mostly because some drivers, eg cns3xxx set the domain numbers
> statically in pci_sys_data and this sets a chain of dependency that is
> not easy to untangle. I think cns3xxx is the only legacy driver that "uses"
> the domain number (in pci_sys_data) in a way that clashes with the
> generic domain_nr implementation, I need to give it more thought.

Just had a look at that driver, shouldn't be too hard to change, see below.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index 45d6bd09e6ef..aa4b9d7c52fd 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -30,18 +30,15 @@ struct cns3xxx_pcie {
 	unsigned int irqs[2];
 	struct resource res_io;
 	struct resource res_mem;
-	struct hw_pci hw_pci;
-
+	int port;
 	bool linked;
 };
 
-static struct cns3xxx_pcie cns3xxx_pcie[]; /* forward decl. */
-
 static struct cns3xxx_pcie *sysdata_to_cnspci(void *sysdata)
 {
 	struct pci_sys_data *root = sysdata;
 
-	return &cns3xxx_pcie[root->domain];
+	return root->private_data;
 }
 
 static struct cns3xxx_pcie *pdev_to_cnspci(const struct pci_dev *dev)
@@ -192,13 +189,7 @@ static struct cns3xxx_pcie cns3xxx_pcie[] = {
 			.flags = IORESOURCE_MEM,
 		},
 		.irqs = { IRQ_CNS3XXX_PCIE0_RC, IRQ_CNS3XXX_PCIE0_DEVICE, },
-		.hw_pci = {
-			.domain = 0,
-			.nr_controllers = 1,
-			.ops = &cns3xxx_pcie_ops,
-			.setup = cns3xxx_pci_setup,
-			.map_irq = cns3xxx_pcie_map_irq,
-		},
+		.port = 0,
 	},
 	[1] = {
 		.host_regs = (void __iomem *)CNS3XXX_PCIE1_HOST_BASE_VIRT,
@@ -217,19 +208,13 @@ static struct cns3xxx_pcie cns3xxx_pcie[] = {
 			.flags = IORESOURCE_MEM,
 		},
 		.irqs = { IRQ_CNS3XXX_PCIE1_RC, IRQ_CNS3XXX_PCIE1_DEVICE, },
-		.hw_pci = {
-			.domain = 1,
-			.nr_controllers = 1,
-			.ops = &cns3xxx_pcie_ops,
-			.setup = cns3xxx_pci_setup,
-			.map_irq = cns3xxx_pcie_map_irq,
-		},
+		.port = 1,
 	},
 };
 
 static void __init cns3xxx_pcie_check_link(struct cns3xxx_pcie *cnspci)
 {
-	int port = cnspci->hw_pci.domain;
+	int port = cnspci->port;
 	u32 reg;
 	unsigned long time;
 
@@ -260,9 +245,10 @@ static void __init cns3xxx_pcie_check_link(struct cns3xxx_pcie *cnspci)
 
 static void __init cns3xxx_pcie_hw_init(struct cns3xxx_pcie *cnspci)
 {
-	int port = cnspci->hw_pci.domain;
+	int port = cnspci->port;
 	struct pci_sys_data sd = {
 		.domain = port,
+		.private_data = cnspci,
 	};
 	struct pci_bus bus = {
 		.number = 0,
@@ -323,6 +309,14 @@ static int cns3xxx_pcie_abort_handler(unsigned long addr, unsigned int fsr,
 void __init cns3xxx_pcie_init_late(void)
 {
 	int i;
+	void *private_data;
+	struct hw_pci hw_pci = {
+		.nr_controllers = 1,
+		.ops = &cns3xxx_pcie_ops,
+		.setup = cns3xxx_pci_setup,
+		.map_irq = cns3xxx_pcie_map_irq,
+		.private_data = &private_data,
+	};
 
 	pcibios_min_io = 0;
 	pcibios_min_mem = 0;
@@ -335,7 +329,9 @@ void __init cns3xxx_pcie_init_late(void)
 		cns3xxx_pwr_soft_rst(0x1 << PM_SOFT_RST_REG_OFFST_PCIE(i));
 		cns3xxx_pcie_check_link(&cns3xxx_pcie[i]);
 		cns3xxx_pcie_hw_init(&cns3xxx_pcie[i]);
-		pci_common_init(&cns3xxx_pcie[i].hw_pci);
+		hw_pci->domain = i;
+		private_data = &cns3xxx_pcie[i];
+		pci_common_init(&hw_pci);
 	}
 
 	pci_assign_unassigned_resources();


