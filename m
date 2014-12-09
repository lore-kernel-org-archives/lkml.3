Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbaLIOEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:04:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:48645 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbaLIOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:04:39 -0500
Date: Tue, 9 Dec 2014 15:04:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq domain updates for 3.19
Message-ID: <alpine.DEB.2.11.1412091427590.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-irqdomain-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-irqdomain-for-linus

The real interesting irq updates:

 - Support for hierarchical irq domains:
   
   For complex interrupt routing scenarios where more than one
   interrupt related chip is involved we had no proper representation
   in the generic interrupt infrastructure so far. That mad people
   implement rather ugly constructs in their nested irq chip
   implementations. The main offenders are x86 and arm/gic.

   To distangle that mess we have now hierarchical irqdomains which
   seperate the various interrupt chips and connect them via the
   hierarchical domains. That keeps the domain specific details
   internal to the particular hierarchy level and removes the
   criss/cross referencing of chip internals. The resulting hierarchy
   for a complex x86 system will look like this:

   vector          mapped: 74
     msi-0         mapped: 2
     dmar-ir-1     mapped: 69
       ioapic-1    mapped: 4
       ioapic-0    mapped: 20
       pci-msi-2   mapped: 45
     dmar-ir-0     mapped: 3
       ioapic-2    mapped: 1
       pci-msi-1   mapped: 2
     htirq         mapped: 0

   Neither ioapic nor pci-msi know about the dmar interrupt remapping
   between themself and the vector domain. If interrupt remapping is
   disabled ioapic and pci-msi become direct childs of the vector
   domain.

   In hindsight we should have done that years ago, but in hindsight
   we always know better :)

 - Support for generic MSI interrupt domain handling

   We have more and more non PCI related MSI interrupts, so providing
   a generic infrastructure for this is better than having all
   affected architectures implementing their own private hacks.

 - Support for PCI-MSI interrupt domain handling, based on the generic
   MSI support.

   This part carries the pci/msi branch from Bjorn Helgaas pci tree to
   avoid a massive conflict. The PCI/MSI parts are acked by Bjorn.

I have two more branches on top of this. The full conversion of x86 to
hierarchical domains and a partial conversion of arm/gic.

Thanks,

	tglx

------------------>
Jiang Liu (20):
      PCI/MSI: Remove unnecessary braces around single statements
      PCI/MSI: Simplify PCI MSI code by initializing msi_desc.nvec_used earlier
      PCI/MSI: Kill redundant call of irq_set_msi_desc() for MSI-X interrupts
      PCI/MSI: Rename __read_msi_msg() to __pci_read_msi_msg()
      PCI/MSI: Rename write_msi_msg() to pci_write_msi_msg()
      PCI/MSI: Introduce helpers to hide struct msi_desc implementation details
      irqdomain: Introduce new interfaces to support hierarchy irqdomains
      genirq: Introduce helper functions to support stacked irq_chip
      genirq: Introduce irq_chip.irq_compose_msi_msg() to support stacked irqchip
      genirq: Add IRQ_SET_MASK_OK_DONE to support stacked irqchip
      genirq: Introduce helper irq_domain_set_info() to reduce duplicated code
      irqdomain: Implement a method to automatically call parent domains alloc/free
      irqdomain: Introduce helper function irq_domain_add_hierarchy()
      genirq: Introduce callback irq_chip.irq_write_msi_msg
      genirq: Add generic msi irq domain support
      genirq: Introduce msi_domain_alloc/free_irqs()
      genirq: Provide default callbacks for msi_domain_ops
      PCI/MSI: Move cached entry functions to irq core
      PCI/MSI: Enhance core to support hierarchy irqdomain
      PCI/MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from irqdomain

Marc Zyngier (2):
      genirq: Work around __irq_set_handler vs stacked domains ordering issues
      PCI/MSI: Allow an msi_controller to be associated to an irq domain

Thomas Gleixner (5):
      PCI/MSI: Rename mask/unmask_msi_irq et al
      PCI/MSI: Rename mask/unmask_msi_irq treewide
      genirq: Split out flow handler typedefs into seperate header file
      asm-generic: Add msi.h
      genirq: Move irq_chip_write_msi_msg() helper to core

Yijing Wang (12):
      PCI/MSI: Add pci_msi_ignore_mask to prevent writes to MSI/MSI-X Mask Bits
      Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()"
      s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq()
      PCI/MSI: Rename "struct msi_chip" to "struct msi_controller"
      PCI/MSI: Add weak pcibios_msi_controller()
      ARM/PCI: Save MSI controller in pci_sys_data
      PCI: tegra: Save MSI controller in pci_sys_data
      PCI: designware: Save MSI controller in pci_sys_data
      PCI: rcar: Save MSI controller in pci_sys_data
      PCI: mvebu: Save MSI controller in pci_sys_data
      PCI: xilinx: Save MSI controller in pci_sys_data
      ARM/PCI: Remove unused pcibios_add_bus() and pcibios_remove_bus()

Yingjoe Chen (2):
      irqdomain: Do irq_find_mapping and set_type for hierarchy irqdomain in case OF
      genirq: Add more helper functions to support stacked irq_chip


 Documentation/IRQ-domain.txt           |  71 +++++
 arch/arm/include/asm/mach/pci.h        |  10 +-
 arch/arm/kernel/bios32.c               |  28 +-
 arch/arm/mach-iop13xx/msi.c            |  10 +-
 arch/ia64/kernel/msi_ia64.c            |   8 +-
 arch/ia64/sn/kernel/msi_sn.c           |   8 +-
 arch/mips/pci/msi-octeon.c             |   2 +-
 arch/mips/pci/msi-xlp.c                |  12 +-
 arch/mips/pci/pci-xlr.c                |   2 +-
 arch/powerpc/platforms/cell/axon_msi.c |   8 +-
 arch/powerpc/platforms/powernv/pci.c   |   2 +-
 arch/powerpc/platforms/pseries/msi.c   |   2 +-
 arch/powerpc/sysdev/fsl_msi.c          |   6 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c  |   6 +-
 arch/powerpc/sysdev/mpic_u3msi.c       |   6 +-
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  |   2 +-
 arch/powerpc/sysdev/ppc4xx_msi.c       |   2 +-
 arch/powerpc/sysdev/xics/ics-opal.c    |   2 +-
 arch/powerpc/sysdev/xics/ics-rtas.c    |   2 +-
 arch/s390/pci/pci.c                    |  10 +-
 arch/sparc/kernel/pci_msi.c            |  10 +-
 arch/tile/kernel/pci_gx.c              |   8 +-
 arch/x86/include/asm/x86_init.h        |   3 -
 arch/x86/kernel/apic/io_apic.c         |   8 +-
 arch/x86/kernel/x86_init.c             |  10 -
 arch/x86/pci/xen.c                     |  19 +-
 drivers/iommu/irq_remapping.c          |   8 -
 drivers/irqchip/irq-armada-370-xp.c    |  16 +-
 drivers/of/of_pci.c                    |   8 +-
 drivers/pci/Kconfig                    |   6 +
 drivers/pci/host/pci-keystone-dw.c     |   6 +-
 drivers/pci/host/pci-keystone.h        |   2 +-
 drivers/pci/host/pci-mvebu.c           |  13 +-
 drivers/pci/host/pci-tegra.c           |  35 +-
 drivers/pci/host/pcie-designware.c     |  32 +-
 drivers/pci/host/pcie-designware.h     |   2 +-
 drivers/pci/host/pcie-rcar.c           |  31 +-
 drivers/pci/host/pcie-xilinx.c         |  37 +--
 drivers/pci/msi.c                      | 394 ++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_intrs.c      |   2 +-
 include/asm-generic/msi.h              |  32 ++
 include/linux/irq.h                    |  33 +-
 include/linux/irqdomain.h              | 101 ++++++
 include/linux/irqhandler.h             |  14 +
 include/linux/msi.h                    | 187 ++++++++++-
 include/linux/of_pci.h                 |  12 +-
 include/linux/pci.h                    |   2 +-
 kernel/irq/Kconfig                     |  15 +
 kernel/irq/Makefile                    |   1 +
 kernel/irq/chip.c                      | 130 +++++++-
 kernel/irq/irqdomain.c                 | 567 +++++++++++++++++++++++++++++++--
 kernel/irq/manage.c                    |   2 +
 kernel/irq/msi.c                       | 330 +++++++++++++++++++
 53 files changed, 1924 insertions(+), 351 deletions(-)
 create mode 100644 include/asm-generic/msi.h
 create mode 100644 include/linux/irqhandler.h
 create mode 100644 kernel/irq/msi.c

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 8a8b82c9ca53..39cfa72732ff 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -151,3 +151,74 @@ used and no descriptor gets allocated it is very important to make sure
 that the driver using the simple domain call irq_create_mapping()
 before any irq_find_mapping() since the latter will actually work
 for the static IRQ assignment case.
+
+==== Hierarchy IRQ domain ====
+On some architectures, there may be multiple interrupt controllers
+involved in delivering an interrupt from the device to the target CPU.
+Let's look at a typical interrupt delivering path on x86 platforms:
+
+Device --> IOAPIC -> Interrupt remapping Controller -> Local APIC -> CPU
+
+There are three interrupt controllers involved:
+1) IOAPIC controller
+2) Interrupt remapping controller
+3) Local APIC controller
+
+To support such a hardware topology and make software architecture match
+hardware architecture, an irq_domain data structure is built for each
+interrupt controller and those irq_domains are organized into hierarchy.
+When building irq_domain hierarchy, the irq_domain near to the device is
+child and the irq_domain near to CPU is parent. So a hierarchy structure
+as below will be built for the example above.
+	CPU Vector irq_domain (root irq_domain to manage CPU vectors)
+		^
+		|
+	Interrupt Remapping irq_domain (manage irq_remapping entries)
+		^
+		|
+	IOAPIC irq_domain (manage IOAPIC delivery entries/pins)
+
+There are four major interfaces to use hierarchy irq_domain:
+1) irq_domain_alloc_irqs(): allocate IRQ descriptors and interrupt
+   controller related resources to deliver these interrupts.
+2) irq_domain_free_irqs(): free IRQ descriptors and interrupt controller
+   related resources associated with these interrupts.
+3) irq_domain_activate_irq(): activate interrupt controller hardware to
+   deliver the interrupt.
+3) irq_domain_deactivate_irq(): deactivate interrupt controller hardware
+   to stop delivering the interrupt.
+
+Following changes are needed to support hierarchy irq_domain.
+1) a new field 'parent' is added to struct irq_domain; it's used to
+   maintain irq_domain hierarchy information.
+2) a new field 'parent_data' is added to struct irq_data; it's used to
+   build hierarchy irq_data to match hierarchy irq_domains. The irq_data
+   is used to store irq_domain pointer and hardware irq number.
+3) new callbacks are added to struct irq_domain_ops to support hierarchy
+   irq_domain operations.
+
+With support of hierarchy irq_domain and hierarchy irq_data ready, an
+irq_domain structure is built for each interrupt controller, and an
+irq_data structure is allocated for each irq_domain associated with an
+IRQ. Now we could go one step further to support stacked(hierarchy)
+irq_chip. That is, an irq_chip is associated with each irq_data along
+the hierarchy. A child irq_chip may implement a required action by
+itself or by cooperating with its parent irq_chip.
+
+With stacked irq_chip, interrupt controller driver only needs to deal
+with the hardware managed by itself and may ask for services from its
+parent irq_chip when needed. So we could achieve a much cleaner
+software architecture.
+
+For an interrupt controller driver to support hierarchy irq_domain, it
+needs to:
+1) Implement irq_domain_ops.alloc and irq_domain_ops.free
+2) Optionally implement irq_domain_ops.activate and
+   irq_domain_ops.deactivate.
+3) Optionally implement an irq_chip to manage the interrupt controller
+   hardware.
+4) No need to implement irq_domain_ops.map and irq_domain_ops.unmap,
+   they are unused with hierarchy irq_domain.
+
+Hierarchy irq_domain may also be used to support other architectures,
+such as ARM, ARM64 etc.
diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 7fc42784becb..8292b5f81e23 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -22,6 +22,9 @@ struct hw_pci {
 #ifdef CONFIG_PCI_DOMAINS
 	int		domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+	struct msi_controller *msi_ctrl;
+#endif
 	struct pci_ops	*ops;
 	int		nr_controllers;
 	void		**private_data;
@@ -36,8 +39,6 @@ struct hw_pci {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
-	void		(*remove_bus)(struct pci_bus *bus);
 };
 
 /*
@@ -47,6 +48,9 @@ struct pci_sys_data {
 #ifdef CONFIG_PCI_DOMAINS
 	int		domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+	struct msi_controller *msi_ctrl;
+#endif
 	struct list_head node;
 	int		busnr;		/* primary bus number			*/
 	u64		mem_offset;	/* bus->cpu memory mapping offset	*/
@@ -65,8 +69,6 @@ struct pci_sys_data {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
-	void		(*remove_bus)(struct pci_bus *bus);
 	void		*private_data;	/* platform controller private data	*/
 };
 
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c17f7f5..daaff73bc776 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -18,6 +18,15 @@
 
 static int debug_pci;
 
+#ifdef CONFIG_PCI_MSI
+struct msi_controller *pcibios_msi_controller(struct pci_dev *dev)
+{
+	struct pci_sys_data *sysdata = dev->bus->sysdata;
+
+	return sysdata->msi_ctrl;
+}
+#endif
+
 /*
  * We can't use pci_get_device() here since we are
  * called from interrupt context.
@@ -360,20 +369,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pcibios_fixup_bus);
 
-void pcibios_add_bus(struct pci_bus *bus)
-{
-	struct pci_sys_data *sys = bus->sysdata;
-	if (sys->add_bus)
-		sys->add_bus(bus);
-}
-
-void pcibios_remove_bus(struct pci_bus *bus)
-{
-	struct pci_sys_data *sys = bus->sysdata;
-	if (sys->remove_bus)
-		sys->remove_bus(bus);
-}
-
 /*
  * Swizzle the device pin each time we cross a bridge.  If a platform does
  * not provide a swizzle function, we perform the standard PCI swizzling.
@@ -471,12 +466,13 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 #ifdef CONFIG_PCI_DOMAINS
 		sys->domain  = hw->domain;
 #endif
+#ifdef CONFIG_PCI_MSI
+		sys->msi_ctrl = hw->msi_ctrl;
+#endif
 		sys->busnr   = busnr;
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
 		sys->align_resource = hw->align_resource;
-		sys->add_bus = hw->add_bus;
-		sys->remove_bus = hw->remove_bus;
 		INIT_LIST_HEAD(&sys->resources);
 
 		if (hw->private_data)
diff --git a/arch/arm/mach-iop13xx/msi.c b/arch/arm/mach-iop13xx/msi.c
index e7730cf9c15d..9f89e76dfbb9 100644
--- a/arch/arm/mach-iop13xx/msi.c
+++ b/arch/arm/mach-iop13xx/msi.c
@@ -126,10 +126,10 @@ static void iop13xx_msi_nop(struct irq_data *d)
 static struct irq_chip iop13xx_msi_chip = {
 	.name = "PCI-MSI",
 	.irq_ack = iop13xx_msi_nop,
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
@@ -153,7 +153,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	id = iop13xx_cpu_id();
 	msg.data = (id << IOP13XX_MU_MIMR_CORE_SELECT) | (irq & 0x7f);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &iop13xx_msi_chip, handle_simple_irq);
 
 	return 0;
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 8c3730c3c63d..8ae36ea177d3 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -35,7 +35,7 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 	data |= MSI_DATA_VECTOR(irq_to_vector(irq));
 	msg.data = data;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	cpumask_copy(idata->affinity, cpumask_of(cpu));
 
 	return 0;
@@ -71,7 +71,7 @@ int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(vector);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &ia64_msi_chip, handle_edge_irq);
 
 	return 0;
@@ -102,8 +102,8 @@ static int ia64_msi_retrigger_irq(struct irq_data *data)
  */
 static struct irq_chip ia64_msi_chip = {
 	.name			= "PCI-MSI",
-	.irq_mask		= mask_msi_irq,
-	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= pci_msi_mask_irq,
+	.irq_unmask		= pci_msi_unmask_irq,
 	.irq_ack		= ia64_ack_msi_irq,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	= ia64_set_msi_irq_affinity,
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 446e7799928c..a0eb27b66d13 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -145,7 +145,7 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 	msg.data = 0x100 + irq;
 
 	irq_set_msi_desc(irq, entry);
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &sn_msi_chip, handle_edge_irq);
 
 	return 0;
@@ -205,7 +205,7 @@ static int sn_set_msi_irq_affinity(struct irq_data *data,
 	msg.address_hi = (u32)(bus_addr >> 32);
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	cpumask_copy(data->affinity, cpu_mask);
 
 	return 0;
@@ -228,8 +228,8 @@ static int sn_msi_retrigger_irq(struct irq_data *data)
 
 static struct irq_chip sn_msi_chip = {
 	.name			= "PCI-MSI",
-	.irq_mask		= mask_msi_irq,
-	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= pci_msi_mask_irq,
+	.irq_unmask		= pci_msi_unmask_irq,
 	.irq_ack		= sn_ack_msi_irq,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	= sn_set_msi_irq_affinity,
diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index 63bbe07a1ccd..cffaaf4aae3c 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -178,7 +178,7 @@ msi_irq_allocated:
 	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
 
 	irq_set_msi_desc(irq, desc);
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	return 0;
 }
 
diff --git a/arch/mips/pci/msi-xlp.c b/arch/mips/pci/msi-xlp.c
index fa374fe3746b..aa7dea3eb064 100644
--- a/arch/mips/pci/msi-xlp.c
+++ b/arch/mips/pci/msi-xlp.c
@@ -217,7 +217,7 @@ static void xlp_msix_mask_ack(struct irq_data *d)
 
 	msixvec = nlm_irq_msixvec(d->irq);
 	link = nlm_irq_msixlink(msixvec);
-	mask_msi_irq(d);
+	pci_msi_mask_irq(d);
 	md = irq_data_get_irq_handler_data(d);
 
 	/* Ack MSI on bridge */
@@ -239,10 +239,10 @@ static void xlp_msix_mask_ack(struct irq_data *d)
 
 static struct irq_chip xlp_msix_chip = {
 	.name		= "XLP-MSIX",
-	.irq_enable	= unmask_msi_irq,
-	.irq_disable	= mask_msi_irq,
+	.irq_enable	= pci_msi_unmask_irq,
+	.irq_disable	= pci_msi_mask_irq,
 	.irq_mask_ack	= xlp_msix_mask_ack,
-	.irq_unmask	= unmask_msi_irq,
+	.irq_unmask	= pci_msi_unmask_irq,
 };
 
 void arch_teardown_msi_irq(unsigned int irq)
@@ -345,7 +345,7 @@ static int xlp_setup_msi(uint64_t lnkbase, int node, int link,
 	if (ret < 0)
 		return ret;
 
-	write_msi_msg(xirq, &msg);
+	pci_write_msi_msg(xirq, &msg);
 	return 0;
 }
 
@@ -448,7 +448,7 @@ static int xlp_setup_msix(uint64_t lnkbase, int node, int link,
 		return ret;
 	}
 
-	write_msi_msg(xirq, &msg);
+	pci_write_msi_msg(xirq, &msg);
 	return 0;
 }
 
diff --git a/arch/mips/pci/pci-xlr.c b/arch/mips/pci/pci-xlr.c
index 0dde80332d3a..26d2dabef281 100644
--- a/arch/mips/pci/pci-xlr.c
+++ b/arch/mips/pci/pci-xlr.c
@@ -260,7 +260,7 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 	if (ret < 0)
 		return ret;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	return 0;
 }
 #endif
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 862b32702d29..0883994df384 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -279,7 +279,7 @@ static int axon_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 		irq_set_msi_desc(virq, entry);
 		msg.data = virq;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 
 	return 0;
