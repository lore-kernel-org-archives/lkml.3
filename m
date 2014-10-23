Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaJWNdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:33:36 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56908 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJWNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:33:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Thu, 23 Oct 2014 15:33:16 +0200
Message-ID: <2355100.WsW1DXh57P@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <2148776.X8NPqiYA6S@wuerfel> <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0bQtkshj+56clo7jVLadfk8RhQDz9aW2xppEoU8zLe4
 OuVEvMglbFPFXmUlqKO+zgrLX6i3/sOxPG4ta0Yg+fMfd+ZS4N
 gSp6JLfwOeDcDiBlpX+Ukcv+3p+MADdkLrU0JQJTY9lJrSUxFM
 YjcqfNPcGT4MTj+YwP2HMFdseggOMev29J8QZ/FsfSCI2xBnHJ
 YQjTpD+weEzvLTyx9Gr1YFc+2afdRF53EMLJfF3CFCVgncPpP1
 gBxdEe6bipMcbNsmICrt+pSDH630ZddmfKLHyaSlQ2B5d/6IMN
 kwxH2i7IdDDTjV9zs77/y8sVhQ3yPB5/fkQId5qyDXu6ldU1dt
 XoLdgR35dOAXn/gFkPrU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2014 10:13:09 Liviu Dudau wrote:
> > @@ -335,7 +329,9 @@ void __init cns3xxx_pcie_init_late(void)
> >               cns3xxx_pwr_soft_rst(0x1 << PM_SOFT_RST_REG_OFFST_PCIE(i));
> >               cns3xxx_pcie_check_link(&cns3xxx_pcie[i]);
> >               cns3xxx_pcie_hw_init(&cns3xxx_pcie[i]);
> > -             pci_common_init(&cns3xxx_pcie[i].hw_pci);
> > +             hw_pci->domain = i;
> > +             private_data = &cns3xxx_pcie[i];
> 
> Is this dance with pointers absolutely necessary? Does gcc though dishes at you
> for doing hw_pci->private_data = &cns3xxx_pcie[i] directly?

hw_pci->private_data is an array of pointers to private_data for each
host controller instance within the domain. There is only one entry
here, but you still the the correct type, so that would be 

	hw_pci->private_data = (void **)&&cns3xxx_pcie[i];

which is even more confusing and ugly than what I wrote. If you have
a better idea, I'm all for it. Maybe it's clearer to write like this
(taken from rcar driver)?

	void *hw_private[1];
	hw_pci.private_data = hw_private;

	for each host {
		...
		hw_private[0] = &cns3xxx_pcie[i];
		pci_common_init_dev(&hw_pci);
	}

Note that all 'modern' controllers always use nr_controllers=1, so we
only need a single private_data pointer per domain, and the entire
hw_pci interface is a bit pointless.

The platforms that currently require it are iop13xx, dove, mv78xx0
and orion5x. We have plans to remove the last three platforms in
the next merge window or two, once all users are able to migrate to
mach-mvebu. Once that happens, we could probably move the entire
hw_pci logic that deals with multiple hosts per domain into the
iop13xx pci driver if we want to. A less intrusive simplification
would be to convert all 'multiplatform'-aware host controllers to
use pci_common_init_dev() and then take hw_pci out of that.

See below for a sample patch I just did. It duplicates the code from
pci_common_init_dev/pci_common_init because we know that all users
of pci_common_init_dev are modern and only pass a single host bridge.
The new pci_common_init_dev is simpler than the old one but should
do the exact same thing for all current users, with the addition
of propagating the return value.

pci_init_single() is the new internal helper and we should be able to
convert all existing users of pci_common_init_dev() to use that directly
and no longer define hw_pci at all.

I've converted two drivers to give an example, but the conversions
should be done in follow-up patches really, and the pci_common_init_dev
function removed after all users are moved over.

The new pci_init_single() is also rather simple, and it should just
converge with what we do for arm64 over time.

	Arnd

