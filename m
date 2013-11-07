Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3KGBtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:49:45 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:45834 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3KGBto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:49:44 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 20:49:43 EST
Date: Wed, 6 Nov 2013 21:44:04 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.
Message-ID: <20131107014404.GB27725@andromeda.dapyr.net>
References: <1383769943-22636-1-git-send-email-konrad.wilk@oracle.com> <20131106212747.GA23133@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106212747.GA23133@phenom.dumpdata.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:27:47PM -0500, Konrad Rzeszutek Wilk wrote:
> Resending it to LKML.
> On Wed, Nov 06, 2013 at 03:32:23PM -0500, Konrad Rzeszutek Wilk wrote:
> > The PCI MMCONFIG area is usually reserved via the E820 so the Xen hypervisor
> > is aware of these regions. But they can also be enumerated in the ACPI
> > DSDT which means the hypervisor won't know of them until the initial
> > domain informs it of via PHYSDEVOP_pci_mmcfg_reserved.
> > 
> > This is what this patch does for all of the MCFG regions that the
> > initial domain is aware of (E820 enumerated and ACPI).
> > 
> > Reported-by:  Santosh Jodh <Santosh.Jodh@citrix.com>
> > CC: Jan Beulich <JBeulich@suse.com>
> > CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > CC: David Vrabel <david.vrabel@citrix.com>
> > CC: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > [v1: Redid it a bit]
> > [v2: Dropped the P2M 1-1 setting]
> > [v3: Check for Xen in-case we are running under baremetal]
> > ---
> >  drivers/xen/pci.c               | 45 +++++++++++++++++++++++++++++++++++++++++
> >  include/xen/interface/physdev.h | 11 ++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
> > index 18fff88..0331fe9 100644
> > --- a/drivers/xen/pci.c
> > +++ b/drivers/xen/pci.c
> > @@ -26,6 +26,7 @@
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> >  #include "../pci/pci.h"
> > +#include <asm/pci_x86.h>
> >  
> >  static bool __read_mostly pci_seg_supported = true;
> >  
> > @@ -192,3 +193,47 @@ static int __init register_xen_pci_notifier(void)
> >  }
> >  
> >  arch_initcall(register_xen_pci_notifier);
> > +

The build-bot tells me that I should also wrap these with

#ifdef CONFIG_PCI_MMCONFIG
> > +static int __init xen_mcfg_late(void)
> > +{
> > +	struct pci_mmcfg_region *cfg;
> > +	int rc;
> > +
> > +	if (!xen_initial_domain())
> > +		return 0;
> > +
> > +	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
> > +		return 0;
> > +
> > +	if (list_empty(&pci_mmcfg_list))
> > +		return 0;
> > +
> > +	/* Check whether they are in the right area. */
> > +	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
> > +		struct physdev_pci_mmcfg_reserved r;
> > +
> > +		r.address = cfg->address;
> > +		r.segment = cfg->segment;
> > +		r.start_bus = cfg->start_bus;
> > +		r.end_bus = cfg->end_bus;
> > +		r.flags = XEN_PCI_MMCFG_RESERVED;
> > +
> > +		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pci_mmcfg_reserved, &r);
> > +		switch (rc) {
> > +		case 0:
> > +		case -ENOSYS:
> > +			continue;
> > +
> > +		default:
> > +			pr_warn("Failed to report MMCONFIG reservation"
> > +				" state for %s to hypervisor"
> > +				" (%d)\n",
> > +				cfg->name, rc);
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +/*
> > + * Needs to be done after acpi_init which are subsys_initcall.
> > + */
> > +subsys_initcall_sync(xen_mcfg_late);

#endif
> > diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> > index 7000bb1..42721d1 100644
> > --- a/include/xen/interface/physdev.h
> > +++ b/include/xen/interface/physdev.h
> > @@ -231,6 +231,17 @@ struct physdev_get_free_pirq {
> >  #define XEN_PCI_DEV_VIRTFN             0x2
> >  #define XEN_PCI_DEV_PXM                0x4
> >  
> > +#define XEN_PCI_MMCFG_RESERVED         0x1
> > +
> > +#define PHYSDEVOP_pci_mmcfg_reserved    24
> > +struct physdev_pci_mmcfg_reserved {
> > +    uint64_t address;
> > +    uint16_t segment;
> > +    uint8_t start_bus;
> > +    uint8_t end_bus;
> > +    uint32_t flags;
> > +};
> > +
> >  #define PHYSDEVOP_pci_device_add        25
> >  struct physdev_pci_device_add {
> >      /* IN */
> > -- 
> > 1.8.3.1
> > 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