@@ -301,9 +301,9 @@ static void axon_msi_teardown_msi_irqs(struct pci_dev *dev)
 }
 
 static struct irq_chip msic_irq_chip = {
-	.irq_mask	= mask_msi_irq,
-	.irq_unmask	= unmask_msi_irq,
-	.irq_shutdown	= mask_msi_irq,
+	.irq_mask	= pci_msi_mask_irq,
+	.irq_unmask	= pci_msi_unmask_irq,
+	.irq_shutdown	= pci_msi_mask_irq,
 	.name		= "AXON-MSI",
 };
 
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index b3ca77ddf36d..e79a38a1df9f 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -91,7 +91,7 @@ static int pnv_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			return rc;
 		}
 		irq_set_msi_desc(virq, entry);
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 }
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 8ab5add4ac82..90f756d0f58f 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -476,7 +476,7 @@ again:
 		irq_set_msi_desc(virq, entry);
 
 		/* Read config space back so we can restore after reset */
-		__read_msi_msg(entry, &msg);
+		__pci_read_msi_msg(entry, &msg);
 		entry->msg = msg;
 	}
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index de40b48b460e..19d4b2c3d7fd 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -82,8 +82,8 @@ static void fsl_msi_print_chip(struct irq_data *irqd, struct seq_file *p)
 
 
 static struct irq_chip fsl_msi_chip = {
-	.irq_mask	= mask_msi_irq,
-	.irq_unmask	= unmask_msi_irq,
+	.irq_mask	= pci_msi_mask_irq,
+	.irq_unmask	= pci_msi_unmask_irq,
 	.irq_ack	= fsl_msi_end_irq,
 	.irq_print_chip = fsl_msi_print_chip,
 };
@@ -242,7 +242,7 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		irq_set_msi_desc(virq, entry);
 
 		fsl_compose_msi_msg(pdev, hwirq, &msg, msi_data);
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 
diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 15dccd35fa11..45c114bc430b 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -42,7 +42,7 @@ static struct mpic *msi_mpic;
 static void mpic_pasemi_msi_mask_irq(struct irq_data *data)
 {
 	pr_debug("mpic_pasemi_msi_mask_irq %d\n", data->irq);
-	mask_msi_irq(data);
+	pci_msi_mask_irq(data);
 	mpic_mask_irq(data);
 }
 
@@ -50,7 +50,7 @@ static void mpic_pasemi_msi_unmask_irq(struct irq_data *data)
 {
 	pr_debug("mpic_pasemi_msi_unmask_irq %d\n", data->irq);
 	mpic_unmask_irq(data);
-	unmask_msi_irq(data);
+	pci_msi_unmask_irq(data);
 }
 
 static struct irq_chip mpic_pasemi_msi_chip = {
@@ -136,7 +136,7 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		 * register to generate MSI [512...1023]
 		 */
 		msg.data = hwirq-0x200;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 
 	return 0;
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 623d7fba15b4..0dff1cd44481 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -25,14 +25,14 @@ static struct mpic *msi_mpic;
 
 static void mpic_u3msi_mask_irq(struct irq_data *data)
 {
-	mask_msi_irq(data);
+	pci_msi_mask_irq(data);
 	mpic_mask_irq(data);
 }
 
 static void mpic_u3msi_unmask_irq(struct irq_data *data)
 {
 	mpic_unmask_irq(data);
-	unmask_msi_irq(data);
+	pci_msi_unmask_irq(data);
 }
 
 static struct irq_chip mpic_u3msi_chip = {
@@ -171,7 +171,7 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		printk("u3msi: allocated virq 0x%x (hw 0x%x) addr 0x%lx\n",
 			  virq, hwirq, (unsigned long)addr);
 		msg.data = hwirq;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 
 		hwirq++;
 	}
diff --git a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
index a6a4dbda9078..908105f835d1 100644
--- a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
@@ -85,7 +85,7 @@ static int hsta_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
 			return -EINVAL;
 		}
-		write_msi_msg(hwirq, &msg);
+		pci_write_msi_msg(hwirq, &msg);
 	}
 
 	return 0;
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 22b5200636e7..518eabbe0bdc 100644
--- a/arch/powerpc/sysdev/ppc4xx_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -116,7 +116,7 @@ static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 		irq_set_msi_desc(virq, entry);
 		msg.data = int_no;
-		write_msi_msg(virq, &msg);
+		pci_write_msi_msg(virq, &msg);
 	}
 	return 0;
 }
diff --git a/arch/powerpc/sysdev/xics/ics-opal.c b/arch/powerpc/sysdev/xics/ics-opal.c
index 3c6ee1b64e5d..4ba554ec8eaf 100644
--- a/arch/powerpc/sysdev/xics/ics-opal.c
+++ b/arch/powerpc/sysdev/xics/ics-opal.c
@@ -73,7 +73,7 @@ static unsigned int ics_opal_startup(struct irq_data *d)
 	 * at that level, so we do it here by hand.
 	 */
 	if (d->msi_desc)
-		unmask_msi_irq(d);
+		pci_msi_unmask_irq(d);
 #endif
 
 	/* unmask it */
diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-rtas.c
index 936575d99c5c..bc81335b2cbc 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -76,7 +76,7 @@ static unsigned int ics_rtas_startup(struct irq_data *d)
 	 * at that level, so we do it here by hand.
 	 */
 	if (d->msi_desc)
-		unmask_msi_irq(d);
+		pci_msi_unmask_irq(d);
 #endif
 	/* unmask it */
 	ics_rtas_unmask_irq(d);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 2fa7b14b9c08..d59c82569750 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -50,8 +50,8 @@ static DEFINE_SPINLOCK(zpci_list_lock);
 
 static struct irq_chip zpci_irq_chip = {
 	.name = "zPCI",
-	.irq_unmask = unmask_msi_irq,
-	.irq_mask = mask_msi_irq,
+	.irq_unmask = pci_msi_unmask_irq,
+	.irq_mask = pci_msi_mask_irq,
 };
 
 static DECLARE_BITMAP(zpci_domain, ZPCI_NR_DEVICES);
@@ -403,7 +403,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		msg.data = hwirq;
 		msg.address_lo = zdev->msi_addr & 0xffffffff;
 		msg.address_hi = zdev->msi_addr >> 32;
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 		airq_iv_set_data(zdev->aibv, hwirq, irq);
 		hwirq++;
 	}
