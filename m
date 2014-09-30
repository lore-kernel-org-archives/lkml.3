Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaI3McF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:32:05 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64769 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaI3McC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:32:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Tue, 30 Sep 2014 14:31:44 +0200
Message-ID: <3090148.OUdB0fsdsR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930120344.GA14215@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <8631927.qWHZsjCs8e@wuerfel> <20140930120344.GA14215@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o+AdATQ1HEG1CQkPHvqpUmHj3KLeA25Xs8np5FpIGPH
 pHxatFu6KDI9FCfqwZHyxkBAljCk8EBniijud0MczlGFadouz4
 2mzi/msmk5d4bRjw9p2uhr0FtS++PohrRjCDpzvwzLrgEa2BiT
 7ZuQHpAL6MRYpTzTo5ZKupxBOjBYMYHcBiuOHmIIa5LvssY3ay
 W+aRYPVeX+34VxOwYBkIootoZYBHfVSGmW9Mb+6aTSYbQ738zR
 5TiJc4uu1gdgq4EPxJWMYaNTlrHcmcVKJkte0aVV0CcSKtCEdW
 YfJw4kLiHKwMWBK3tLgZKpJ3++U/8ajwlVJBHL8ajkUl9UbSJT
 zucWo5b6x4WkjJ4YdInA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 13:03:44 Lorenzo Pieralisi wrote:
> > >  static int gen_pci_probe(struct platform_device *pdev)
> > >  {
> > > @@ -326,6 +385,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> > >         struct device *dev = &pdev->dev;
> > >         struct device_node *np = dev->of_node;
> > >         struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
> > > +#ifndef CONFIG_ARM64
> > >         struct hw_pci hw = {
> > >                 .nr_controllers = 1,
> > >                 .private_data   = (void **)&pci,
> > > @@ -333,6 +393,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> > >                 .map_irq        = of_irq_parse_and_map_pci,
> > >                 .ops            = &gen_pci_ops,
> > >         };
> > > +#endif
> > >  
> > 
> > Same here, I'd suggest marking this "#ifdef CONFIG_ARM" instead, as hw_pci
> > is an arm32 specific data structure.
> 
> I do not think we need hw struct at all, see below, we can write code so
> that we do not rely on ARM32 PCI bios, I will have a stab at that and
> post the resulting code.

That would of course be best. I think it needs some rework of the
arm32 PCI code though, or you'd still have to create pci_sys_data
manually, and that is currently allocated by pcibios_init_hw.

> > > +       if (!gen_scan_root_bus(&pdev->dev, pci->cfg.bus_range.start,
> > > +                              &gen_pci_ops, pci, &pci->resources)) {
> > > +               dev_err(&pdev->dev, "failed to enable PCIe ports\n");
> > > +               return -ENODEV;
> > > +       }
> > > +#else
> > >         pci_common_init_dev(dev, &hw);
> > > +#endif /* CONFIG_ARM64 */
> > > 
> > 
> > Again, just make the pci_common_init_dev() call #ifdef CONFIG_ARM, and move
> > the generic case after it, outside of the #ifdef.
> 
> I went through the code quickly but I think we can (and should) remove
> this quite ugly ifdeffery altogether. Most of the functionality in
> pci_common_init_dev() can be implemented through the common PCI API (and this
> would make this driver arch agnostic as it should be), I will go through ARM32
> PCI bios code to check what is executed in detail in pci_common_init_dev() and
> make sure that we follow those initialization steps in the resulting probe code
> for this PCI generic host controller driver.

These are the functions I found that refer to pci_sys_data on arm32:

pcibios_add_bus
pcibios_remove_bus
pcibios_align_resource
pci_mmap_page_range
pci_domain_nr
pci_proc_domain

This is not as bad as I had feared, but we still have to ensure that
any caller of these functions will work with both the generic PCI support
and the arm32 specific drivers that today use hw_pci.

My idea for dealing with this was to convert all host drivers in
drivers/pci/host to the generic PCI code and never build the arm32
bios32 code when CONFIG_ARCH_MULTIPLATFORM is set. Unfortunately that
requires either doing them all at once or coming up with a migration
strategy so we don't break things in the process.

Note that arch/arm/mach-cns3xxx/pcie.c also belongs in the drivers/pci/host
category and should probably be moved there. The integrator and versatile
PCI drivers are currently not used with MULTIPLATFORM but will at some point
and we can convert them as we get there.

	Arnd
