Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaDVNAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:00:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38065 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaDVM74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:59:56 -0400
Date: Tue, 22 Apr 2014 13:59:50 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Marek Vasut'" <marex@denx.de>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Byungho An'" <bh74.an@samsung.com>
Subject: Re: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
Message-ID: <20140422125950.GG865@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Jingoo Han <jg1.han@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>,
	'Mohit KUMAR DCG' <Mohit.KUMAR@st.com>,
	'Pratyush Anand' <pratyush.anand@st.com>,
	'Marek Vasut' <marex@denx.de>, 'Richard Zhu' <r65037@freescale.com>,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	'Byungho An' <bh74.an@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
 <20140416165724.GG7802@e106497-lin.cambridge.arm.com>
 <16730530.rJ9T0MsYmt@wuerfel>
 <000001cf5d04$982a6000$c87f2000$%han@samsung.com>
MIME-Version: 1.0
In-Reply-To: <000001cf5d04$982a6000$c87f2000$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 22 Apr 2014 13:00:06.0242 (UTC) FILETIME=[C87EBC20:01CF5E2A]
X-MC-Unique: 114042213595322301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 02:54:12AM +0100, Jingoo Han wrote:
> On Thursday, April 17, 2014 3:26 AM, Arnd Bergmann wrote:
> 
> (+cc Mohit KUMAR, Pratyush Anand, Marek Vasut, Richard Zhu,
>       Kishon Vijay Abraham I, Byungho An)
> > 
> > On Wednesday 16 April 2014 17:57:24 Liviu Dudau wrote:
> > > Jingoo,
> > >
> > > Thanks for taking a stab at trying to convert a host bridge
> > > driver to use the new generic host bridge code.
> > >
> > > I do however have concerns on the direction you took. You have split
> > > your driver in two, depending on whether it was CONFIG_ARM or CONFIG_ARM64,
> > > even if (with my series) it should be no reason why the host bridge
> > > driver should not work on other architectures as well once they are
> > > converted.
> > 
> > Right.
> > 
> > > Also, some of the functions that you use have identical names but different
> > > signatures depending on what arch you have selected. This is really bad
> > > in my books!
> > 
> > It's only the sys_to_pcie() function, right?
> > 
> > You can probably simplify that to take a void pointer and have only one line
> > difference.
> 
> Do you mean the following?
> Would you give me more detailed advice?
> 
> static inline struct pcie_port *sys_to_pcie(void *sys)
> {
> 	struct pcie_port *pp
> 
> #ifdef CONFIG_ARM
> 	pp = ((struct pci_sys_data *)sys)->private_data;
> #else
> 	pp = (struct pcie_port *)sys;
> #endif
> 	return pp;
> }

Yes, that would be better.

> 
> > 
> > > What about creating functions that use my series directly if CONFIG_ARM64 is
> > > defined (or any CONFIG_ you want to create for your driver that you select
> > > from CONFIG_ARM64) and otherwise implement the CONFIG_ARM version? That
> > > way your driver will call only one API without any #ifdef and when arm code
> > > gets converted you drop your adaptation functions. Or (better yet), have a
> > > stab at converting bios32 (Rob Herring has already provided some hints on
> > > how to do it for arch/arm).
> 
> To: Liviu Dudau
> 
> Sorry, but I will not implement this.
> At first, you had to think the compatibility with ARM32 PCIe.

I did. I've also looked at the other implementations and have realised how unique
and baroque the arm32 version is. If I would've implemented that version for arm64
(Will Deacon had a stab internally) I would have to remove all the quirks from
the arch code and all that is left is something very similar to what you currently
have. But that would've made that code only usable by ARM platforms and no one
else. Why being so narrow?

> Why do you want other engineers to take this load?

I don't want to, but you are the first scratching that itch. This is your path to
glory!

> 
> > 
> > That would of course be best.
> > 
> > > To give an example on how things are not going well in your version (not obvious
> > > from your patch, but you can see it once you apply it): dw_pcie_host_init()
> > > will still carry the handcoded version of DT parsing and that is not guarded
> > > against CONFIG_ARM64 being defined, where the parsing will happen again
> > > when you call of_create_pci_host_bridge().
> > 
> > How about making the generic DT parsing code from of_create_pci_host_bridge()
> > an exported function that can be called by drivers that don't use
> > of_create_pci_host_bridge?
> 
> Do you mean that of_create_pci_host_bridge() should be used for both ARM32
> and ARM64 cases?

Yes, ultimately. 