@@ -448,9 +448,9 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 	/* Release MSI interrupts */
 	list_for_each_entry(msi, &pdev->msi_list, list) {
 		if (msi->msi_attrib.is_msix)
-			default_msix_mask_irq(msi, 1);
+			__pci_msix_desc_mask_irq(msi, 1);
 		else
-			default_msi_mask_irq(msi, 1, 1);
+			__pci_msi_desc_mask_irq(msi, 1, 1);
 		irq_set_msi_desc(msi->irq, NULL);
 		irq_free_desc(msi->irq);
 		msi->msg.address_lo = 0;
diff --git a/arch/sparc/kernel/pci_msi.c b/arch/sparc/kernel/pci_msi.c
index 580651af73f2..84e16d81a6d8 100644
--- a/arch/sparc/kernel/pci_msi.c
+++ b/arch/sparc/kernel/pci_msi.c
@@ -111,10 +111,10 @@ static void free_msi(struct pci_pbm_info *pbm, int msi_num)
 
 static struct irq_chip msi_irq = {
 	.name		= "PCI-MSI",
-	.irq_mask	= mask_msi_irq,
-	.irq_unmask	= unmask_msi_irq,
-	.irq_enable	= unmask_msi_irq,
-	.irq_disable	= mask_msi_irq,
+	.irq_mask	= pci_msi_mask_irq,
+	.irq_unmask	= pci_msi_unmask_irq,
+	.irq_enable	= pci_msi_unmask_irq,
+	.irq_disable	= pci_msi_mask_irq,
 	/* XXX affinity XXX */
 };
 
@@ -161,7 +161,7 @@ static int sparc64_setup_msi_irq(unsigned int *irq_p,
 	msg.data = msi;
 
 	irq_set_msi_desc(*irq_p, entry);
-	write_msi_msg(*irq_p, &msg);
+	pci_write_msi_msg(*irq_p, &msg);
 
 	return 0;
 
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index e39f9c542807..e717af20dada 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1453,7 +1453,7 @@ static struct pci_ops tile_cfg_ops = {
 static unsigned int tilegx_msi_startup(struct irq_data *d)
 {
 	if (d->msi_desc)
-		unmask_msi_irq(d);
+		pci_msi_unmask_irq(d);
 
 	return 0;
 }
@@ -1465,14 +1465,14 @@ static void tilegx_msi_ack(struct irq_data *d)
 
 static void tilegx_msi_mask(struct irq_data *d)
 {
-	mask_msi_irq(d);
+	pci_msi_mask_irq(d);
 	__insn_mtspr(SPR_IPI_MASK_SET_K, 1UL << d->irq);
 }
 
 static void tilegx_msi_unmask(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_MASK_RESET_K, 1UL << d->irq);
-	unmask_msi_irq(d);
+	pci_msi_unmask_irq(d);
 }
 
 static struct irq_chip tilegx_msi_chip = {
@@ -1590,7 +1590,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	msg.address_hi = msi_addr >> 32;
 	msg.address_lo = msi_addr & 0xffffffff;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &tilegx_msi_chip, handle_level_irq);
 	irq_set_handler_data(irq, controller);
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da96bf1..f58a9c7a3c86 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -172,7 +172,6 @@ struct x86_platform_ops {
 
 struct pci_dev;
 struct msi_msg;
-struct msi_desc;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
@@ -183,8 +182,6 @@ struct x86_msi_ops {
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev);
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
-	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
-	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
 };
 
 struct IO_APIC_route_entry;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1183d545da1e..7ffe0a2b870f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3158,7 +3158,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	__write_msi_msg(data->msi_desc, &msg);
+	__pci_write_msi_msg(data->msi_desc, &msg);
 
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
@@ -3169,8 +3169,8 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
  */
 static struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
-	.irq_unmask		= unmask_msi_irq,
-	.irq_mask		= mask_msi_irq,
+	.irq_unmask		= pci_msi_unmask_irq,
+	.irq_mask		= pci_msi_mask_irq,
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
@@ -3196,7 +3196,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
 	 */
 	if (!irq_offset)
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 
 	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e48b674639cc..234b0722de53 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -116,8 +116,6 @@ struct x86_msi_ops x86_msi = {
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
 	.restore_msi_irqs	= default_restore_msi_irqs,
 	.setup_hpet_msi		= default_setup_hpet_msi,
-	.msi_mask_irq		= default_msi_mask_irq,
-	.msix_mask_irq		= default_msix_mask_irq,
 };
 
 /* MSI arch specific hooks */
@@ -140,14 +138,6 @@ void arch_restore_msi_irqs(struct pci_dev *dev)
 {
 	x86_msi.restore_msi_irqs(dev);
 }
-u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
-{
-	return x86_msi.msi_mask_irq(desc, mask, flag);
-}
-u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
-{
-	return x86_msi.msix_mask_irq(desc, flag);
-}
 #endif
 
 struct x86_io_apic_ops x86_io_apic_ops = {
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 093f5f4272d3..1819a91bbb9f 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -229,7 +229,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return 1;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		__read_msi_msg(msidesc, &msg);
+		__pci_read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
 		if (msg.data != XEN_PIRQ_MSI_DATA ||
@@ -240,7 +240,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				goto error;
 			}
 			xen_msi_compose_msg(dev, pirq, &msg);
-			__write_msi_msg(msidesc, &msg);
+			__pci_write_msi_msg(msidesc, &msg);
 			dev_dbg(&dev->dev, "xen: msi bound to pirq=%d\n", pirq);
 		} else {
 			dev_dbg(&dev->dev,
@@ -394,14 +394,7 @@ static void xen_teardown_msi_irq(unsigned int irq)
 {
 	xen_destroy_irq(irq);
 }
-static u32 xen_nop_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
-{
-	return 0;
-}
-static u32 xen_nop_msix_mask_irq(struct msi_desc *desc, u32 flag)
-{
-	return 0;
-}
+
 #endif
 
 int __init pci_xen_init(void)
@@ -425,8 +418,7 @@ int __init pci_xen_init(void)
 	x86_msi.setup_msi_irqs = xen_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 	x86_msi.teardown_msi_irqs = xen_teardown_msi_irqs;
-	x86_msi.msi_mask_irq = xen_nop_msi_mask_irq;
-	x86_msi.msix_mask_irq = xen_nop_msix_mask_irq;
+	pci_msi_ignore_mask = 1;
 #endif
 	return 0;
 }
@@ -506,8 +498,7 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
-	x86_msi.msi_mask_irq = xen_nop_msi_mask_irq;
-	x86_msi.msix_mask_irq = xen_nop_msix_mask_irq;
+	pci_msi_ignore_mask = 1;
 #endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 74a1767c89b5..2c3f5ad01098 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -56,19 +56,13 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
-	WARN_ON(!list_is_singular(&dev->msi_list));
 	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-	WARN_ON(msidesc->irq);
-	WARN_ON(msidesc->msi_attrib.multiple);
-	WARN_ON(msidesc->nvec_used);
 
 	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
 	if (irq == 0)
 		return -ENOSPC;
 
 	nvec_pow2 = __roundup_pow_of_two(nvec);
-	msidesc->nvec_used = nvec;
-	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
 			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
@@ -96,8 +90,6 @@ error:
 	 * IRQs from tearing down again in default_teardown_msi_irqs()
 	 */
 	msidesc->irq = 0;
-	msidesc->nvec_used = 0;
-	msidesc->msi_attrib.multiple = 0;
 
 	return ret;
 }
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3e238cd049e6..1aeffcac66b8 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -129,7 +129,7 @@ static void armada_370_xp_free_msi(int hwirq)
 	mutex_unlock(&msi_used_lock);
 }
 
-static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
+static int armada_370_xp_setup_msi_irq(struct msi_controller *chip,
 				       struct pci_dev *pdev,
 				       struct msi_desc *desc)
 {
@@ -156,11 +156,11 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
 	msg.address_hi = 0;
 	msg.data = 0xf00 | (hwirq + 16);
 
-	write_msi_msg(virq, &msg);
+	pci_write_msi_msg(virq, &msg);
 	return 0;
 }
 
-static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
+static void armada_370_xp_teardown_msi_irq(struct msi_controller *chip,
 					   unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
@@ -172,10 +172,10 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
 
 static struct irq_chip armada_370_xp_msi_irq_chip = {
 	.name = "armada_370_xp_msi_irq",
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 static int armada_370_xp_msi_map(struct irq_domain *domain, unsigned int virq,
@@ -195,7 +195,7 @@ static const struct irq_domain_ops armada_370_xp_msi_irq_ops = {
 static int armada_370_xp_msi_init(struct device_node *node,
 				  phys_addr_t main_int_phys_base)
 {
-	struct msi_chip *msi_chip;
+	struct msi_controller *msi_chip;
 	u32 reg;
 	int ret;
 
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8882b467be95..88471d3d98cd 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
 static LIST_HEAD(of_pci_msi_chip_list);
 static DEFINE_MUTEX(of_pci_msi_chip_mutex);
 
-int of_pci_msi_chip_add(struct msi_chip *chip)
+int of_pci_msi_chip_add(struct msi_controller *chip)
 {
 	if (!of_property_read_bool(chip->of_node, "msi-controller"))
 		return -EINVAL;
@@ -249,7 +249,7 @@ int of_pci_msi_chip_add(struct msi_chip *chip)
 }
 EXPORT_SYMBOL_GPL(of_pci_msi_chip_add);
 
-void of_pci_msi_chip_remove(struct msi_chip *chip)
+void of_pci_msi_chip_remove(struct msi_controller *chip)
 {
 	mutex_lock(&of_pci_msi_chip_mutex);
 	list_del(&chip->list);
@@ -257,9 +257,9 @@ void of_pci_msi_chip_remove(struct msi_chip *chip)
 }
 EXPORT_SYMBOL_GPL(of_pci_msi_chip_remove);
 
-struct msi_chip *of_pci_find_msi_chip_by_node(struct device_node *of_node)
+struct msi_controller *of_pci_find_msi_chip_by_node(struct device_node *of_node)
 {
-	struct msi_chip *c;
+	struct msi_controller *c;
 
 	mutex_lock(&of_pci_msi_chip_mutex);
 	list_for_each_entry(c, &of_pci_msi_chip_list, list) {
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 893503fa1782..cced84233ac0 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -4,6 +4,7 @@
 config PCI_MSI
 	bool "Message Signaled Interrupts (MSI and MSI-X)"
 	depends on PCI
+	select GENERIC_MSI_IRQ
 	help
 	   This allows device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
@@ -16,6 +17,11 @@ config PCI_MSI
 
 	   If you don't know what to do here, say Y.
 
+config PCI_MSI_IRQ_DOMAIN
+	bool
+	depends on PCI_MSI
+	select GENERIC_MSI_IRQ_DOMAIN
+
 config PCI_DEBUG
 	bool "PCI Debugging"
 	depends on PCI && DEBUG_KERNEL
diff --git a/drivers/pci/host/pci-keystone-dw.c b/drivers/pci/host/pci-keystone-dw.c
index 34086ce88e8e..313338db0e43 100644
--- a/drivers/pci/host/pci-keystone-dw.c
+++ b/drivers/pci/host/pci-keystone-dw.c
@@ -155,7 +155,7 @@ static void ks_dw_pcie_msi_irq_mask(struct irq_data *d)
 	/* Mask the end point if PVM implemented */
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		if (msi->msi_attrib.maskbit)
-			mask_msi_irq(d);
+			pci_msi_mask_irq(d);
 	}
 
 	ks_dw_pcie_msi_clear_irq(pp, offset);
@@ -177,7 +177,7 @@ static void ks_dw_pcie_msi_irq_unmask(struct irq_data *d)
 	/* Mask the end point if PVM implemented */
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		if (msi->msi_attrib.maskbit)
-			unmask_msi_irq(d);
+			pci_msi_unmask_irq(d);
 	}
 
 	ks_dw_pcie_msi_set_irq(pp, offset);
@@ -205,7 +205,7 @@ const struct irq_domain_ops ks_dw_pcie_msi_domain_ops = {
 	.map = ks_dw_pcie_msi_map,
 };
 
-int ks_dw_pcie_msi_host_init(struct pcie_port *pp, struct msi_chip *chip)
+int ks_dw_pcie_msi_host_init(struct pcie_port *pp, struct msi_controller *chip)
 {
 	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
 	int i;
diff --git a/drivers/pci/host/pci-keystone.h b/drivers/pci/host/pci-keystone.h
index 1fc1fceede9e..478d932b602d 100644
--- a/drivers/pci/host/pci-keystone.h
+++ b/drivers/pci/host/pci-keystone.h
@@ -55,4 +55,4 @@ void ks_dw_pcie_msi_set_irq(struct pcie_port *pp, int irq);
 void ks_dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq);
 void ks_dw_pcie_v3_65_scan_bus(struct pcie_port *pp);
 int ks_dw_pcie_msi_host_init(struct pcie_port *pp,
-		struct msi_chip *chip);
+		struct msi_controller *chip);
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index b1315e197ffb..9aa810b733a8 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -99,7 +99,7 @@ struct mvebu_pcie_port;
 struct mvebu_pcie {
 	struct platform_device *pdev;
 	struct mvebu_pcie_port *ports;
-	struct msi_chip *msi;
+	struct msi_controller *msi;
 	struct resource io;
 	char io_name[30];
 	struct resource realio;
@@ -774,12 +774,6 @@ static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	return bus;
 }
 
-static void mvebu_pcie_add_bus(struct pci_bus *bus)
-{
-	struct mvebu_pcie *pcie = sys_to_pcie(bus->sysdata);
-	bus->msi = pcie->msi;
-}
-
 static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
 						 const struct resource *res,
 						 resource_size_t start,
@@ -816,6 +810,10 @@ static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
 
 	memset(&hw, 0, sizeof(hw));
 
+#ifdef CONFIG_PCI_MSI
+	hw.msi_ctrl = pcie->msi;
+#endif
+
 	hw.nr_controllers = 1;
 	hw.private_data   = (void **)&pcie;
 	hw.setup          = mvebu_pcie_setup;
@@ -823,7 +821,6 @@ static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
 	hw.map_irq        = of_irq_parse_and_map_pci;
 	hw.ops            = &mvebu_pcie_ops;
 	hw.align_resource = mvebu_pcie_align_resource;
-	hw.add_bus        = mvebu_pcie_add_bus;
 
 	pci_common_init(&hw);
 }
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 3d43874319be..adee80bc09c6 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -238,7 +238,7 @@
 	)
 
 struct tegra_msi {
-	struct msi_chip chip;
+	struct msi_controller chip;
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	unsigned long pages;
@@ -259,7 +259,7 @@ struct tegra_pcie_soc_data {
 	bool has_gen2;
 };
 
-static inline struct tegra_msi *to_tegra_msi(struct msi_chip *chip)
+static inline struct tegra_msi *to_tegra_msi(struct msi_controller *chip)
 {
 	return container_of(chip, struct tegra_msi, chip);
 }
@@ -694,15 +694,6 @@ static int tegra_pcie_map_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void tegra_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct tegra_pcie *pcie = sys_to_pcie(bus->sysdata);
-
-		bus->msi = &pcie->msi.chip;
-	}
-}
-
 static struct pci_bus *tegra_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 {
 	struct tegra_pcie *pcie = sys_to_pcie(sys);
@@ -1283,8 +1274,8 @@ static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
 	return processed > 0 ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
-			       struct msi_desc *desc)
+static int tegra_msi_setup_irq(struct msi_controller *chip,
+			       struct pci_dev *pdev, struct msi_desc *desc)
 {
 	struct tegra_msi *msi = to_tegra_msi(chip);
 	struct msi_msg msg;
@@ -1308,12 +1299,13 @@ static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	msg.address_hi = 0;
 	msg.data = hwirq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
 
-static void tegra_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void tegra_msi_teardown_irq(struct msi_controller *chip,
+				   unsigned int irq)
 {
 	struct tegra_msi *msi = to_tegra_msi(chip);
 	struct irq_data *d = irq_get_irq_data(irq);
@@ -1325,10 +1317,10 @@ static void tegra_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
 
 static struct irq_chip tegra_msi_irq_chip = {
 	.name = "Tegra PCIe MSI",
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 static int tegra_msi_map(struct irq_domain *domain, unsigned int irq,
@@ -1881,11 +1873,14 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 
 	memset(&hw, 0, sizeof(hw));
 
+#ifdef CONFIG_PCI_MSI
+	hw.msi_ctrl = &pcie->msi.chip;
+#endif
+
 	hw.nr_controllers = 1;
 	hw.private_data = (void **)&pcie;
 	hw.setup = tegra_pcie_setup;
 	hw.map_irq = tegra_pcie_map_irq;
-	hw.add_bus = tegra_pcie_add_bus;
 	hw.scan = tegra_pcie_scan_bus;
 	hw.ops = &tegra_pcie_ops;
 
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index dfed00aa3ac0..17b51550f9b5 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -152,10 +152,10 @@ static int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
 
 static struct irq_chip dw_msi_irq_chip = {
 	.name = "PCI-MSI",
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 /* MSI int handler */
@@ -276,7 +276,7 @@ no_valid_irq:
 	return -ENOSPC;
 }
 
-static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+static int dw_msi_setup_irq(struct msi_controller *chip, struct pci_dev *pdev,
 			struct msi_desc *desc)
 {
 	int irq, pos;
@@ -298,12 +298,12 @@ static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	else
 		msg.data = pos;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
 
-static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void dw_msi_teardown_irq(struct msi_controller *chip, unsigned int irq)
 {
 	struct irq_data *data = irq_get_irq_data(irq);
 	struct msi_desc *msi = irq_data_get_msi(data);
@@ -312,7 +312,7 @@ static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
 	clear_irq_range(pp, irq, 1, data->hwirq);
 }
 
-static struct msi_chip dw_pcie_msi_chip = {
+static struct msi_controller dw_pcie_msi_chip = {
 	.setup_irq = dw_msi_setup_irq,
 	.teardown_irq = dw_msi_teardown_irq,
 };
@@ -498,6 +498,11 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	val |= PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
 
+#ifdef CONFIG_PCI_MSI
+	dw_pcie_msi_chip.dev = pp->dev;
+	dw_pci.msi_ctrl = &dw_pcie_msi_chip;
+#endif
+
 	dw_pci.nr_controllers = 1;
 	dw_pci.private_data = (void **)&pp;
 
@@ -747,21 +752,10 @@ static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void dw_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
-
-		dw_pcie_msi_chip.dev = pp->dev;
-		bus->msi = &dw_pcie_msi_chip;
-	}
-}
-
 static struct hw_pci dw_pci = {
 	.setup		= dw_pcie_setup,
 	.scan		= dw_pcie_scan_bus,
 	.map_irq	= dw_pcie_map_irq,
-	.add_bus	= dw_pcie_add_bus,
 };
 
 void dw_pcie_setup_rc(struct pcie_port *pp)
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index c6256751daff..d0bbd276840d 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -73,7 +73,7 @@ struct pcie_host_ops {
 	u32 (*get_msi_addr)(struct pcie_port *pp);
 	u32 (*get_msi_data)(struct pcie_port *pp, int pos);
 	void (*scan_bus)(struct pcie_port *pp);
-	int (*msi_host_init)(struct pcie_port *pp, struct msi_chip *chip);
+	int (*msi_host_init)(struct pcie_port *pp, struct msi_controller *chip);
 };
 
 int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
index 61158e03ab5f..d3053e53cf35 100644
--- a/drivers/pci/host/pcie-rcar.c
+++ b/drivers/pci/host/pcie-rcar.c
@@ -111,14 +111,14 @@
 struct rcar_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
-	struct msi_chip chip;
+	struct msi_controller chip;
 	unsigned long pages;
 	struct mutex lock;
 	int irq1;
 	int irq2;
 };
 
-static inline struct rcar_msi *to_rcar_msi(struct msi_chip *chip)
+static inline struct rcar_msi *to_rcar_msi(struct msi_controller *chip)
 {
 	return container_of(chip, struct rcar_msi, chip);
 }
@@ -380,20 +380,10 @@ static int rcar_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static void rcar_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct rcar_pcie *pcie = sys_to_pcie(bus->sysdata);
-
-		bus->msi = &pcie->msi.chip;
-	}
-}
-
 struct hw_pci rcar_pci = {
 	.setup          = rcar_pcie_setup,
 	.map_irq        = of_irq_parse_and_map_pci,
 	.ops            = &rcar_pcie_ops,
-	.add_bus        = rcar_pcie_add_bus,
 };
 
 static void rcar_pcie_enable(struct rcar_pcie *pcie)
@@ -402,6 +392,9 @@ static void rcar_pcie_enable(struct rcar_pcie *pcie)
 
 	rcar_pci.nr_controllers = 1;
 	rcar_pci.private_data = (void **)&pcie;
+#ifdef CONFIG_PCI_MSI
+	rcar_pci.msi_ctrl = &pcie->msi.chip;
+#endif
 
 	pci_common_init_dev(&pdev->dev, &rcar_pci);
 #ifdef CONFIG_PCI_DOMAINS
@@ -622,7 +615,7 @@ static irqreturn_t rcar_pcie_msi_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int rcar_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+static int rcar_msi_setup_irq(struct msi_controller *chip, struct pci_dev *pdev,
 			      struct msi_desc *desc)
 {
 	struct rcar_msi *msi = to_rcar_msi(chip);
@@ -647,12 +640,12 @@ static int rcar_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 	msg.address_hi = rcar_pci_read_reg(pcie, PCIEMSIAUR);
 	msg.data = hwirq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
 
-static void rcar_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void rcar_msi_teardown_irq(struct msi_controller *chip, unsigned int irq)
 {
 	struct rcar_msi *msi = to_rcar_msi(chip);
 	struct irq_data *d = irq_get_irq_data(irq);
@@ -662,10 +655,10 @@ static void rcar_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
 
 static struct irq_chip rcar_msi_irq_chip = {
 	.name = "R-Car PCIe MSI",
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 static int rcar_msi_map(struct irq_domain *domain, unsigned int irq,
diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index ccc496b33a97..2f50fa5953fd 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -335,7 +335,8 @@ static int xilinx_pcie_assign_msi(struct xilinx_pcie_port *port)
  * @chip: MSI Chip descriptor
  * @irq: MSI IRQ to destroy
  */
-static void xilinx_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+static void xilinx_msi_teardown_irq(struct msi_controller *chip,
+				    unsigned int irq)
 {
 	xilinx_pcie_destroy_msi(irq);
 }
@@ -348,7 +349,7 @@ static void xilinx_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
  *
  * Return: '0' on success and error value on failure
  */
-static int xilinx_pcie_msi_setup_irq(struct msi_chip *chip,
+static int xilinx_pcie_msi_setup_irq(struct msi_controller *chip,
 				     struct pci_dev *pdev,
 				     struct msi_desc *desc)
 {
@@ -374,13 +375,13 @@ static int xilinx_pcie_msi_setup_irq(struct msi_chip *chip,
 	msg.address_lo = msg_addr;
 	msg.data = irq;
 
-	write_msi_msg(irq, &msg);
+	pci_write_msi_msg(irq, &msg);
 
 	return 0;
 }
 
 /* MSI Chip Descriptor */
-static struct msi_chip xilinx_pcie_msi_chip = {
+static struct msi_controller xilinx_pcie_msi_chip = {
 	.setup_irq = xilinx_pcie_msi_setup_irq,
 	.teardown_irq = xilinx_msi_teardown_irq,
 };
@@ -388,10 +389,10 @@ static struct msi_chip xilinx_pcie_msi_chip = {
 /* HW Interrupt Chip Descriptor */
 static struct irq_chip xilinx_msi_irq_chip = {
 	.name = "Xilinx PCIe MSI",
-	.irq_enable = unmask_msi_irq,
-	.irq_disable = mask_msi_irq,
-	.irq_mask = mask_msi_irq,
-	.irq_unmask = unmask_msi_irq,
+	.irq_enable = pci_msi_unmask_irq,
+	.irq_disable = pci_msi_mask_irq,
+	.irq_mask = pci_msi_mask_irq,
+	.irq_unmask = pci_msi_unmask_irq,
 };
 
 /**
@@ -431,20 +432,6 @@ static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE2);
 }
 
-/**
- * xilinx_pcie_add_bus - Add MSI chip info to PCIe bus
- * @bus: PCIe bus
- */
-static void xilinx_pcie_add_bus(struct pci_bus *bus)
-{
-	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
-
-		xilinx_pcie_msi_chip.dev = port->dev;
-		bus->msi = &xilinx_pcie_msi_chip;
-	}
-}
-
 /* INTx Functions */
 
 /**
@@ -924,10 +911,14 @@ static int xilinx_pcie_probe(struct platform_device *pdev)
 		.private_data	= (void **)&port,
 		.setup		= xilinx_pcie_setup,
 		.map_irq	= of_irq_parse_and_map_pci,
-		.add_bus	= xilinx_pcie_add_bus,
 		.scan		= xilinx_pcie_scan_bus,
 		.ops		= &xilinx_pcie_ops,
 	};
+
+#ifdef CONFIG_PCI_MSI
+	xilinx_pcie_msi_chip.dev = port->dev;
+	hw.msi_ctrl = &xilinx_pcie_msi_chip;
+#endif
 	pci_common_init_dev(dev, &hw);
 
 	return 0;
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9fab30af0e75..476f4b1a2727 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -19,19 +19,82 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/irqdomain.h>
 
 #include "pci.h"
 
 static int pci_msi_enable = 1;
+int pci_msi_ignore_mask;
 
 #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
 
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+static struct irq_domain *pci_msi_default_domain;
+static DEFINE_MUTEX(pci_msi_domain_lock);
+
+struct irq_domain * __weak arch_get_pci_msi_domain(struct pci_dev *dev)
+{
+	return pci_msi_default_domain;
+}
+
+static struct irq_domain *pci_msi_get_domain(struct pci_dev *dev)
+{
+	struct irq_domain *domain = NULL;
+
+	if (dev->bus->msi)
+		domain = dev->bus->msi->domain;
+	if (!domain)
+		domain = arch_get_pci_msi_domain(dev);
+
+	return domain;
+}
+
+static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct irq_domain *domain;
+
+	domain = pci_msi_get_domain(dev);
+	if (domain)
+		return pci_msi_domain_alloc_irqs(domain, dev, nvec, type);
+
+	return arch_setup_msi_irqs(dev, nvec, type);
+}
+
+static void pci_msi_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct irq_domain *domain;
+
+	domain = pci_msi_get_domain(dev);
+	if (domain)
+		pci_msi_domain_free_irqs(domain, dev);
+	else
+		arch_teardown_msi_irqs(dev);
+}
+#else
+#define pci_msi_setup_msi_irqs		arch_setup_msi_irqs
+#define pci_msi_teardown_msi_irqs	arch_teardown_msi_irqs
+#endif
 
 /* Arch hooks */
 
+struct msi_controller * __weak pcibios_msi_controller(struct pci_dev *dev)
+{
+	return NULL;
+}
+
+static struct msi_controller *pci_msi_controller(struct pci_dev *dev)
+{
+	struct msi_controller *msi_ctrl = dev->bus->msi;
+
+	if (msi_ctrl)
+		return msi_ctrl;
+
+	return pcibios_msi_controller(dev);
+}
+
 int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	struct msi_chip *chip = dev->bus->msi;
+	struct msi_controller *chip = pci_msi_controller(dev);
 	int err;
 
 	if (!chip || !chip->setup_irq)
@@ -48,7 +111,7 @@ int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 
 void __weak arch_teardown_msi_irq(unsigned int irq)
 {
-	struct msi_chip *chip = irq_get_chip_data(irq);
+	struct msi_controller *chip = irq_get_chip_data(irq);
 
 	if (!chip || !chip->teardown_irq)
 		return;
@@ -85,19 +148,13 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
  */
 void default_teardown_msi_irqs(struct pci_dev *dev)
 {
+	int i;
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		int i, nvec;
-		if (entry->irq == 0)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			arch_teardown_msi_irq(entry->irq + i);
-	}
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				arch_teardown_msi_irq(entry->irq + i);
 }
 
 void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
@@ -120,7 +177,7 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 	}
 
 	if (entry)
-		__write_msi_msg(entry, &entry->msg);
+		__pci_write_msi_msg(entry, &entry->msg);
 }
 
 void __weak arch_restore_msi_irqs(struct pci_dev *dev)
@@ -163,11 +220,11 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 
-	if (!desc->msi_attrib.maskbit)
+	if (pci_msi_ignore_mask || !desc->msi_attrib.maskbit)
 		return 0;
 
 	mask_bits &= ~mask;
@@ -177,14 +234,9 @@ u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 	return mask_bits;
 }
 
-__weak u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
-{
-	return default_msi_mask_irq(desc, mask, flag);
-}
-
 static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	desc->masked = arch_msi_mask_irq(desc, mask, flag);
+	desc->masked = __pci_msi_desc_mask_irq(desc, mask, flag);
 }
 
 /*
@@ -194,11 +246,15 @@ static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
  * file.  This saves a few milliseconds when initialising devices with lots
  * of MSI-X interrupts.
  */
-u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
+u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 	unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
+
+	if (pci_msi_ignore_mask)
+		return 0;
+
 	mask_bits &= ~PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	if (flag)
 		mask_bits |= PCI_MSIX_ENTRY_CTRL_MASKBIT;
@@ -207,14 +263,9 @@ u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
 	return mask_bits;
 }
 
-__weak u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
-{
-	return default_msix_mask_irq(desc, flag);
-}
-
 static void msix_mask_irq(struct msi_desc *desc, u32 flag)
 {
-	desc->masked = arch_msix_mask_irq(desc, flag);
+	desc->masked = __pci_msix_desc_mask_irq(desc, flag);
 }
 
 static void msi_set_mask_bit(struct irq_data *data, u32 flag)
@@ -230,12 +281,20 @@ static void msi_set_mask_bit(struct irq_data *data, u32 flag)
 	}
 }
 
-void mask_msi_irq(struct irq_data *data)
+/**
+ * pci_msi_mask_irq - Generic irq chip callback to mask PCI/MSI interrupts
+ * @data:	pointer to irqdata associated to that interrupt
+ */
+void pci_msi_mask_irq(struct irq_data *data)
 {
 	msi_set_mask_bit(data, 1);
 }
 
-void unmask_msi_irq(struct irq_data *data)
+/**
+ * pci_msi_unmask_irq - Generic irq chip callback to unmask PCI/MSI interrupts
+ * @data:	pointer to irqdata associated to that interrupt
+ */
+void pci_msi_unmask_irq(struct irq_data *data)
 {
 	msi_set_mask_bit(data, 0);
 }
@@ -244,12 +303,11 @@ void default_restore_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		default_restore_msi_irq(dev, entry->irq);
-	}
 }
 
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
 
@@ -279,32 +337,7 @@ void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	}
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__read_msi_msg(entry, msg);
-}
-
-void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
-{
-	/* Assert that the cache is valid, assuming that
-	 * valid messages are not all-zeroes. */
-	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
-		 entry->msg.data));
-
-	*msg = entry->msg;
-}
-
-void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__get_cached_msi_msg(entry, msg);
-}
-EXPORT_SYMBOL_GPL(get_cached_msi_msg);
-
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
@@ -341,34 +374,27 @@ void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	entry->msg = *msg;
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
 
