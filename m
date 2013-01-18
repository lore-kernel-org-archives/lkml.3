Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3ARLk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:40:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44209 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3ARLkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:40:24 -0500
Date: Fri, 18 Jan 2013 11:40:19 +0000
From: Andrew Murray <Andrew.Murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH RFC 2/2] Improve bios32 support for DT PCI host bridge
 controllers
Message-ID: <20130118114019.GA9034@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Jan 2013 11:40:20.0852 (UTC) FILETIME=[9892EB40:01CDF570]
X-MC-Unique: 113011811402300301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing from discussion with Thierry (lkml.org/lkml/2013/1/18/107) perhaps
this will be useful to fold into your patchset - you may wish to remove the
overlap. 
---
This patch attempts to overcome two difficulities when providing DT PCI host
bridge controllers:

At present PCI controllers are registered via the pci_common_init call, this
results in callbacks (arch/arm/include/asm/mach/pci.h) which are used to setup
the controller. However there is no trivial way to pass a device_node to the
callbacks which is known at the time of calling pci_common_init. This is
required in order to add pci resources (pci_add_resource_offset) based on
information obtained from the device tree. This patch updates the hw_pci and
pci_sys_data structures such that drivers can provide a device_node to
pci_common_init and access it through the pci_sys_data argument of the
callbacks.

Additionally bios32 makes an assumption that all host controllers are
registered at the same time and handled by the same driver. This patch provides
support for calling pci_common_init multiple times to allow for one at a time
registration of PCI host controllers.

It also adds support for setting up of PCIe MPS and MRRS.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm/include/asm/mach/pci.h |    2 ++
 arch/arm/kernel/bios32.c        |   29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 26c511f..845a6b7 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -27,6 +27,7 @@ struct hw_pci {
 	void		(*postinit)(void);
 	u8		(*swizzle)(struct pci_dev *dev, u8 *pin);
 	int		(*map_irq)(const struct pci_dev *dev, u8 slot, u8 pin);
+	struct device_node *of_node;
 };
 
 /*
@@ -47,6 +48,7 @@ struct pci_sys_data {
 					/* IRQ mapping				*/
 	int		(*map_irq)(const struct pci_dev *, u8, u8);
 	void		*private_data;	/* platform controller private data	*/
+	struct device_node *of_node;	/* device tree node			*/
 };
 
 /*
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 2b2f25e..bde4630 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/pci.h>
@@ -426,10 +427,10 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
+	static int busnr;
 	int ret;
-	int nr, busnr;
-
-	for (nr = busnr = 0; nr < hw->nr_controllers; nr++) {
+	int nr;
+	for (nr = 0; nr < hw->nr_controllers; nr++) {
 		sys = kzalloc(sizeof(struct pci_sys_data), GFP_KERNEL);
 		if (!sys)
 			panic("PCI: unable to allocate sys data!");
@@ -440,6 +441,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 		sys->busnr   = busnr;
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
+		sys->of_node = hw->of_node;
 		INIT_LIST_HEAD(&sys->resources);
 
 		ret = hw->setup(nr, sys);
@@ -484,10 +486,11 @@ void __init pci_common_init(struct hw_pci *hw)
 	if (hw->postinit)
 		hw->postinit();
 
-	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
-
 	list_for_each_entry(sys, &head, node) {
 		struct pci_bus *bus = sys->bus;
+		struct pci_bus *child;
+
+		pci_bus_fixup_irqs(bus, pcibios_swizzle, pcibios_map_irq);
 
 		if (!pci_has_flag(PCI_PROBE_ONLY)) {
 			/*
@@ -504,6 +507,16 @@ void __init pci_common_init(struct hw_pci *hw)
 			 * Enable bridges
 			 */
 			pci_enable_bridges(bus);
+
+			/*
+			 * Configure children (MPS, MRRS)
+			 */
+			list_for_each_entry(child, &bus->children, node) {
+				struct pci_dev *self = child->self;
+				if (!self)
+					continue;
+				pcie_bus_configure_settings(child, self->pcie_mpss);
+			}
 		}
 
 		/*
@@ -627,3 +640,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 
 	return 0;
 }
+
+struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	return of_node_get(sys->of_node);
+}
-- 
1.7.0.4


