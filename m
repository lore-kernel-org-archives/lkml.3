Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaI3MD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:03:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48493 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaI3MDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:03:53 -0400
Date: Tue, 30 Sep 2014 13:03:44 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20140930120344.GA14215@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1411937610-22125-3-git-send-email-suravee.suthikulpanit@amd.com>
 <8631927.qWHZsjCs8e@wuerfel>
MIME-Version: 1.0
In-Reply-To: <8631927.qWHZsjCs8e@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 30 Sep 2014 12:03:48.0034 (UTC) FILETIME=[976EDA20:01CFDCA6]
X-MC-Unique: 114093013034902801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 03:36:30PM +0100, Arnd Bergmann wrote:
> On Sunday 28 September 2014 15:53:28 suravee.suthikulpanit@amd.com wrote:
> > +
> > +#ifdef CONFIG_ARM64
> > +struct pci_bus *gen_scan_root_bus(struct device *parent, int bus,
> > +                                      struct pci_ops *ops, void *sysdata,
> > +                                      struct list_head *resources)
> > +{
> 
> I don't see anything ARM64 specific in this, the function only uses
> the newly added generic helpers.

I do not see it either, it is just a copy'n'paste of common PCI code,
plus msi management.

> >  static int gen_pci_probe(struct platform_device *pdev)
> >  {
> > @@ -326,6 +385,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> >         struct device *dev = &pdev->dev;
> >         struct device_node *np = dev->of_node;
> >         struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
> > +#ifndef CONFIG_ARM64
> >         struct hw_pci hw = {
> >                 .nr_controllers = 1,
> >                 .private_data   = (void **)&pci,
> > @@ -333,6 +393,7 @@ static int gen_pci_probe(struct platform_device *pdev)
> >                 .map_irq        = of_irq_parse_and_map_pci,
> >                 .ops            = &gen_pci_ops,
> >         };
> > +#endif
> >  
> 
> Same here, I'd suggest marking this "#ifdef CONFIG_ARM" instead, as hw_pci
> is an arm32 specific data structure.

I do not think we need hw struct at all, see below, we can write code so
that we do not rely on ARM32 PCI bios, I will have a stab at that and
post the resulting code.

> >         if (!pci)
> >                 return -ENOMEM;
> > @@ -368,8 +429,24 @@ static int gen_pci_probe(struct platform_device *pdev)
> >                 gen_pci_release_of_pci_ranges(pci);
> >                 return err;
> >         }
> > +#ifdef CONFIG_ARM64
> >  
> > +#ifdef CONFIG_PCI_MSI
> > +       pci->msi_parent = of_parse_phandle(np, "msi-parent", 0);
> > +       if (!pci->msi_parent) {
> > +               dev_err(&pdev->dev, "Failed to allocate msi-parent.\n");
> > +               return -EINVAL;
> > +       }
> > +#endif
> 
> We probably want to enable MSI unconditionally on ARM64, so the #ifdef is
> not necessary here. However, I don't think that a missing msi-parent should
> be a fatal error here: we can still continue without MSI support if this
> case.
> 
> > +       if (!gen_scan_root_bus(&pdev->dev, pci->cfg.bus_range.start,
> > +                              &gen_pci_ops, pci, &pci->resources)) {
> > +               dev_err(&pdev->dev, "failed to enable PCIe ports\n");
> > +               return -ENODEV;
> > +       }
> > +#else
> >         pci_common_init_dev(dev, &hw);
> > +#endif /* CONFIG_ARM64 */
> > 
> 
> Again, just make the pci_common_init_dev() call #ifdef CONFIG_ARM, and move
> the generic case after it, outside of the #ifdef.

I went through the code quickly but I think we can (and should) remove
this quite ugly ifdeffery altogether. Most of the functionality in
pci_common_init_dev() can be implemented through the common PCI API (and this
would make this driver arch agnostic as it should be), I will go through ARM32
PCI bios code to check what is executed in detail in pci_common_init_dev() and
make sure that we follow those initialization steps in the resulting probe code
for this PCI generic host controller driver.

Lorenzo