-	__write_msi_msg(entry, msg);
+	__pci_write_msi_msg(entry, msg);
 }
-EXPORT_SYMBOL_GPL(write_msi_msg);
+EXPORT_SYMBOL_GPL(pci_write_msi_msg);
 
 static void free_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry, *tmp;
 	struct attribute **msi_attrs;
 	struct device_attribute *dev_attr;
-	int count = 0;
+	int i, count = 0;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		int i, nvec;
-		if (!entry->irq)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			BUG_ON(irq_has_action(entry->irq + i));
-	}
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				BUG_ON(irq_has_action(entry->irq + i));
 
-	arch_teardown_msi_irqs(dev);
+	pci_msi_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.is_msix) {
@@ -451,9 +477,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
 
 	arch_restore_msi_irqs(dev);
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		msix_mask_irq(entry, entry->masked);
-	}
 
 	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
@@ -497,9 +522,8 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	int count = 0;
 
 	/* Determine how many msi entries we have */
-	list_for_each_entry(entry, &pdev->msi_list, list) {
+	list_for_each_entry(entry, &pdev->msi_list, list)
 		++num_msi;
-	}
 	if (!num_msi)
 		return 0;
 
@@ -559,7 +583,7 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
+static struct msi_desc *msi_setup_entry(struct pci_dev *dev, int nvec)
 {
 	u16 control;
 	struct msi_desc *entry;
@@ -577,6 +601,8 @@ static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
+	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
+	entry->nvec_used		= nvec;
 
 	if (control & PCI_MSI_FLAGS_64BIT)
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_64;
@@ -609,7 +635,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 
 	msi_set_enable(dev, 0);	/* Disable MSI during set up */
 
-	entry = msi_setup_entry(dev);
+	entry = msi_setup_entry(dev, nvec);
 	if (!entry)
 		return -ENOMEM;
 
@@ -620,7 +646,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -680,6 +706,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.entry_nr	= entries[i].entry;
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
+		entry->nvec_used		= 1;
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
@@ -698,7 +725,6 @@ static void msix_program_entries(struct pci_dev *dev,
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
 
 		entries[i].vector = entry->irq;
-		irq_set_msi_desc(entry->irq, entry);
 		entry->masked = readl(entry->mask_base + offset);
 		msix_mask_irq(entry, 1);
 		i++;
@@ -735,7 +761,7 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto out_avail;
 
@@ -869,7 +895,7 @@ void pci_msi_shutdown(struct pci_dev *dev)
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
 	/* Keep cached state to be restored */
-	arch_msi_mask_irq(desc, mask, ~mask);
+	__pci_msi_desc_mask_irq(desc, mask, ~mask);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
@@ -967,7 +993,7 @@ void pci_msix_shutdown(struct pci_dev *dev)
 	/* Return the device with MSI-X masked as initial states */
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		/* Keep cached states to be restored */
-		arch_msix_mask_irq(entry, 1);
+		__pci_msix_desc_mask_irq(entry, 1);
 	}
 
 	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
@@ -1112,3 +1138,197 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+/**
+ * pci_msi_domain_write_msg - Helper to write MSI message to PCI config space
+ * @irq_data:	Pointer to interrupt data of the MSI interrupt
+ * @msg:	Pointer to the message
+ */
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	/*
+	 * For MSI-X desc->irq is always equal to irq_data->irq. For
+	 * MSI only the first interrupt of MULTI MSI passes the test.
+	 */
+	if (desc->irq == irq_data->irq)
+		__pci_write_msi_msg(desc, msg);
+}
+
+/**
+ * pci_msi_domain_calc_hwirq - Generate a unique ID for an MSI source
+ * @dev:	Pointer to the PCI device
+ * @desc:	Pointer to the msi descriptor
+ *
+ * The ID number is only used within the irqdomain.
+ */
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc)
+{
+	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
+		PCI_DEVID(dev->bus->number, dev->devfn) << 11 |
+		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+}
+
+static inline bool pci_msi_desc_is_multi_msi(struct msi_desc *desc)
+{
+	return !desc->msi_attrib.is_msix && desc->nvec_used > 1;
+}
+
+/**
+ * pci_msi_domain_check_cap - Verify that @domain supports the capabilities for @dev
+ * @domain:	The interrupt domain to check
+ * @info:	The domain info for verification
+ * @dev:	The device to check
+ *
+ * Returns:
+ *  0 if the functionality is supported
+ *  1 if Multi MSI is requested, but the domain does not support it
+ *  -ENOTSUPP otherwise
+ */
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev)
+{
+	struct msi_desc *desc = first_pci_msi_entry(to_pci_dev(dev));
+
+	/* Special handling to support pci_enable_msi_range() */
+	if (pci_msi_desc_is_multi_msi(desc) &&
+	    !(info->flags & MSI_FLAG_MULTI_PCI_MSI))
+		return 1;
+	else if (desc->msi_attrib.is_msix && !(info->flags & MSI_FLAG_PCI_MSIX))
+		return -ENOTSUPP;
+
+	return 0;
+}
+
+static int pci_msi_domain_handle_error(struct irq_domain *domain,
+				       struct msi_desc *desc, int error)
+{
+	/* Special handling to support pci_enable_msi_range() */
+	if (pci_msi_desc_is_multi_msi(desc) && error == -ENOSPC)
+		return 1;
+
+	return error;
+}
+
+#ifdef GENERIC_MSI_DOMAIN_OPS
+static void pci_msi_domain_set_desc(msi_alloc_info_t *arg,
+				    struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = pci_msi_domain_calc_hwirq(msi_desc_to_pci_dev(desc),
+					       desc);
+}
+#else
+#define pci_msi_domain_set_desc		NULL
+#endif
+
+static struct msi_domain_ops pci_msi_domain_ops_default = {
+	.set_desc	= pci_msi_domain_set_desc,
+	.msi_check	= pci_msi_domain_check_cap,
+	.handle_error	= pci_msi_domain_handle_error,
+};
+
+static void pci_msi_domain_update_dom_ops(struct msi_domain_info *info)
+{
+	struct msi_domain_ops *ops = info->ops;
+
+	if (ops == NULL) {
+		info->ops = &pci_msi_domain_ops_default;
+	} else {
+		if (ops->set_desc == NULL)
+			ops->set_desc = pci_msi_domain_set_desc;
+		if (ops->msi_check == NULL)
+			ops->msi_check = pci_msi_domain_check_cap;
+		if (ops->handle_error == NULL)
+			ops->handle_error = pci_msi_domain_handle_error;
+	}
+}
+
+static void pci_msi_domain_update_chip_ops(struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	BUG_ON(!chip);
+	if (!chip->irq_write_msi_msg)
+		chip->irq_write_msi_msg = pci_msi_domain_write_msg;
+}
+
+/**
+ * pci_msi_create_irq_domain - Creat a MSI interrupt domain
+ * @node:	Optional device-tree node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ *
+ * Updates the domain and chip ops and creates a MSI interrupt domain.
+ *
+ * Returns:
+ * A domain pointer or NULL in case of failure.
+ */
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent)
+{
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		pci_msi_domain_update_dom_ops(info);
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		pci_msi_domain_update_chip_ops(info);
+
+	return msi_create_irq_domain(node, info, parent);
+}
+
+/**
+ * pci_msi_domain_alloc_irqs - Allocate interrupts for @dev in @domain
+ * @domain:	The interrupt domain to allocate from
+ * @dev:	The device for which to allocate
+ * @nvec:	The number of interrupts to allocate
+ * @type:	Unused to allow simpler migration from the arch_XXX interfaces
+ *
+ * Returns:
+ * A virtual interrupt number or an error code in case of failure
+ */
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type)
+{
+	return msi_domain_alloc_irqs(domain, &dev->dev, nvec);
+}
+
+/**
+ * pci_msi_domain_free_irqs - Free interrupts for @dev in @domain
+ * @domain:	The interrupt domain
+ * @dev:	The device for which to free interrupts
+ */
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
+{
+	msi_domain_free_irqs(domain, &dev->dev);
+}
+
+/**
+ * pci_msi_create_default_irq_domain - Create a default MSI interrupt domain
+ * @node:	Optional device-tree node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ *
+ * Returns: A domain pointer or NULL in case of failure. If successful
+ * the default PCI/MSI irqdomain pointer is updated.
+ */
+struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
+		struct msi_domain_info *info, struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	mutex_lock(&pci_msi_domain_lock);
+	if (pci_msi_default_domain) {
+		pr_err("PCI: default irq domain for PCI MSI has already been created.\n");
+		domain = NULL;
+	} else {
+		domain = pci_msi_create_irq_domain(node, info, parent);
+		pci_msi_default_domain = domain;
+	}
+	mutex_unlock(&pci_msi_domain_lock);
+
+	return domain;
+}
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 553212f037c3..e8d695b3f54e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -560,7 +560,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 		struct msi_msg msg;
 
 		get_cached_msi_msg(irq, &msg);