---
 arch/arm/include/asm/mach/pci.h     |  20 ++++---
 arch/arm/kernel/bios32.c            | 103 ++++++++++++++++++++++++++++++++++--
 drivers/pci/host/pci-host-generic.c |  53 ++++++++-----------
 drivers/pci/host/pci-mvebu.c        |  44 +++++++--------
 4 files changed, 157 insertions(+), 63 deletions(-)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 7fc42784becb..fe7e13759ec0 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -73,16 +73,22 @@ struct pci_sys_data {
 /*
  * Call this with your hw_pci struct to initialise the PCI system.
  */
-void pci_common_init_dev(struct device *, struct hw_pci *);
+void pci_common_init(struct hw_pci *);
 
 /*
- * Compatibility wrapper for older platforms that do not care about
- * passing the parent device.
+ * Used by modern platforms, only one host allowed.
  */
-static inline void pci_common_init(struct hw_pci *hw)
-{
-	pci_common_init_dev(NULL, hw);
-}
+int pci_common_init_dev(struct device *, struct hw_pci *);
+
+/*
+ * Replaces pci_common_init_dev for drivers that want to do the
+ * initialization simpler and avoid defining hw_pci
+ */
+int pci_init_single(struct device *parent, 
+		    struct pci_sys_data *sys,
+		    struct pci_bus *(*scan)(int nr, struct pci_sys_data *),
+		    struct pci_ops *ops);
+
 
 /*
  * Setup early fixed I/O mapping.
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c17f7f5..bccc8703e575 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -456,8 +456,7 @@ static int pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 	return 0;
 }
 
-static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
-			    struct list_head *head)
+static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
 	int ret;
@@ -494,7 +493,7 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 			if (hw->scan)
 				sys->bus = hw->scan(nr, sys);
 			else
-				sys->bus = pci_scan_root_bus(parent, sys->busnr,
+				sys->bus = pci_scan_root_bus(NULL, sys->busnr,
 						hw->ops, sys, &sys->resources);
 
 			if (!sys->bus)
@@ -511,7 +510,7 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 	}
 }
 
-void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
+void pci_common_init(struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
 	LIST_HEAD(head);
@@ -519,7 +518,7 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
 	if (hw->preinit)
 		hw->preinit();
-	pcibios_init_hw(parent, hw, &head);
+	pcibios_init_hw(hw, &head);
 	if (hw->postinit)
 		hw->postinit();
 
@@ -559,6 +558,100 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 	}
 }
 
+int pci_init_single(struct device *parent,
+		    struct pci_sys_data *sys,
+		    struct pci_bus *(*scan)(int nr, struct pci_sys_data *),
+		    struct pci_ops *ops)
+{
+	int ret;
+	struct pci_bus *bus;
+
+	ret = pcibios_init_resources(0, sys);
+	if (ret)
+		return ret;
+
+	if (scan)
+		bus = scan(0, sys);
+	else
+		bus = pci_scan_root_bus(parent, 0, ops, sys, &sys->resources);
+
+	if (!bus) {
+		dev_err(parent, "PCI: unable to scan bus!");
+		return -ENXIO;
+	}
+	sys->bus = bus;
+
+	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
+
+	if (!pci_has_flag(PCI_PROBE_ONLY)) {
+		/*
+		 * Size the bridge windows.
+		 */
+		pci_bus_size_bridges(bus);
+
+		/*
+		 * Assign resources.
+		 */
+		pci_bus_assign_resources(bus);
+	}
+
+	/*
+	 * Tell drivers about devices found.
+	 */
+	pci_bus_add_devices(bus);
+
+	/* Configure PCI Express settings */
+	if (bus && !pci_has_flag(PCI_PROBE_ONLY)) {
+		struct pci_bus *child;
+
+		list_for_each_entry(child, &bus->children, node)
+			pcie_bus_configure_settings(child);
+	}
+
+	return 0;
+}
+
+int pci_common_init_dev(struct device *parent, struct hw_pci *hw)
+{
+	struct pci_sys_data *sys;
+	int ret;
+
+	if (hw->nr_controllers != 1 ||
+	    hw->preinit || hw->postinit)
+		return -EINVAL;
+
+	sys = kzalloc(sizeof(struct pci_sys_data), GFP_KERNEL);
+	if (!sys)
+		return -ENOMEM;
+
+#ifdef CONFIG_PCI_DOMAINS
+	sys->domain  = hw->domain;
+#endif
+	sys->swizzle = hw->swizzle;
+	sys->map_irq = hw->map_irq;
+	sys->align_resource = hw->align_resource;
+	sys->add_bus = hw->add_bus;
+	sys->remove_bus = hw->remove_bus;
+	INIT_LIST_HEAD(&sys->resources);
+
+	if (hw->private_data)
+		sys->private_data = hw->private_data[0];
+
+	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
+	ret = hw->setup(0, sys);
+	if (ret == 0)
+		ret = -ENXIO;
+	if (ret < 0)
+		return ret;
+
+	ret = pcibios_init_sysdata(parent, sys, hw->scan, hw->ops);
+	if (ret)
+		/* FIXME: undo ->setup */
+		kfree(sys);
+
+	return ret;
+}
+
 #ifndef CONFIG_PCI_HOST_ITE8152
 void pcibios_set_master(struct pci_dev *dev)
 {
diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 3d2076f59911..3542a7b740e5 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -40,16 +40,20 @@ struct gen_pci_cfg_windows {
 
 struct gen_pci {
 	struct pci_host_bridge			host;
+	struct pci_sys_data			sys;
 	struct gen_pci_cfg_windows		cfg;
-	struct list_head			resources;
 };
 
+static inline struct gen_pci *gen_pci_from_sys(struct pci_sys_data *sys)
+{
+	return container_of(sys, struct gen_pci, sys);
+}
+
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 					     unsigned int devfn,
 					     int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
 
 	return pci->cfg.win[idx] + ((devfn << 8) | where);
@@ -64,8 +68,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
 					      unsigned int devfn,
 					      int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
 
 	return pci->cfg.win[idx] + ((devfn << 12) | where);
@@ -80,8 +83,7 @@ static int gen_pci_config_read(struct pci_bus *bus, unsigned int devfn,
 				int where, int size, u32 *val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -103,8 +105,7 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
 				 int where, int size, u32 val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -181,10 +182,10 @@ static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
 {
 	struct pci_host_bridge_window *win;
 
-	list_for_each_entry(win, &pci->resources, list)
+	list_for_each_entry(win, &pci->sys.resources, list)
 		release_resource(win->res);
 
-	pci_free_resource_list(&pci->resources);
+	pci_free_resource_list(&pci->sys.resources);
 }
 
 static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
@@ -237,7 +238,7 @@ static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
 		if (err)
 			goto out_release_res;
 
-		pci_add_resource_offset(&pci->resources, res, offset);
+		pci_add_resource_offset(&pci->sys.resources, res, offset);
 	}
 
 	if (!res_valid) {
@@ -306,17 +307,10 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 	}
 
 	/* Register bus resource */
-	pci_add_resource(&pci->resources, bus_range);
+	pci_add_resource(&pci->sys.resources, bus_range);
 	return 0;
 }
 
-static int gen_pci_setup(int nr, struct pci_sys_data *sys)
-{
-	struct gen_pci *pci = sys->private_data;
-	list_splice_init(&pci->resources, &sys->resources);
-	return 1;
-}
-
 static int gen_pci_probe(struct platform_device *pdev)
 {
 	int err;
@@ -326,17 +320,12 @@ static int gen_pci_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
-	struct hw_pci hw = {
-		.nr_controllers	= 1,
-		.private_data	= (void **)&pci,
-		.setup		= gen_pci_setup,
-		.map_irq	= of_irq_parse_and_map_pci,
-		.ops		= &gen_pci_ops,
-	};
 
 	if (!pci)
 		return -ENOMEM;
 
+	pci->sys.map_irq	= of_irq_parse_and_map_pci,
+
 	type = of_get_property(np, "device_type", NULL);
 	if (!type || strcmp(type, "pci")) {
 		dev_err(dev, "invalid \"device_type\" %s\n", type);
@@ -355,7 +344,7 @@ static int gen_pci_probe(struct platform_device *pdev)
 	pci->cfg.ops = of_id->data;
 	pci->host.dev.parent = dev;
 	INIT_LIST_HEAD(&pci->host.windows);
-	INIT_LIST_HEAD(&pci->resources);
+	INIT_LIST_HEAD(&pci->sys.resources);
 
 	/* Parse our PCI ranges and request their resources */
 	err = gen_pci_parse_request_of_pci_ranges(pci);
@@ -369,8 +358,12 @@ static int gen_pci_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	pci_common_init_dev(dev, &hw);
-	return 0;
+	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
+	err = pci_init_single(dev, &pci->sys, NULL, &gen_pci_ops);
+	if (err)
+		gen_pci_release_of_pci_ranges(pci);
+
+	return err;
 }
 
 static struct platform_driver gen_pci_driver = {
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index b1315e197ffb..e1381c0699be 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -99,6 +99,7 @@ struct mvebu_pcie_port;
 struct mvebu_pcie {
 	struct platform_device *pdev;
 	struct mvebu_pcie_port *ports;
+	struct pci_sys_data sysdata;
 	struct msi_chip *msi;
 	struct resource io;
 	char io_name[30];
@@ -611,7 +612,7 @@ static int mvebu_sw_pci_bridge_write(struct mvebu_pcie_port *port,
 
 static inline struct mvebu_pcie *sys_to_pcie(struct pci_sys_data *sys)
 {
-	return sys->private_data;
+	return container_of(sys, struct mvebu_pcie, sysdata);
 }
 
 static struct mvebu_pcie_port *mvebu_pcie_find_port(struct mvebu_pcie *pcie,
@@ -718,11 +719,26 @@ static struct pci_ops mvebu_pcie_ops = {
 	.write = mvebu_pcie_wr_conf,
 };
 
-static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
+/* FIXME: move the code around to avoid these */
+static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys);
+static void mvebu_pcie_add_bus(struct pci_bus *bus);
+static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
+						 const struct resource *res,
+						 resource_size_t start,
+						 resource_size_t size,
+						 resource_size_t align);
+
+static int mvebu_pcie_enable(struct mvebu_pcie *pcie)
 {
-	struct mvebu_pcie *pcie = sys_to_pcie(sys);
 	int i;
 	int domain = 0;
+	struct pci_sys_data *sys = &pcie->sysdata;
+
+	pcie->sysdata = (struct pci_sys_data) {
+		.map_irq        = of_irq_parse_and_map_pci,
+		.align_resource = mvebu_pcie_align_resource,
+		.add_bus        = mvebu_pcie_add_bus,
+	};
 
 #ifdef CONFIG_PCI_DOMAINS
 	domain = sys->domain;
@@ -738,11 +754,13 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 	if (request_resource(&iomem_resource, &pcie->mem))
 		return 0;
 
+	INIT_LIST_HEAD(&sys->resources);
 	if (resource_size(&pcie->realio) != 0) {
 		if (request_resource(&ioport_resource, &pcie->realio)) {
 			release_resource(&pcie->mem);
 			return 0;
 		}
+
 		pci_add_resource_offset(&sys->resources, &pcie->realio,
 					sys->io_offset);
 	}
@@ -756,7 +774,9 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 		mvebu_pcie_setup_hw(port);
 	}
 
-	return 1;
+	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
+	return pci_init_single(&pcie->pdev->dev, &pcie->sysdata,
+			       mvebu_pcie_scan_bus, &mvebu_pcie_ops);
 }
 
 static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
@@ -810,24 +830,6 @@ static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
 		return start;
 }
 
-static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
-{
-	struct hw_pci hw;
-
-	memset(&hw, 0, sizeof(hw));
-
-	hw.nr_controllers = 1;
-	hw.private_data   = (void **)&pcie;
-	hw.setup          = mvebu_pcie_setup;
-	hw.scan           = mvebu_pcie_scan_bus;
-	hw.map_irq        = of_irq_parse_and_map_pci;
-	hw.ops            = &mvebu_pcie_ops;
-	hw.align_resource = mvebu_pcie_align_resource;
-	hw.add_bus        = mvebu_pcie_add_bus;
-
-	pci_common_init(&hw);
-}
-
 /*
  * Looks up the list of register addresses encoded into the reg =
  * <...> property for one that matches the given port/lane. Once
@@ -1066,9 +1068,7 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 		pci_ioremap_io(i, pcie->io.start + i);
 
 	mvebu_pcie_msi_enable(pcie);
-	mvebu_pcie_enable(pcie);
-
-	return 0;
+	return mvebu_pcie_enable(pcie);
 }
 
 static const struct of_device_id mvebu_pcie_of_match_table[] = {