> 
> > 
> > > Speaking of the handcoded DT parsing of resources: you are using restype == 0
> > > as a way of selecting config space, *and then split the range size into two
> > > halves*. From what Jason Gunthorpe and Arnd were saying, config ranges in the DT
> > > tree should only be used for ECAM space, so no split is allowed.
> > >
> > > Arnd, are you allowing this non-standard use to creep in the bindings?
> > 
> > I fear it's too late to change that now. In retrospect we probably shoulnd't
> > have defined the binding like that.
> > 
> > Overall, my impression of the patch is that it should be possible to do
> > the same with much fewer #ifdefs by first rearranging the code in one patch
> > and then doing another patch on top to add the generic arm64 support.
> 
> I will try to reduce #ifdefs as possible.

Thanks!

Best regards,
Liviu

> 
> Best regards,
> Jingoo Han
> 
> > 
> > > > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > > > index 6d23d8c..fac0440 100644
> > > > --- a/drivers/pci/host/pcie-designware.c
> > > > +++ b/drivers/pci/host/pcie-designware.c
> > > > @@ -65,14 +65,27 @@
> > > >  #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
> > > >  #define PCIE_ATU_UPPER_TARGET		0x91C
> > > >
> > > > +#ifdef CONFIG_ARM
> > > >  static struct hw_pci dw_pci;
> > > > +#endif
> > > >
> > > >  static unsigned long global_io_offset;
> > > >
> > > > +#ifdef CONFIG_ARM
> > > >  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
> > > >  {
> > > >  	return sys->private_data;
> > > >  }
> > > > +#endif
> > > > +
> > > > +#ifdef CONFIG_ARM64
> > > > +static inline struct pcie_port *sys_to_pcie(struct pcie_port *pp)
> > > > +{
> > > > +	return pp;
> > > > +}
> > > > +
> > > > +static struct pci_ops dw_pcie_ops;
> > > > +#endif
> > > >
> > > >  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
> > > >  {
> > > > @@ -381,7 +394,9 @@ static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
> > > >  {
> > > >  	irq_set_chip_and_handler(irq, &dw_msi_irq_chip, handle_simple_irq);
> > > >  	irq_set_chip_data(irq, domain->host_data);
> > > > +#ifdef CONFIG_ARM
> > > >  	set_irq_flags(irq, IRQF_VALID);
> > > > +#endif
> > > >
> > > >  	return 0;
> > > >  }
> > > > @@ -397,6 +412,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > > >  	struct of_pci_range_parser parser;
> > > >  	u32 val;
> > > >  	int i;
> > > > +#ifdef CONFIG_ARM64
> > > > +	struct pci_host_bridge *bridge;
> > > > +	resource_size_t lastbus;
> > > > +#endif
> > > >
> > > >  	if (of_pci_range_parser_init(&parser, np)) {
> > > >  		dev_err(pp->dev, "missing ranges property\n");
> > > > @@ -489,6 +508,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > > >  	val |= PORT_LOGIC_SPEED_CHANGE;
> > > >  	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
> > > >
> > > > +#ifdef CONFIG_ARM
> > > >  	dw_pci.nr_controllers = 1;
> > > >  	dw_pci.private_data = (void **)&pp;
> > > >
> > > > @@ -497,6 +517,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > > >  #ifdef CONFIG_PCI_DOMAINS
> > > >  	dw_pci.domain++;
> > > >  #endif
> > > > +#endif
> > > > +
> > > > +#ifdef CONFIG_ARM64
> > > > +	bridge = of_create_pci_host_bridge(pp->dev, &dw_pcie_ops, pp);
> > > > +	if (IS_ERR_OR_NULL(bridge))
> > > > +		return PTR_ERR(bridge);
> > > > +
> > > > +	lastbus = pci_rescan_bus(bridge->bus);
> > > > +	pci_bus_update_busn_res_end(bridge->bus, lastbus);
> > > > +#endif
> > > >
> > > >  	return 0;
> > > >  }
> > > > @@ -695,6 +725,7 @@ static struct pci_ops dw_pcie_ops = {
> > > >  	.write = dw_pcie_wr_conf,
> > > >  };
> > > >
> > > > +#ifdef CONFIG_ARM
> > > >  static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
> > > >  {
> > > >  	struct pcie_port *pp;
> > > > @@ -758,6 +789,7 @@ static struct hw_pci dw_pci = {
> > > >  	.map_irq	= dw_pcie_map_irq,
> > > >  	.add_bus	= dw_pcie_add_bus,
> > > >  };
> > > > +#endif /* CONFIG_ARM */
> > > >
> > > >  void dw_pcie_setup_rc(struct pcie_port *pp)
> > 
> 
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