-		write_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
 	}
 
 	ret = request_irq(irq, vfio_msihandler, 0,
diff --git a/include/asm-generic/msi.h b/include/asm-generic/msi.h
new file mode 100644
index 000000000000..61c58d8878ce
--- /dev/null
+++ b/include/asm-generic/msi.h
@@ -0,0 +1,32 @@
+#ifndef __ASM_GENERIC_MSI_H
+#define __ASM_GENERIC_MSI_H
+
+#include <linux/types.h>
+
+#ifndef NUM_MSI_ALLOC_SCRATCHPAD_REGS
+# define NUM_MSI_ALLOC_SCRATCHPAD_REGS	2
+#endif
+
+struct msi_desc;
+
+/**
+ * struct msi_alloc_info - Default structure for MSI interrupt allocation.
+ * @desc:	Pointer to msi descriptor
+ * @hwirq:	Associated hw interrupt number in the domain
+ * @scratchpad:	Storage for implementation specific scratch data
+ *
+ * Architectures can provide their own implementation by not including
+ * asm-generic/msi.h into their arch specific header file.
+ */
+typedef struct msi_alloc_info {
+	struct msi_desc			*desc;
+	irq_hw_number_t			hwirq;
+	union {
+		unsigned long		ul;
+		void			*ptr;
+	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
+} msi_alloc_info_t;
+
+#define GENERIC_MSI_DOMAIN_OPS		1
+
+#endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 03f48d936f66..33da579d727c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/gfp.h>
+#include <linux/irqhandler.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
@@ -27,11 +28,7 @@
 
 struct seq_file;
 struct module;
-struct irq_desc;
-struct irq_data;
-typedef	void (*irq_flow_handler_t)(unsigned int irq,
-					    struct irq_desc *desc);
-typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
+struct msi_msg;
 
 /*
  * IRQ line status.
@@ -113,10 +110,14 @@ enum {
  *
  * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
+ *			  support stacked irqchips, which indicates skipping
+ *			  all descendent irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
 	IRQ_SET_MASK_OK_NOCOPY,
+	IRQ_SET_MASK_OK_DONE,
 };
 
 struct msi_desc;
@@ -133,6 +134,8 @@ struct irq_domain;
  * @chip:		low level interrupt hardware access
  * @domain:		Interrupt translation domain; responsible for mapping
  *			between hwirq number and linux irq number.
+ * @parent_data:	pointer to parent struct irq_data to support hierarchy
+ *			irq_domain
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
@@ -151,6 +154,9 @@ struct irq_data {
 	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
 	struct irq_domain	*domain;
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	struct irq_data		*parent_data;
+#endif
 	void			*handler_data;
 	void			*chip_data;
 	struct msi_desc		*msi_desc;
@@ -315,6 +321,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				any other callback related to this irq
  * @irq_release_resources:	optional to release resources acquired with
  *				irq_request_resources
+ * @irq_compose_msi_msg:	optional to compose message content for MSI
+ * @irq_write_msi_msg:	optional to write message content for MSI
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -351,6 +359,9 @@ struct irq_chip {
 	int		(*irq_request_resources)(struct irq_data *data);
 	void		(*irq_release_resources)(struct irq_data *data);
 
+	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+
 	unsigned long	flags;
 };
 
@@ -438,6 +449,18 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
+extern int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg);
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern void irq_chip_ack_parent(struct irq_data *data);
+extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
+extern void irq_chip_mask_parent(struct irq_data *data);
+extern void irq_chip_unmask_parent(struct irq_data *data);
+extern void irq_chip_eoi_parent(struct irq_data *data);
+extern int irq_chip_set_affinity_parent(struct irq_data *data,
+					const struct cpumask *dest,
+					bool force);
+#endif
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b0f9d16e48f6..676d7306a360 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -33,11 +33,14 @@
 #define _LINUX_IRQDOMAIN_H
 
 #include <linux/types.h>
+#include <linux/irqhandler.h>
 #include <linux/radix-tree.h>
 
 struct device_node;
 struct irq_domain;
 struct of_device_id;
+struct irq_chip;
+struct irq_data;
 
 /* Number of irqs reserved for a legacy isa controller */
 #define NUM_ISA_INTERRUPTS	16
@@ -64,6 +67,16 @@ struct irq_domain_ops {
 	int (*xlate)(struct irq_domain *d, struct device_node *node,
 		     const u32 *intspec, unsigned int intsize,
 		     unsigned long *out_hwirq, unsigned int *out_type);
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	/* extended V2 interfaces to support hierarchy irq_domains */
+	int (*alloc)(struct irq_domain *d, unsigned int virq,
+		     unsigned int nr_irqs, void *arg);
+	void (*free)(struct irq_domain *d, unsigned int virq,
+		     unsigned int nr_irqs);
+	void (*activate)(struct irq_domain *d, struct irq_data *irq_data);
+	void (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
+#endif
 };
 
 extern struct irq_domain_ops irq_generic_chip_ops;
@@ -77,6 +90,7 @@ struct irq_domain_chip_generic;
  * @ops: pointer to irq_domain methods
  * @host_data: private data pointer for use by owner.  Not touched by irq_domain
  *             core code.
+ * @flags: host per irq_domain flags
  *
  * Optional elements
  * @of_node: Pointer to device tree nodes associated with the irq_domain. Used
@@ -84,6 +98,7 @@ struct irq_domain_chip_generic;
  * @gc: Pointer to a list of generic chips. There is a helper function for
  *      setting up one or more generic chips for interrupt controllers
  *      drivers using the generic chip library which uses this pointer.
+ * @parent: Pointer to parent irq_domain to support hierarchy irq_domains
  *
  * Revmap data, used internally by irq_domain
  * @revmap_direct_max_irq: The largest hwirq that can be set for controllers that
@@ -97,10 +112,14 @@ struct irq_domain {
 	const char *name;
 	const struct irq_domain_ops *ops;
 	void *host_data;
+	unsigned int flags;
 
 	/* Optional data */
 	struct device_node *of_node;
 	struct irq_domain_chip_generic *gc;
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	struct irq_domain *parent;
+#endif
 
 	/* reverse map data. The linear map gets appended to the irq_domain */
 	irq_hw_number_t hwirq_max;
@@ -110,6 +129,22 @@ struct irq_domain {
 	unsigned int linear_revmap[];
 };
 
+/* Irq domain flags */
+enum {
+	/* Irq domain is hierarchical */
+	IRQ_DOMAIN_FLAG_HIERARCHY	= (1 << 0),
+
+	/* Core calls alloc/free recursive through the domain hierarchy. */
+	IRQ_DOMAIN_FLAG_AUTO_RECURSIVE	= (1 << 1),
+
+	/*
+	 * Flags starting from IRQ_DOMAIN_FLAG_NONCORE are reserved
+	 * for implementation specific purposes and ignored by the
+	 * core code.
+	 */
+	IRQ_DOMAIN_FLAG_NONCORE		= (1 << 16),
+};
+
 #ifdef CONFIG_IRQ_DOMAIN
 struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
@@ -220,8 +255,74 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 			const u32 *intspec, unsigned int intsize,
 			irq_hw_number_t *out_hwirq, unsigned int *out_type);
 
+/* V2 interfaces to support hierarchy IRQ domains. */
+extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
+						unsigned int virq);
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+			unsigned int flags, unsigned int size,
+			struct device_node *node,
+			const struct irq_domain_ops *ops, void *host_data);
+extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+				   unsigned int nr_irqs, int node, void *arg,
+				   bool realloc);
+extern void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs);
+extern void irq_domain_activate_irq(struct irq_data *irq_data);
+extern void irq_domain_deactivate_irq(struct irq_data *irq_data);
+
+static inline int irq_domain_alloc_irqs(struct irq_domain *domain,
+			unsigned int nr_irqs, int node, void *arg)
+{
+	return __irq_domain_alloc_irqs(domain, -1, nr_irqs, node, arg, false);
+}
+
+extern int irq_domain_set_hwirq_and_chip(struct irq_domain *domain,
+					 unsigned int virq,
+					 irq_hw_number_t hwirq,
+					 struct irq_chip *chip,
+					 void *chip_data);
+extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+				irq_hw_number_t hwirq, struct irq_chip *chip,
+				void *chip_data, irq_flow_handler_t handler,
+				void *handler_data, const char *handler_name);
+extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
+extern void irq_domain_free_irqs_common(struct irq_domain *domain,
+					unsigned int virq,
+					unsigned int nr_irqs);
+extern void irq_domain_free_irqs_top(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs);
+
+extern int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs, void *arg);
+
+extern void irq_domain_free_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs);
+
+static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
+{
+	return domain->flags & IRQ_DOMAIN_FLAG_HIERARCHY;
+}
+#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
+static inline void irq_domain_activate_irq(struct irq_data *data) { }
+static inline void irq_domain_deactivate_irq(struct irq_data *data) { }
+static inline int irq_domain_alloc_irqs(struct irq_domain *domain,
+			unsigned int nr_irqs, int node, void *arg)
+{
+	return -1;
+}
+
+static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
+{
+	return false;
+}
+#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
+
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
+static inline void irq_domain_activate_irq(struct irq_data *data) { }
+static inline void irq_domain_deactivate_irq(struct irq_data *data) { }
 #endif /* !CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/include/linux/irqhandler.h b/include/linux/irqhandler.h
