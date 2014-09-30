Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaI3Rft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:35:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42660 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaI3Rfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:35:46 -0400
Date: Tue, 30 Sep 2014 18:35:40 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20140930173540.GB16583@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <8631927.qWHZsjCs8e@wuerfel>
 <20140930120344.GA14215@e102568-lin.cambridge.arm.com>
 <3090148.OUdB0fsdsR@wuerfel>
 <20140930161241.GA16583@e102568-lin.cambridge.arm.com>
 <20140930164256.GS841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20140930164256.GS841@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 30 Sep 2014 17:35:41.0299 (UTC) FILETIME=[F4A9F430:01CFDCD4]
X-MC-Unique: 114093018354304001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 05:42:56PM +0100, Liviu Dudau wrote:
> On Tue, Sep 30, 2014 at 05:12:41PM +0100, Lorenzo Pieralisi wrote:
> > On Tue, Sep 30, 2014 at 01:31:44PM +0100, Arnd Bergmann wrote:
> > > On Tuesday 30 September 2014 13:03:44 Lorenzo Pieralisi wrote:
> > > > > >  static int gen_pci_probe(struct platform_device *pdev)
> > > > > >  {
> > > > > > @@ -326,6 +385,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> > > > > >         struct device *dev = &pdev->dev;
> > > > > >         struct device_node *np = dev->of_node;
> > > > > >         struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
> > > > > > +#ifndef CONFIG_ARM64
> > > > > >         struct hw_pci hw = {
> > > > > >                 .nr_controllers = 1,
> > > > > >                 .private_data   = (void **)&pci,
> > > > > > @@ -333,6 +393,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> > > > > >                 .map_irq        = of_irq_parse_and_map_pci,
> > > > > >                 .ops            = &gen_pci_ops,
> > > > > >         };
> > > > > > +#endif
> > > > > >  
> > > > > 
> > > > > Same here, I'd suggest marking this "#ifdef CONFIG_ARM" instead, as hw_pci
> > > > > is an arm32 specific data structure.
> > > > 
> > > > I do not think we need hw struct at all, see below, we can write code so
> > > > that we do not rely on ARM32 PCI bios, I will have a stab at that and
> > > > post the resulting code.
> > > 
> > > That would of course be best. I think it needs some rework of the
> > > arm32 PCI code though, or you'd still have to create pci_sys_data
> > > manually, and that is currently allocated by pcibios_init_hw.
> 
> I don't see why we need to involve the arm32 code here at all. A host bridge can
> be fully functional with the generic code without having to use any of the
> arm32 code (unless I'm missing something here).

Ok so I can remove the pci_common_init() call, use the common PCI API and
everything will work as expected, even if there is a list of functions (see
below) that *require* pci_sys_data to exist (and that's allocated in arm32
pcibios code in pcibios_init_hw(), called from pci_common_init()) ?

I like the idea but I think that's optimistic, or at least we did not
trigger the code paths that can cause issues.

> > Right, as far as I can see, creating a pci_sys_data struct
> > that's all we would need. "Problem" is that it does not exist on ARM64
> > so to avoid ifdeffery we have to declare a struct with the same
> > fields (ie only pci_sys_data.private_data is used by this driver -
> > apart from arm32 specific functions usage) that is passed to the PCI layer
> > and stored in the bus.sysdata, but that's extremely ugly (and we won't
> > need this when the arm32 conversion is completed).
> > 
> > > > > > +       if (!gen_scan_root_bus(&pdev->dev, pci->cfg.bus_range.start,
> > > > > > +                              &gen_pci_ops, pci, &pci->resources)) {
> > > > > > +               dev_err(&pdev->dev, "failed to enable PCIe ports\n");
> > > > > > +               return -ENODEV;
> > > > > > +       }
> > > > > > +#else
> > > > > >         pci_common_init_dev(dev, &hw);
> > > > > > +#endif /* CONFIG_ARM64 */
> > > > > > 
> > > > > 
> > > > > Again, just make the pci_common_init_dev() call #ifdef CONFIG_ARM, and move
> > > > > the generic case after it, outside of the #ifdef.
> > > > 
> > > > I went through the code quickly but I think we can (and should) remove
> > > > this quite ugly ifdeffery altogether. Most of the functionality in
> > > > pci_common_init_dev() can be implemented through the common PCI API (and this
> > > > would make this driver arch agnostic as it should be), I will go through ARM32
> > > > PCI bios code to check what is executed in detail in pci_common_init_dev() and
> > > > make sure that we follow those initialization steps in the resulting probe code
> > > > for this PCI generic host controller driver.
> > > 
> > > These are the functions I found that refer to pci_sys_data on arm32:
> > > 
> > > pcibios_add_bus
> > > pcibios_remove_bus
> > > pcibios_align_resource
> > > pci_mmap_page_range
> > > pci_domain_nr
> > > pci_proc_domain
> > > 
> > > This is not as bad as I had feared, but we still have to ensure that
> > > any caller of these functions will work with both the generic PCI support
> > > and the arm32 specific drivers that today use hw_pci.
> > > 
> > > My idea for dealing with this was to convert all host drivers in
> > > drivers/pci/host to the generic PCI code and never build the arm32
> > > bios32 code when CONFIG_ARCH_MULTIPLATFORM is set. Unfortunately that
> > > requires either doing them all at once or coming up with a migration
> > > strategy so we don't break things in the process.
> > 
> > That makes sense. Related to the migration strategy, thoughts
> > appreciated. Declaring a static pci_sys_data (with some ifdef around it)
> > seems a horrible hack to me. Calling pci_common_init() only if CONFIG_ARM
> > is rather horrible too, but we can probably live with that.
> > 
> > I do not see anything else as possible solution at the moment unless
> > we go the whole nine yards and do what you suggest above, might take a
> > little while though.
> > 
> > Probably leaving pci_common_init() call (and related hw_pci struct, and
> > related ifdeffery to differentiate between different sysdata layouts for ARM
> > and ARM64) is the fastest path but I still think it is not nice at all.
> 
> Rob Herring found the conversion of mach-integrator/pci_v3.c to the generic
> framework quite painless. We might have to go through a lot of testing, but I don't
> see the process to be too horrendous.

See my comments above, I have not said that the conversion is complicated,
what I am saying is that I am not sure we can get rid of pcibios code calls
yet, as Arnd pointed out.

Lorenzo

