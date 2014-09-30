Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaI3UB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:01:28 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64131 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaI3UBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:01:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Tue, 30 Sep 2014 22:01:14 +0200
Message-ID: <2430078.s4snyh5OoF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3079787.54pZijGjZM@wuerfel>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <20140930174821.GX841@e106497-lin.cambridge.arm.com> <3079787.54pZijGjZM@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OCoMSV8AzRQ+b6nHs2P0sgd9LtGXCUcJSpU0C1/asQB
 6ydalVmp29uDdnOMfr3BfRaVErJ0sNARAT/BtxmeGzro5MG98M
 aKIhBJ8yoDmYDeSDWDMlaKa7wv2J0IIZAs48TaNy9taO5B4uYv
 MIE4c2/UoZR4/bHD4JroVDGM3I/4bh9XkDj3Q2zEVVvxZzUDsE
 nVL1CcaLFd3UmGvprFAi974+At2AdFZYsBdTih9NFrbHDh5imi
 mMFe+lg4HkioZOgCnemrFo6UZyyiO6D9/zzfyER0A/9hOTiV9t
 FeH6q9aw1RE773JFQnCvvuW7rNvLcYP2j+iaaerWTySQ4+rshH
 qzODhdhsIgnzUV0cF96s=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 20:54:41 Arnd Bergmann wrote:
> On Tuesday 30 September 2014 18:48:21 Liviu Dudau wrote:
> > > > > > These are the functions I found that refer to pci_sys_data on arm32:
> > > > > > 
> > > > > > pcibios_add_bus
> > > > > > pcibios_remove_bus
> > 
> > These are only needed if you want to do per HB processing of the bus
> > 
> > > > > > pcibios_align_resource
> > 
> > mvebu is the only user of this function.
> > 
> > > > > > pci_mmap_page_range
> > 
> > This is only needed when mapping a PCI resource to userspace. Is that your case here?
> > 
> > > > > > pci_domain_nr
> > > > > > pci_proc_domain
> > 
> > We have equivalent functionality in the generic patches for those.
> > 
> 
> We clearly don't need those functions for the new drivers, but that's not
> the point. The problem is that when you build a kernel that has both
> a traditional host bridge driver and a new one in it, you always get those
> functions and they get called from the PCI core, with incorrect arguments.

FWIW, the last time we discussed this, I think I had suggested that the
functions that are currently architecture specific and have a generic
__weak fallback could become function pointers in a per-host structure
passed to pci_scan_root_bus, either a new structure or an extended
struct pci_ops. Something along these lines:

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 7fc42784becb..3da32fc631d0 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -36,7 +36,6 @@ struct hw_pci {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
 	void		(*remove_bus)(struct pci_bus *bus);
 };
 
@@ -65,7 +64,6 @@ struct pci_sys_data {
 					  resource_size_t start,
 					  resource_size_t size,
 					  resource_size_t align);
-	void		(*add_bus)(struct pci_bus *bus);
 	void		(*remove_bus)(struct pci_bus *bus);
 	void		*private_data;	/* platform controller private data	*/
 };
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c17f7f5..3cbcf8dc41e4 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -360,13 +360,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pcibios_fixup_bus);
 
-void pcibios_add_bus(struct pci_bus *bus)
-{
-	struct pci_sys_data *sys = bus->sysdata;
-	if (sys->add_bus)
-		sys->add_bus(bus);
-}
-
 void pcibios_remove_bus(struct pci_bus *bus)
 {
 	struct pci_sys_data *sys = bus->sysdata;
@@ -475,7 +468,6 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
 		sys->align_resource = hw->align_resource;
-		sys->add_bus = hw->add_bus;
 		sys->remove_bus = hw->remove_bus;
 		INIT_LIST_HEAD(&sys->resources);
 
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index b1315e197ffb..c9a0ee0429e8 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -716,6 +716,7 @@ static int mvebu_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
 static struct pci_ops mvebu_pcie_ops = {
 	.read = mvebu_pcie_rd_conf,
 	.write = mvebu_pcie_wr_conf,
+	.add_bus = mvebu_pcie_add_bus,
 };
 
 static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
@@ -823,7 +824,6 @@ static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
 	hw.map_irq        = of_irq_parse_and_map_pci;
 	hw.ops            = &mvebu_pcie_ops;
 	hw.align_resource = mvebu_pcie_align_resource;
-	hw.add_bus        = mvebu_pcie_add_bus;
 
 	pci_common_init(&hw);
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a63a47a70846..be6d56358320 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1885,6 +1885,8 @@ int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
 
 void __weak pcibios_add_bus(struct pci_bus *bus)
 {
+	if (bus->ops && bus->ops->add_bus)
+		bus->ops->add_bus(bus);		
 }
 
 void __weak pcibios_remove_bus(struct pci_bus *bus)

	Arnd