new file mode 100644
index 000000000000..62d543004197
--- /dev/null
+++ b/include/linux/irqhandler.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_IRQHANDLER_H
+#define _LINUX_IRQHANDLER_H
+
+/*
+ * Interrupt flow handler typedefs are defined here to avoid circular
+ * include dependencies.
+ */
+
+struct irq_desc;
+struct irq_data;
+typedef	void (*irq_flow_handler_t)(unsigned int irq, struct irq_desc *desc);
+typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
+
+#endif
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 44f4746d033b..8ac4a68ffae2 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -10,17 +10,12 @@ struct msi_msg {
 	u32	data;		/* 16 bits of msi message data */
 };
 
+extern int pci_msi_ignore_mask;
 /* Helper functions */
 struct irq_data;
 struct msi_desc;
-void mask_msi_irq(struct irq_data *data);
-void unmask_msi_irq(struct irq_data *data);
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
-void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {
 	struct {
@@ -48,6 +43,52 @@ struct msi_desc {
 	struct msi_msg msg;
 };
 
+/* Helpers to hide struct msi_desc implementation details */
+#define msi_desc_to_dev(desc)		(&(desc)->dev.dev)
+#define dev_to_msi_list(dev)		(&to_pci_dev((dev))->msi_list)
+#define first_msi_entry(dev)		\
+	list_first_entry(dev_to_msi_list((dev)), struct msi_desc, list)
+#define for_each_msi_entry(desc, dev)	\
+	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
+
+#ifdef CONFIG_PCI_MSI
+#define first_pci_msi_entry(pdev)	first_msi_entry(&(pdev)->dev)
+#define for_each_pci_msi_entry(desc, pdev)	\
+	for_each_msi_entry((desc), &(pdev)->dev)
+
+static inline struct pci_dev *msi_desc_to_pci_dev(struct msi_desc *desc)
+{
+	return desc->dev;
+}
+#endif /* CONFIG_PCI_MSI */
+
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg);
+
+u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
+u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void pci_msi_mask_irq(struct irq_data *data);
+void pci_msi_unmask_irq(struct irq_data *data);
+
+/* Conversion helpers. Should be removed after merging */
+static inline void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	__pci_write_msi_msg(entry, msg);
+}
+static inline void write_msi_msg(int irq, struct msi_msg *msg)
+{
+	pci_write_msi_msg(irq, msg);
+}
+static inline void mask_msi_irq(struct irq_data *data)
+{
+	pci_msi_mask_irq(data);
+}
+static inline void unmask_msi_irq(struct irq_data *data)
+{
+	pci_msi_unmask_irq(data);
+}
+
 /*
  * The arch hooks to setup up msi irqs. Those functions are
  * implemented as weak symbols so that they /can/ be overriden by
@@ -61,18 +102,142 @@ void arch_restore_msi_irqs(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev);
-u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
-u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
-struct msi_chip {
+struct msi_controller {
 	struct module *owner;
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
+#endif
 
-	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
+	int (*setup_irq)(struct msi_controller *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
-	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
+	void (*teardown_irq)(struct msi_controller *chip, unsigned int irq);
+};
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+
+#include <linux/irqhandler.h>
+#include <asm/msi.h>
+
+struct irq_domain;
+struct irq_chip;
+struct device_node;
+struct msi_domain_info;
+
+/**
+ * struct msi_domain_ops - MSI interrupt domain callbacks
+ * @get_hwirq:		Retrieve the resulting hw irq number
+ * @msi_init:		Domain specific init function for MSI interrupts
+ * @msi_free:		Domain specific function to free a MSI interrupts
+ * @msi_check:		Callback for verification of the domain/info/dev data
+ * @msi_prepare:	Prepare the allocation of the interrupts in the domain
+ * @msi_finish:		Optional callbacl to finalize the allocation
+ * @set_desc:		Set the msi descriptor for an interrupt
+ * @handle_error:	Optional error handler if the allocation fails
+ *
+ * @get_hwirq, @msi_init and @msi_free are callbacks used by
+ * msi_create_irq_domain() and related interfaces
+ *
+ * @msi_check, @msi_prepare, @msi_finish, @set_desc and @handle_error
+ * are callbacks used by msi_irq_domain_alloc_irqs() and related
+ * interfaces which are based on msi_desc.
+ */
+struct msi_domain_ops {
+	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info,
+				     msi_alloc_info_t *arg);
+	int		(*msi_init)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq, irq_hw_number_t hwirq,
+				    msi_alloc_info_t *arg);
+	void		(*msi_free)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq);
+	int		(*msi_check)(struct irq_domain *domain,
+				     struct msi_domain_info *info,
+				     struct device *dev);
+	int		(*msi_prepare)(struct irq_domain *domain,
+				       struct device *dev, int nvec,
+				       msi_alloc_info_t *arg);
+	void		(*msi_finish)(msi_alloc_info_t *arg, int retval);
+	void		(*set_desc)(msi_alloc_info_t *arg,
+				    struct msi_desc *desc);
+	int		(*handle_error)(struct irq_domain *domain,
+					struct msi_desc *desc, int error);
+};
+
+/**
+ * struct msi_domain_info - MSI interrupt domain data
+ * @flags:		Flags to decribe features and capabilities
+ * @ops:		The callback data structure
+ * @chip:		Optional: associated interrupt chip
+ * @chip_data:		Optional: associated interrupt chip data
+ * @handler:		Optional: associated interrupt flow handler
+ * @handler_data:	Optional: associated interrupt flow handler data
+ * @handler_name:	Optional: associated interrupt flow handler name
+ * @data:		Optional: domain specific data
+ */
+struct msi_domain_info {
+	u32			flags;
+	struct msi_domain_ops	*ops;
+	struct irq_chip		*chip;
+	void			*chip_data;
+	irq_flow_handler_t	handler;
+	void			*handler_data;
+	const char		*handler_name;
+	void			*data;
+};
+
+/* Flags for msi_domain_info */
+enum {
+	/*
+	 * Init non implemented ops callbacks with default MSI domain
+	 * callbacks.
+	 */
+	MSI_FLAG_USE_DEF_DOM_OPS	= (1 << 0),
+	/*
+	 * Init non implemented chip callbacks with default MSI chip
+	 * callbacks.
+	 */
+	MSI_FLAG_USE_DEF_CHIP_OPS	= (1 << 1),
+	/* Build identity map between hwirq and irq */
+	MSI_FLAG_IDENTITY_MAP		= (1 << 2),
+	/* Support multiple PCI MSI interrupts */
+	MSI_FLAG_MULTI_PCI_MSI		= (1 << 3),
+	/* Support PCI MSIX interrupts */
+	MSI_FLAG_PCI_MSIX		= (1 << 4),
 };
 
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent);
+int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
+			  int nvec);
+void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
+
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent);
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type);
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev);
+struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
+		 struct msi_domain_info *info, struct irq_domain *parent);
+
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc);
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev);
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
+
 #endif /* LINUX_MSI_H */
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 1fd207e7a847..ce0e5abeb454 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -59,13 +59,13 @@ int of_pci_get_host_bridge_resources(struct device_node *dev,
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
-int of_pci_msi_chip_add(struct msi_chip *chip);
-void of_pci_msi_chip_remove(struct msi_chip *chip);
-struct msi_chip *of_pci_find_msi_chip_by_node(struct device_node *of_node);
+int of_pci_msi_chip_add(struct msi_controller *chip);
+void of_pci_msi_chip_remove(struct msi_controller *chip);
+struct msi_controller *of_pci_find_msi_chip_by_node(struct device_node *of_node);
 #else
-static inline int of_pci_msi_chip_add(struct msi_chip *chip) { return -EINVAL; }
-static inline void of_pci_msi_chip_remove(struct msi_chip *chip) { }
-static inline struct msi_chip *
+static inline int of_pci_msi_chip_add(struct msi_controller *chip) { return -EINVAL; }
+static inline void of_pci_msi_chip_remove(struct msi_controller *chip) { }
+static inline struct msi_controller *
 of_pci_find_msi_chip_by_node(struct device_node *of_node) { return NULL; }
 #endif
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5be8db45e368..90a5fdec6b9f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -449,7 +449,7 @@ struct pci_bus {
 	struct resource busn_res;	/* bus numbers routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
-	struct msi_chip	*msi;		/* MSI controller */
+	struct msi_controller *msi;	/* MSI controller */
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
 
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 225086b2652e..9a76e3beda54 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -55,6 +55,21 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+# Support for hierarchical irq domains
+config IRQ_DOMAIN_HIERARCHY
+	bool
+	select IRQ_DOMAIN
+
+# Generic MSI interrupt support
+config GENERIC_MSI_IRQ
+	bool
+
+# Generic MSI hierarchical interrupt domain support
+config GENERIC_MSI_IRQ_DOMAIN
+	bool
+	select IRQ_DOMAIN_HIERARCHY
+	select GENERIC_MSI_IRQ
+
 config HANDLE_DOMAIN_IRQ
 	bool
 
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff17381f0af..d12123526e2b 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index e5202f00cabc..6f1c7a566b95 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/irqdomain.h>
 
 #include <trace/events/irq.h>
 
@@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
 	irq_state_clr_disabled(desc);
 	desc->depth = 0;
 
+	irq_domain_activate_irq(&desc->irq_data);
 	if (desc->irq_data.chip->irq_startup) {
 		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
 		irq_state_clr_masked(desc);
@@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	irq_domain_deactivate_irq(&desc->irq_data);
 	irq_state_set_masked(desc);
 }
 
@@ -728,7 +731,30 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	if (!handle) {
 		handle = handle_bad_irq;
 	} else {
-		if (WARN_ON(desc->irq_data.chip == &no_irq_chip))
+		struct irq_data *irq_data = &desc->irq_data;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		/*
+		 * With hierarchical domains we might run into a
+		 * situation where the outermost chip is not yet set
+		 * up, but the inner chips are there.  Instead of
+		 * bailing we install the handler, but obviously we
+		 * cannot enable/startup the interrupt at this point.
+		 */
+		while (irq_data) {
+			if (irq_data->chip != &no_irq_chip)
+				break;
+			/*
+			 * Bail out if the outer chip is not set up
+			 * and the interrrupt supposed to be started
+			 * right away.
+			 */
+			if (WARN_ON(is_chained))
+				goto out;
+			/* Try the parent */
+			irq_data = irq_data->parent_data;
+		}
+#endif
+		if (WARN_ON(!irq_data || irq_data->chip == &no_irq_chip))
 			goto out;
 	}
 
@@ -847,3 +873,105 @@ void irq_cpu_offline(void)
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+/**
+ * irq_chip_ack_parent - Acknowledge the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_ack_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_ack(data);
+}
+
+/**
+ * irq_chip_mask_parent - Mask the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_mask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_mask(data);
+}
+
+/**
+ * irq_chip_unmask_parent - Unmask the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_unmask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_unmask(data);
+}
+
+/**
+ * irq_chip_eoi_parent - Invoke EOI on the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ */
+void irq_chip_eoi_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_eoi(data);
+}
+
+/**
+ * irq_chip_set_affinity_parent - Set affinity on the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ * @dest:	The affinity mask to set
+ * @force:	Flag to enforce setting (disable online checks)
+ *
+ * Conditinal, as the underlying parent chip might not implement it.
+ */
+int irq_chip_set_affinity_parent(struct irq_data *data,
+				 const struct cpumask *dest, bool force)
+{
+	data = data->parent_data;
+	if (data->chip->irq_set_affinity)
+		return data->chip->irq_set_affinity(data, dest, force);
+
+	return -ENOSYS;
+}
+
+/**
+ * irq_chip_retrigger_hierarchy - Retrigger an interrupt in hardware
+ * @data:	Pointer to interrupt specific data
+ *
+ * Iterate through the domain hierarchy of the interrupt and check
+ * whether a hw retrigger function exists. If yes, invoke it.
+ */
+int irq_chip_retrigger_hierarchy(struct irq_data *data)
+{
+	for (data = data->parent_data; data; data = data->parent_data)
+		if (data->chip && data->chip->irq_retrigger)
+			return data->chip->irq_retrigger(data);
+
+	return -ENOSYS;
+}
+#endif
+
+/**
+ * irq_chip_compose_msi_msg - Componse msi message for a irq chip
+ * @data:	Pointer to interrupt specific data
+ * @msg:	Pointer to the MSI message
+ *
+ * For hierarchical domains we find the first chip in the hierarchy
+ * which implements the irq_compose_msi_msg callback. For non
+ * hierarchical we use the top level chip.
+ */
+int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct irq_data *pos = NULL;
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	for (; data; data = data->parent_data)
+#endif
+		if (data->chip && data->chip->irq_compose_msi_msg)
+			pos = data;
+	if (!pos)
+		return -ENOSYS;
+
+	pos->chip->irq_compose_msi_msg(pos, msg);
+
+	return 0;
+}
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6534ff6ce02e..7fac311057b8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -23,6 +23,10 @@ static DEFINE_MUTEX(irq_domain_mutex);
 static DEFINE_MUTEX(revmap_trees_mutex);
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
+				  irq_hw_number_t hwirq, int node);
+static void irq_domain_check_hierarchy(struct irq_domain *domain);
+
 /**
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
@@ -30,7 +34,7 @@ static struct irq_domain *irq_default_domain;
  * @hwirq_max: Maximum number of interrupts supported by controller
  * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
  *              direct mapping
- * @ops: map/unmap domain callbacks
+ * @ops: domain callbacks
  * @host_data: Controller private data pointer
  *
  * Allocates and initialize and irq_domain structure.
@@ -56,6 +60,7 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 	domain->hwirq_max = hwirq_max;
 	domain->revmap_size = size;
 	domain->revmap_direct_max_irq = direct_max;
+	irq_domain_check_hierarchy(domain);
 
 	mutex_lock(&irq_domain_mutex);
 	list_add(&domain->link, &irq_domain_list);
@@ -109,7 +114,7 @@ EXPORT_SYMBOL_GPL(irq_domain_remove);
  * @first_irq: first number of irq block assigned to the domain,
  *	pass zero to assign irqs on-the-fly. If first_irq is non-zero, then
  *	pre-map all of the irqs in the domain to virqs starting at first_irq.
- * @ops: map/unmap domain callbacks
+ * @ops: domain callbacks
  * @host_data: Controller private data pointer
  *
  * Allocates an irq_domain, and optionally if first_irq is positive then also
@@ -174,10 +179,8 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 
 	domain = __irq_domain_add(of_node, first_hwirq + size,
 				  first_hwirq + size, 0, ops, host_data);
-	if (!domain)
-		return NULL;
-
-	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
+	if (domain)
+		irq_domain_associate_many(domain, first_irq, first_hwirq, size);
 
 	return domain;
 }
@@ -388,7 +391,6 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
-	unsigned int hint;
 	int virq;
 
 	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
@@ -410,12 +412,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	hint = hwirq % nr_irqs;
-	if (hint == 0)
-		hint++;
-	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
-	if (virq <= 0)
-		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
+	virq = irq_domain_alloc_descs(-1, 1, hwirq,
+				      of_node_to_nid(domain->of_node));
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
@@ -471,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
-	unsigned int virq;
+	int virq;
 
 	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
 	if (!domain) {
@@ -489,10 +487,24 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 			return 0;
 	}
 
-	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
-	if (!virq)
-		return virq;
+	if (irq_domain_is_hierarchy(domain)) {
+		/*
+		 * If we've already configured this interrupt,
+		 * don't do it again, or hell will break loose.
+		 */
+		virq = irq_find_mapping(domain, hwirq);
+		if (virq)
+			return virq;
+
+		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
+		if (virq <= 0)
+			return 0;
+	} else {
+		/* Create mapping */
+		virq = irq_create_mapping(domain, hwirq);
+		if (!virq)
+			return virq;
+	}
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
@@ -540,8 +552,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return 0;
 
 	if (hwirq < domain->revmap_direct_max_irq) {
-		data = irq_get_irq_data(hwirq);
-		if (data && (data->domain == domain) && (data->hwirq == hwirq))
+		data = irq_domain_get_irq_data(domain, hwirq);
+		if (data && data->hwirq == hwirq)
 			return hwirq;
 	}
 
