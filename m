Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaGVXwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:52:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48113 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbaGVXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:52:04 -0400
Date: Tue, 22 Jul 2014 17:52:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 4/5] PCI: add PCI controller for keystone PCIe h/w
Message-ID: <20140722235200.GC27965@google.com>
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
 <1405961925-27248-5-git-send-email-m-karicheri2@ti.com>
 <20140722223527.GA27965@google.com>
 <53CEEB1C.9020202@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CEEB1C.9020202@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 06:52:12PM -0400, Murali Karicheri wrote:
> Bjorn,
> 
> On 07/22/2014 06:35 PM, Bjorn Helgaas wrote:
> >On Mon, Jul 21, 2014 at 12:58:44PM -0400, Murali Karicheri wrote:
> >>keystone PCIe controller is based on v3.65 version of the
> >>designware h/w. Main differences are
> >>	1. No ATU support
> >>	2. Legacy and MSI irq functions are implemented in
> >>	   application register space
> >>	3. MSI interrupts are multiplexed over 8 IRQ lines to the Host
> >>	   side.
> >>All of the Application register space handing code are organized into
> >>pci-keystone-dw.c and the functions are called from pci-keystone.c
> >>to implement PCI controller driver. Also add necessary DT documentation
> >>for the driver.
> >>
> >>Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> >>Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
> >>...
> >
> >>+++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
> >>...
> >
> >>+Note for PCI driver usage
> >>+=========================
> >>+Driver requires pci=pcie_bus_perf in the bootargs for proper functioning.
> >
> >Whoa, why is this?  Special boot args should not be required.
> 
> This was discussed initially and I had added following commit to get
> this working instead of a PCI quirk. To get some background please
> see the thread for commit below that you also had signed off as
> well.

I applied 8b5742ad156d because it's something all arches should do
(actually, we *should* do it in the PCI core, but nobody's gotten
around to doing that yet).  It has nothing to do with Keystone
support, and it doesn't mean I'm in favor of a boot argument.

I think the discussion you mentioned is [1].  I see hints that there
might be a Keystone hardware defect related to MRSS, but I don't see a
clear description of it.  If you have a hardware erratum document,
those usually contain pretty good descriptions.

If there is a hardware defect, a PCI quirk is a reasonable way to work
around it, since that's the main purpose of quirks.  fixup_mpss_256()
is an example of something that sounds superficially similar.

I don't think there's a way for a device to advertise the maximum MRSS
value it supports.  MRSS only controls the maximum Read Request size
the device can generate, and I wouldn't think there's much to go wrong
there, because the request doesn't contain any data, so MRSS doesn't
affect the packet size of the *request*.

I think it's more likely that a hardware problem would affect the
*response*, where, e.g., a device might advertise (via the Device
Capabilities Max_Payload_Size_Supported field) that it can support an
MPS of 1024, but it can't actually handle a TLP that big.  Software
would have to work around that by artificially limiting the MPS to
something smaller than the MPSS advertised by the device.  This is
what fixup_mpss_256() is doing.

If there is a hardware problem with MRSS specifically, you can
probably still do a quirk, but it might also involve a little work in
the PCI core to add something similar to pcie_mpss to support the
quirk.

Bjorn

[1] http://lkml.kernel.org/r/1400169692-9677-6-git-send-email-m-karicheri2@ti.com

