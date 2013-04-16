Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935277Ab3DPAoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:44:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55372 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3DPAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:44:11 -0400
Date: Mon, 15 Apr 2013 20:43:52 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130416004352.GA10615@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
 <CAE9FiQU_4ix-mc3aL6nrZD6fexm_52jV-=W-But=eTfx6=U0uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU_4ix-mc3aL6nrZD6fexm_52jV-=W-But=eTfx6=U0uA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 04:02:56PM -0700, Yinghai Lu wrote:
> On Mon, Apr 15, 2013 at 3:41 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > A few years back intel published a spec update:
> > http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> >
><snip>
> > diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> > index 3755ef4..ef4ac6c 100644
> > --- a/arch/x86/kernel/early-quirks.c
> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -18,6 +18,7 @@
> >  #include <asm/apic.h>
> >  #include <asm/iommu.h>
> >  #include <asm/gart.h>
> > +#include "../drivers/iommu/irq_remapping.h"
> 
> looks ugly.
> 
Yes, but I think its acceptible given that it makes sense to me to define the
irq_remap_broken flag in the common driver code.  We can certainly move the
header around, but I'd much rather do that in a separate patch.

> >
> >  static void __init fix_hypertransport_config(int num, int slot, int func)
> >  {
> > @@ -192,6 +193,27 @@ static void __init ati_bugs_contd(int num, int slot, int func)
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_IRQ_REMAP
> > +static void __init intel_remapping_check(int num, int slot, int func)
> > +{
> > +       u8 revision;
> > +
> > +       revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
> > +
> > +       /*
> > +        * Revision 0x13 of this chipset supports irq remapping
> > +        * but has an erratum that breaks its behavior, flag it as such
> > +        */
> > +       if (revision == 0x13)
> > +               irq_remap_broken = 1;
> 
> change to more specific like:
> 
> intel_55xx_rev13_found?
> 
No.  This was discussed previously, and the consensus was that we
can use a generic name, should other chips have simmilarly broken functionality.

><snip>
> >
> >  int disable_irq_remap;
> > +int irq_remap_broken;
> >  int disable_sourceid_checking;
> >  int no_x2apic_optout;
> >
> > diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
> > index ecb6376..90c4dae 100644
> > --- a/drivers/iommu/irq_remapping.h
> > +++ b/drivers/iommu/irq_remapping.h
> > @@ -32,6 +32,7 @@ struct pci_dev;
> >  struct msi_msg;
> >
> >  extern int disable_irq_remap;
> > +extern int irq_remap_broken;
> >  extern int disable_sourceid_checking;
> >  extern int no_x2apic_optout;
> >  extern int irq_remapping_enabled;
> > @@ -89,6 +90,7 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
> >
> >  #define irq_remapping_enabled 0
> >  #define disable_irq_remap     1
> > +#define irq_remap_broken      0
> 
> this one is needed
> 
Um, yes?  I think you mean to say its not needed, since all the users of this
check are only in code thats compiled conditionally with CONFIG_IRQ_REMAP.
You're correct, but I like to have it there for completness, should that change
in the future.

Neil