@@ -709,3 +721,518 @@ const struct irq_domain_ops irq_domain_simple_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
+
+static int irq_domain_alloc_descs(int virq, unsigned int cnt,
+				  irq_hw_number_t hwirq, int node)
+{
+	unsigned int hint;
+
+	if (virq >= 0) {
+		virq = irq_alloc_descs(virq, virq, cnt, node);
+	} else {
+		hint = hwirq % nr_irqs;
+		if (hint == 0)
+			hint++;
+		virq = irq_alloc_descs_from(hint, cnt, node);
+		if (virq <= 0 && hint > 1)
+			virq = irq_alloc_descs_from(1, cnt, node);
+	}
+
+	return virq;
+}
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+/**
+ * irq_domain_add_hierarchy - Add a irqdomain into the hierarchy
+ * @parent:	Parent irq domain to associate with the new domain
+ * @flags:	Irq domain flags associated to the domain
+ * @size:	Size of the domain. See below
+ * @node:	Optional device-tree node of the interrupt controller
+ * @ops:	Pointer to the interrupt domain callbacks
+ * @host_data:	Controller private data pointer
+ *
+ * If @size is 0 a tree domain is created, otherwise a linear domain.
+ *
+ * If successful the parent is associated to the new domain and the
+ * domain flags are set.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+					    unsigned int flags,
+					    unsigned int size,
+					    struct device_node *node,
+					    const struct irq_domain_ops *ops,
+					    void *host_data)
+{
+	struct irq_domain *domain;
+
+	if (size)
+		domain = irq_domain_add_linear(node, size, ops, host_data);
+	else
+		domain = irq_domain_add_tree(node, ops, host_data);
+	if (domain) {
+		domain->parent = parent;
+		domain->flags |= flags;
+	}
+
+	return domain;
+}
+
+static void irq_domain_insert_irq(int virq)
+{
+	struct irq_data *data;
+
+	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
+		struct irq_domain *domain = data->domain;
+		irq_hw_number_t hwirq = data->hwirq;
+
+		if (hwirq < domain->revmap_size) {
+			domain->linear_revmap[hwirq] = virq;
+		} else {
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_insert(&domain->revmap_tree, hwirq, data);
+			mutex_unlock(&revmap_trees_mutex);
+		}
+
+		/* If not already assigned, give the domain the chip's name */
+		if (!domain->name && data->chip)
+			domain->name = data->chip->name;
+	}
+
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+}
+
+static void irq_domain_remove_irq(int virq)
+{
+	struct irq_data *data;
+
+	irq_set_status_flags(virq, IRQ_NOREQUEST);
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	synchronize_irq(virq);
+	smp_mb();
+
+	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
+		struct irq_domain *domain = data->domain;
+		irq_hw_number_t hwirq = data->hwirq;
+
+		if (hwirq < domain->revmap_size) {
+			domain->linear_revmap[hwirq] = 0;
+		} else {
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_delete(&domain->revmap_tree, hwirq);
+			mutex_unlock(&revmap_trees_mutex);
+		}
+	}
+}
+
+static struct irq_data *irq_domain_insert_irq_data(struct irq_domain *domain,
+						   struct irq_data *child)
+{
+	struct irq_data *irq_data;
+
+	irq_data = kzalloc_node(sizeof(*irq_data), GFP_KERNEL, child->node);
+	if (irq_data) {
+		child->parent_data = irq_data;
+		irq_data->irq = child->irq;
+		irq_data->node = child->node;
+		irq_data->domain = domain;
+	}
+
+	return irq_data;
+}
+
+static void irq_domain_free_irq_data(unsigned int virq, unsigned int nr_irqs)
+{
+	struct irq_data *irq_data, *tmp;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_get_irq_data(virq + i);
+		tmp = irq_data->parent_data;
+		irq_data->parent_data = NULL;
+		irq_data->domain = NULL;
+
+		while (tmp) {
+			irq_data = tmp;
+			tmp = tmp->parent_data;
+			kfree(irq_data);
+		}
+	}
+}
+
+static int irq_domain_alloc_irq_data(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs)
+{
+	struct irq_data *irq_data;
+	struct irq_domain *parent;
+	int i;
+
+	/* The outermost irq_data is embedded in struct irq_desc */
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_get_irq_data(virq + i);
+		irq_data->domain = domain;
+
+		for (parent = domain->parent; parent; parent = parent->parent) {
+			irq_data = irq_domain_insert_irq_data(parent, irq_data);
+			if (!irq_data) {
+				irq_domain_free_irq_data(virq, i + 1);
+				return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * irq_domain_get_irq_data - Get irq_data associated with @virq and @domain
+ * @domain:	domain to match
+ * @virq:	IRQ number to get irq_data
+ */
+struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
+					 unsigned int virq)
+{
+	struct irq_data *irq_data;
+
+	for (irq_data = irq_get_irq_data(virq); irq_data;
+	     irq_data = irq_data->parent_data)
+		if (irq_data->domain == domain)
+			return irq_data;
+
+	return NULL;
+}
+
+/**
+ * irq_domain_set_hwirq_and_chip - Set hwirq and irqchip of @virq at @domain
+ * @domain:	Interrupt domain to match
+ * @virq:	IRQ number
+ * @hwirq:	The hwirq number
+ * @chip:	The associated interrupt chip
+ * @chip_data:	The associated chip data
+ */
+int irq_domain_set_hwirq_and_chip(struct irq_domain *domain, unsigned int virq,
+				  irq_hw_number_t hwirq, struct irq_chip *chip,
+				  void *chip_data)
+{
+	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
+
+	if (!irq_data)
+		return -ENOENT;
+
+	irq_data->hwirq = hwirq;
+	irq_data->chip = chip ? chip : &no_irq_chip;
+	irq_data->chip_data = chip_data;
+
+	return 0;
+}
+
+/**
+ * irq_domain_set_info - Set the complete data for a @virq in @domain
+ * @domain:		Interrupt domain to match
+ * @virq:		IRQ number
+ * @hwirq:		The hardware interrupt number
+ * @chip:		The associated interrupt chip
+ * @chip_data:		The associated interrupt chip data
+ * @handler:		The interrupt flow handler
+ * @handler_data:	The interrupt flow handler data
+ * @handler_name:	The interrupt handler name
+ */
+void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq, struct irq_chip *chip,
+			 void *chip_data, irq_flow_handler_t handler,
+			 void *handler_data, const char *handler_name)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
+	__irq_set_handler(virq, handler, 0, handler_name);
+	irq_set_handler_data(virq, handler_data);
+}
+
+/**
+ * irq_domain_reset_irq_data - Clear hwirq, chip and chip_data in @irq_data
+ * @irq_data:	The pointer to irq_data
+ */
+void irq_domain_reset_irq_data(struct irq_data *irq_data)
+{
+	irq_data->hwirq = 0;
+	irq_data->chip = &no_irq_chip;
+	irq_data->chip_data = NULL;
+}
+
+/**
+ * irq_domain_free_irqs_common - Clear irq_data and free the parent
+ * @domain:	Interrupt domain to match
+ * @virq:	IRQ number to start with
+ * @nr_irqs:	The number of irqs to free
+ */
+void irq_domain_free_irqs_common(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs)
+{
+	struct irq_data *irq_data;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_domain_get_irq_data(domain, virq + i);
+		if (irq_data)
+			irq_domain_reset_irq_data(irq_data);
+	}
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+/**
+ * irq_domain_free_irqs_top - Clear handler and handler data, clear irqdata and free parent
+ * @domain:	Interrupt domain to match
+ * @virq:	IRQ number to start with
+ * @nr_irqs:	The number of irqs to free
+ */
+void irq_domain_free_irqs_top(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs)
+{
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_set_handler_data(virq + i, NULL);
+		irq_set_handler(virq + i, NULL);
+	}
+	irq_domain_free_irqs_common(domain, virq, nr_irqs);
+}
+
+static bool irq_domain_is_auto_recursive(struct irq_domain *domain)
+{
+	return domain->flags & IRQ_DOMAIN_FLAG_AUTO_RECURSIVE;
+}
+
+static void irq_domain_free_irqs_recursive(struct irq_domain *domain,
+					   unsigned int irq_base,
+					   unsigned int nr_irqs)
+{
+	domain->ops->free(domain, irq_base, nr_irqs);
+	if (irq_domain_is_auto_recursive(domain)) {
+		BUG_ON(!domain->parent);
+		irq_domain_free_irqs_recursive(domain->parent, irq_base,
+					       nr_irqs);
+	}
+}
+
+static int irq_domain_alloc_irqs_recursive(struct irq_domain *domain,
+					   unsigned int irq_base,
+					   unsigned int nr_irqs, void *arg)
+{
+	int ret = 0;
+	struct irq_domain *parent = domain->parent;
+	bool recursive = irq_domain_is_auto_recursive(domain);
+
+	BUG_ON(recursive && !parent);
+	if (recursive)
+		ret = irq_domain_alloc_irqs_recursive(parent, irq_base,
+						      nr_irqs, arg);
+	if (ret >= 0)
+		ret = domain->ops->alloc(domain, irq_base, nr_irqs, arg);
+	if (ret < 0 && recursive)
+		irq_domain_free_irqs_recursive(parent, irq_base, nr_irqs);
+
+	return ret;
+}
+
+/**
+ * __irq_domain_alloc_irqs - Allocate IRQs from domain
+ * @domain:	domain to allocate from
+ * @irq_base:	allocate specified IRQ nubmer if irq_base >= 0
+ * @nr_irqs:	number of IRQs to allocate
+ * @node:	NUMA node id for memory allocation
+ * @arg:	domain specific argument
+ * @realloc:	IRQ descriptors have already been allocated if true
+ *
+ * Allocate IRQ numbers and initialized all data structures to support
+ * hierarchy IRQ domains.
+ * Parameter @realloc is mainly to support legacy IRQs.
+ * Returns error code or allocated IRQ number
+ *
+ * The whole process to setup an IRQ has been split into two steps.
+ * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
+ * descriptor and required hardware resources. The second step,
+ * irq_domain_activate_irq(), is to program hardwares with preallocated
+ * resources. In this way, it's easier to rollback when failing to
+ * allocate resources.
+ */
+int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+			    unsigned int nr_irqs, int node, void *arg,
+			    bool realloc)
+{
+	int i, ret, virq;
+
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
+			return -EINVAL;
+	}
+
+	if (!domain->ops->alloc) {
+		pr_debug("domain->ops->alloc() is NULL\n");
+		return -ENOSYS;
+	}
+
+	if (realloc && irq_base >= 0) {
+		virq = irq_base;
+	} else {
+		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node);
+		if (virq < 0) {
+			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
+				 irq_base, nr_irqs);
+			return virq;
+		}
+	}
+
+	if (irq_domain_alloc_irq_data(domain, virq, nr_irqs)) {
+		pr_debug("cannot allocate memory for IRQ%d\n", virq);
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_alloc_irqs_recursive(domain, virq, nr_irqs, arg);
+	if (ret < 0) {
+		mutex_unlock(&irq_domain_mutex);
+		goto out_free_irq_data;
+	}
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_insert_irq(virq + i);
+	mutex_unlock(&irq_domain_mutex);
+
+	return virq;
+
+out_free_irq_data:
+	irq_domain_free_irq_data(virq, nr_irqs);
+out_free_desc:
+	irq_free_descs(virq, nr_irqs);
+	return ret;
+}
+
+/**
+ * irq_domain_free_irqs - Free IRQ number and associated data structures
+ * @virq:	base IRQ number
+ * @nr_irqs:	number of IRQs to free
+ */
+void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
+{
+	struct irq_data *data = irq_get_irq_data(virq);
+	int i;
+
+	if (WARN(!data || !data->domain || !data->domain->ops->free,
+		 "NULL pointer, cannot free irq\n"))
+		return;
+
+	mutex_lock(&irq_domain_mutex);
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_remove_irq(virq + i);
+	irq_domain_free_irqs_recursive(data->domain, virq, nr_irqs);
+	mutex_unlock(&irq_domain_mutex);
+
+	irq_domain_free_irq_data(virq, nr_irqs);
+	irq_free_descs(virq, nr_irqs);
+}
+
+/**
+ * irq_domain_alloc_irqs_parent - Allocate interrupts from parent domain
+ * @irq_base:	Base IRQ number
+ * @nr_irqs:	Number of IRQs to allocate
+ * @arg:	Allocation data (arch/domain specific)
+ *
+ * Check whether the domain has been setup recursive. If not allocate
+ * through the parent domain.
+ */
+int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+				 unsigned int irq_base, unsigned int nr_irqs,
+				 void *arg)
+{
+	/* irq_domain_alloc_irqs_recursive() has called parent's alloc() */
+	if (irq_domain_is_auto_recursive(domain))
+		return 0;
+
+	domain = domain->parent;
+	if (domain)
+		return irq_domain_alloc_irqs_recursive(domain, irq_base,
+						       nr_irqs, arg);
+	return -ENOSYS;
+}
+
+/**
+ * irq_domain_free_irqs_parent - Free interrupts from parent domain
+ * @irq_base:	Base IRQ number
+ * @nr_irqs:	Number of IRQs to free
+ *
+ * Check whether the domain has been setup recursive. If not free
+ * through the parent domain.
+ */
+void irq_domain_free_irqs_parent(struct irq_domain *domain,
+				 unsigned int irq_base, unsigned int nr_irqs)
+{
+	/* irq_domain_free_irqs_recursive() will call parent's free */
+	if (!irq_domain_is_auto_recursive(domain) && domain->parent)
+		irq_domain_free_irqs_recursive(domain->parent, irq_base,
+					       nr_irqs);
+}
+
+/**
+ * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
+ *			     interrupt
+ * @irq_data:	outermost irq_data associated with interrupt
+ *
+ * This is the second step to call domain_ops->activate to program interrupt
+ * controllers, so the interrupt could actually get delivered.
+ */
+void irq_domain_activate_irq(struct irq_data *irq_data)
+{
+	if (irq_data && irq_data->domain) {
+		struct irq_domain *domain = irq_data->domain;
+
+		if (irq_data->parent_data)
+			irq_domain_activate_irq(irq_data->parent_data);
+		if (domain->ops->activate)
+			domain->ops->activate(domain, irq_data);
+	}
+}
+
+/**
+ * irq_domain_deactivate_irq - Call domain_ops->deactivate recursively to
+ *			       deactivate interrupt
+ * @irq_data: outermost irq_data associated with interrupt
+ *
+ * It calls domain_ops->deactivate to program interrupt controllers to disable
+ * interrupt delivery.
+ */
+void irq_domain_deactivate_irq(struct irq_data *irq_data)
+{
+	if (irq_data && irq_data->domain) {
+		struct irq_domain *domain = irq_data->domain;
+
+		if (domain->ops->deactivate)
+			domain->ops->deactivate(domain, irq_data);
+		if (irq_data->parent_data)
+			irq_domain_deactivate_irq(irq_data->parent_data);
+	}
+}
+
+static void irq_domain_check_hierarchy(struct irq_domain *domain)
+{
+	/* Hierarchy irq_domains must implement callback alloc() */
+	if (domain->ops->alloc)
+		domain->flags |= IRQ_DOMAIN_FLAG_HIERARCHY;
+}
+#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
+/**
+ * irq_domain_get_irq_data - Get irq_data associated with @virq and @domain
+ * @domain:	domain to match
+ * @virq:	IRQ number to get irq_data
+ */
+struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
+					 unsigned int virq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+
+	return (irq_data && irq_data->domain == domain) ? irq_data : NULL;
+}
+
+static void irq_domain_check_hierarchy(struct irq_domain *domain)
+{
+}
+#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..80692373abd6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -183,6 +183,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		cpumask_copy(data->affinity, mask);
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_set_thread_affinity(desc);
@@ -600,6 +601,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
 		irqd_set(&desc->irq_data, flags);
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
new file mode 100644
index 000000000000..3e18163f336f
--- /dev/null
+++ b/kernel/irq/msi.c
@@ -0,0 +1,330 @@
+/*
+ * linux/kernel/irq/msi.c
+ *
+ * Copyright (C) 2014 Intel Corp.
+ * Author: Jiang Liu <jiang.liu@linux.intel.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This file contains common code to support Message Signalled Interrupt for
+ * PCI compatible and non PCI compatible devices.
+ */
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+
+/* Temparory solution for building, will be removed later */
+#include <linux/pci.h>
+
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	*msg = entry->msg;
+}
+
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__get_cached_msi_msg(entry, msg);
+}
+EXPORT_SYMBOL_GPL(get_cached_msi_msg);
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+static inline void irq_chip_write_msi_msg(struct irq_data *data,
+					  struct msi_msg *msg)
+{
+	data->chip->irq_write_msi_msg(data, msg);
+}
+
+/**
+ * msi_domain_set_affinity - Generic affinity setter function for MSI domains
+ * @irq_data:	The irq data associated to the interrupt
+ * @mask:	The affinity mask to set
+ * @force:	Flag to enforce setting (disable online checks)
+ *
+ * Intended to be used by MSI interrupt controllers which are
+ * implemented with hierarchical domains.
+ */
+int msi_domain_set_affinity(struct irq_data *irq_data,
+			    const struct cpumask *mask, bool force)
+{
+	struct irq_data *parent = irq_data->parent_data;
+	struct msi_msg msg;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		irq_chip_write_msi_msg(irq_data, &msg);
+	}
+
+	return ret;
+}
+
+static void msi_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+
+static void msi_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+
+static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
+	irq_hw_number_t hwirq = ops->get_hwirq(info, arg);
+	int i, ret;
+
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
+		if (ret < 0) {
+			if (ops->msi_free) {
+				for (i--; i > 0; i--)
+					ops->msi_free(domain, info, virq + i);
+			}
+			irq_domain_free_irqs_top(domain, virq, nr_irqs);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	struct msi_domain_info *info = domain->host_data;
+	int i;
+
+	if (info->ops->msi_free) {
+		for (i = 0; i < nr_irqs; i++)
+			info->ops->msi_free(domain, info, virq + i);
+	}
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+static struct irq_domain_ops msi_domain_ops = {
+	.alloc		= msi_domain_alloc,
+	.free		= msi_domain_free,
+	.activate	= msi_domain_activate,
+	.deactivate	= msi_domain_deactivate,
+};
+
+#ifdef GENERIC_MSI_DOMAIN_OPS
+static irq_hw_number_t msi_domain_ops_get_hwirq(struct msi_domain_info *info,
+						msi_alloc_info_t *arg)
+{
+	return arg->hwirq;
+}
+
+static int msi_domain_ops_prepare(struct irq_domain *domain, struct device *dev,
+				  int nvec, msi_alloc_info_t *arg)
+{
+	memset(arg, 0, sizeof(*arg));
+	return 0;
+}
+
+static void msi_domain_ops_set_desc(msi_alloc_info_t *arg,
+				    struct msi_desc *desc)
+{
+	arg->desc = desc;
+}
+#else
+#define msi_domain_ops_get_hwirq	NULL
+#define msi_domain_ops_prepare		NULL
+#define msi_domain_ops_set_desc		NULL
+#endif /* !GENERIC_MSI_DOMAIN_OPS */
+
+static int msi_domain_ops_init(struct irq_domain *domain,
+			       struct msi_domain_info *info,
+			       unsigned int virq, irq_hw_number_t hwirq,
+			       msi_alloc_info_t *arg)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, info->chip,
+				      info->chip_data);
+	if (info->handler && info->handler_name) {
+		__irq_set_handler(virq, info->handler, 0, info->handler_name);
+		if (info->handler_data)
+			irq_set_handler_data(virq, info->handler_data);
+	}
+	return 0;
+}
+
+static int msi_domain_ops_check(struct irq_domain *domain,
+				struct msi_domain_info *info,
+				struct device *dev)
+{
+	return 0;
+}
+
+static struct msi_domain_ops msi_domain_ops_default = {
+	.get_hwirq	= msi_domain_ops_get_hwirq,
+	.msi_init	= msi_domain_ops_init,
+	.msi_check	= msi_domain_ops_check,
+	.msi_prepare	= msi_domain_ops_prepare,
+	.set_desc	= msi_domain_ops_set_desc,
+};
+
+static void msi_domain_update_dom_ops(struct msi_domain_info *info)
+{
+	struct msi_domain_ops *ops = info->ops;
+
+	if (ops == NULL) {
+		info->ops = &msi_domain_ops_default;
+		return;
+	}
+
+	if (ops->get_hwirq == NULL)
+		ops->get_hwirq = msi_domain_ops_default.get_hwirq;
+	if (ops->msi_init == NULL)
+		ops->msi_init = msi_domain_ops_default.msi_init;
+	if (ops->msi_check == NULL)
+		ops->msi_check = msi_domain_ops_default.msi_check;
+	if (ops->msi_prepare == NULL)
+		ops->msi_prepare = msi_domain_ops_default.msi_prepare;
+	if (ops->set_desc == NULL)
+		ops->set_desc = msi_domain_ops_default.set_desc;
+}
+
+static void msi_domain_update_chip_ops(struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	BUG_ON(!chip);
+	if (!chip->irq_mask)
+		chip->irq_mask = pci_msi_mask_irq;
+	if (!chip->irq_unmask)
+		chip->irq_unmask = pci_msi_unmask_irq;
+	if (!chip->irq_set_affinity)
+		chip->irq_set_affinity = msi_domain_set_affinity;
+}
+
+/**
+ * msi_create_irq_domain - Create a MSI interrupt domain
+ * @of_node:	Optional device-tree node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ */
+struct irq_domain *msi_create_irq_domain(struct device_node *node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent)
+{
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		msi_domain_update_dom_ops(info);
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		msi_domain_update_chip_ops(info);
+
+	return irq_domain_add_hierarchy(parent, 0, 0, node, &msi_domain_ops,
+					info);
+}
+
+/**
+ * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
+ * @domain:	The domain to allocate from
+ * @dev:	Pointer to device struct of the device for which the interrupts
+ *		are allocated
+ * @nvec:	The number of interrupts to allocate
+ *
+ * Returns 0 on success or an error code.
+ */
+int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
+			  int nvec)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
+	msi_alloc_info_t arg;
+	struct msi_desc *desc;
+	int i, ret, virq = -1;
+
+	ret = ops->msi_check(domain, info, dev);
+	if (ret == 0)
+		ret = ops->msi_prepare(domain, dev, nvec, &arg);
+	if (ret)
+		return ret;
+
+	for_each_msi_entry(desc, dev) {
+		ops->set_desc(&arg, desc);
+		if (info->flags & MSI_FLAG_IDENTITY_MAP)
+			virq = (int)ops->get_hwirq(info, &arg);
+		else
+			virq = -1;
+
+		virq = __irq_domain_alloc_irqs(domain, virq, desc->nvec_used,
+					       dev_to_node(dev), &arg, false);
+		if (virq < 0) {
+			ret = -ENOSPC;
+			if (ops->handle_error)
+				ret = ops->handle_error(domain, desc, ret);
+			if (ops->msi_finish)
+				ops->msi_finish(&arg, ret);
+			return ret;
+		}
+
+		for (i = 0; i < desc->nvec_used; i++)
+			irq_set_msi_desc_off(virq, i, desc);
+	}
+
+	if (ops->msi_finish)
+		ops->msi_finish(&arg, 0);
+
+	for_each_msi_entry(desc, dev) {
+		if (desc->nvec_used == 1)
+			dev_dbg(dev, "irq %d for MSI\n", virq);
+		else
+			dev_dbg(dev, "irq [%d-%d] for MSI\n",
+				virq, virq + desc->nvec_used - 1);
+	}
+
+	return 0;
+}
+
+/**
+ * msi_domain_free_irqs - Free interrupts from a MSI interrupt @domain associated tp @dev
+ * @domain:	The domain to managing the interrupts
+ * @dev:	Pointer to device struct of the device for which the interrupts
+ *		are free
+ */
+void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
+{
+	struct msi_desc *desc;
+
+	for_each_msi_entry(desc, dev) {
+		irq_domain_free_irqs(desc->irq, desc->nvec_used);
+		desc->irq = 0;
+	}
+}
+
+/**
+ * msi_get_domain_info - Get the MSI interrupt domain info for @domain
+ * @domain:	The interrupt domain to retrieve data from
+ *
+ * Returns the pointer to the msi_domain_info stored in
+ * @domain->host_data.
+ */
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
+{
+	return (struct msi_domain_info *)domain->host_data;
+}
+
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