> commit 8b5742ad156d30ee38486652cdbd152e2d6ebbcc
> Author: Murali Karicheri <m-karicheri2@ti.com>
> Date:   Wed May 28 13:14:53 2014 -0400
> 
>     ARM/PCI: Call pcie_bus_configure_settings() to set MPS
> 
>     Call pcie_bus_configure_settings() on ARM, like for other platforms.
>     pcie_bus_configure_settings() makes sure the MPS across the bus
> is uniform
>     and provides the ability to tune the MRSS and MPS to higher performance
>     values.  This is particularly important for embedded where there is no
>     firmware to program these PCIe settings for the OS.
> 
>     Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     CC: Russell King <linux@arm.linux.org.uk>
>     CC: Arnd Bergmann <arnd@arndb.de>
>     CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>     CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> This was added as a preparatory patch to support keystone and
> avoid a PCI quirk to do the same. Keystone has MRSS limitation
> of 256 bytes. So adding a bootargs flag was suggested a better
> option than a PCI quirk.
> 
> I will look into the rest of the comments and possibly try to
> address them or discuss.
> 
> BTW, please apply patch 1-3 that has already got ack from maintainers
> and is indepdent of this patch.
> 
> Thanks
> 
> Murali
> 
> >
> >>diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> >>index 21df477..f8bc475 100644
> >>--- a/drivers/pci/host/Kconfig
> >>+++ b/drivers/pci/host/Kconfig
> >>@@ -46,4 +46,9 @@ config PCI_HOST_GENERIC
> >>  	  Say Y here if you want to support a simple generic PCI host
> >>  	  controller, such as the one emulated by kvmtool.
> >>
> >>+config PCI_KEYSTONE
> >>+	bool "TI Keystone PCIe controller"
> >>+	depends on ARCH_KEYSTONE
> >>+	select PCIE_DW
> >>+	select PCIEPORTBUS
> >
> >It'd be nice to have some help text here.  I know, not everybody else does.
> >
> >>+++ b/drivers/pci/host/pci-keystone-dw.c
> >>...
> >>+void ks_dw_pcie_handle_msi_irq(struct keystone_pcie *ks_pcie , int offset)
> >>+{
> >>+	struct pcie_port *pp =&ks_pcie->pp;
> >>+	u32 pending, vector;
> >>+	int src, virq;
> >>+
> >>+	pending = readl(ks_pcie->va_app_base + MSI0_IRQ_STATUS + (offset<<  4));
> >
> >Blank line here (before the block comment).
> >
> >>+	/*
> >>+	 * MSI0, Status bit 0-3 shows vectors 0, 8, 16, 24, MSI1 status bit
> >>+	 * shows 1, 9, 17, 25 and so forth
> >>+	 */
> >>+	for (src = 0; src<  4; src++) {
> >>+		if (BIT(src)&  pending) {
> >>+			vector = offset + (src<<  3);
> >>+			virq = irq_linear_revmap(pp->irq_domain, vector);
> >>+			dev_dbg(pp->dev,
> >>+				"irq: bit %d, vector %d, virq %d\n",
> >>+				 src, vector, virq);
> >>+			generic_handle_irq(virq);
> >>+		}
> >>+	}
> >>+}
> >>+
> >>...
> >
> >>+static void __iomem *ks_pcie_cfg_setup(struct keystone_pcie *ks_pcie, u8 bus,
> >>+					unsigned int devfn)
> >>+{
> >>+	u8 device = PCI_SLOT(devfn), function = PCI_FUNC(devfn);
> >>+	struct pcie_port *pp =&ks_pcie->pp;
> >>+	u32 regval;
> >>+
> >>+	if (bus == 0)
> >>+		return pp->dbi_base;
> >>+
> >>+	regval = (bus<<  16) | (device<<  8) | function;
> >>+	/*
> >>+	 * Since Bus#1 will be a virtual bus, we need to have TYPE0
> >>+	 * access only.
> >>+	 * TYPE 1
> >>+	 */
> >>+	if (bus != 1)
> >>+		regval |= BIT(24);
> >>+
> >>+	writel(regval, ks_pcie->va_app_base + CFG_SETUP);
> >>+	return pp->va_cfg0_base;
> >>+}
> >>+
> >>+int ks_dw_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
> >>+		unsigned int devfn, int where, int size, u32 *val)
> >>+{
> >>+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
> >>+	u8 bus_num = bus->number;
> >>+	void __iomem *addr;
> >>+	int ret;
> >>+
> >>+	addr = ks_pcie_cfg_setup(ks_pcie, bus_num, devfn);
> >>+	ret = dw_pcie_cfg_read(addr + (where&  ~0x3), where, size, val);
> >
> >This *looks* like it needs a lock to protect against concurrent
> >ks_pcie_cfg_setup() users, since it writes a register.
> >
> >>+
> >>+	return ret;
> >
> >Please use the same style as in ks_dw_pcie_wr_other_conf(), i.e., get rid
> >of "ret".
> >
> >>+}
> >>+
> >>+int ks_dw_pcie_wr_other_conf(struct pcie_port *pp,
> >>+		struct pci_bus *bus, unsigned int devfn, int where,
> >>+		int size, u32 val)
> >>+{
> >>+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
> >>+	u8 bus_num = bus->number;
> >>+	void __iomem *addr;
> >>+
> >>+	addr = ks_pcie_cfg_setup(ks_pcie, bus_num, devfn);
> >>+
> >>+	return dw_pcie_cfg_write(addr + (where&  ~0x3), where, size, val);
> >>+}
> >
> >>+++ b/drivers/pci/host/pci-keystone.c
> >>...
> >
> >>+static struct platform_driver ks_pcie_driver __refdata = {
> >
> >Why does this need to be __refdata?  There are no other occurrences in
> >drivers/pci.
> >
> >>+	.probe  = ks_pcie_probe,
> >>+	.remove = __exit_p(ks_pcie_remove),
> >>+	.driver = {
> >>+		.name	= "keystone-pcie",
> >>+		.owner	= THIS_MODULE,
> >>+		.of_match_table = of_match_ptr(ks_pcie_of_match),
> >>+	},
> >>+};
> >
> >Bjorn
> 
