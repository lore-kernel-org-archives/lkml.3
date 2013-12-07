Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3LGL6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 06:58:44 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:60342 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3LGL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 06:58:39 -0500
Date: Sat, 7 Dec 2013 09:58:29 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, paulus@samba.org,
        shangw@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernv: fix VFIO support with PHB3
Message-ID: <20131207115829.GA32319@oc0268524204.ibm.com>
References: <1386332504-18339-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <52A272C4.1060303@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A272C4.1060303@ozlabs.ru>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120711-1524-0000-0000-00000835E3BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 11:58:44AM +1100, Alexey Kardashevskiy wrote:
> On 12/06/2013 11:21 PM, Thadeu Lima de Souza Cascardo wrote:
> > I have recently found out that no iommu_groups could be found under
> > /sys/ on a P8. That prevents PCI passthrough from working.
> > 
> > During my investigation, I found out there seems to be a missing
> > iommu_register_group for PHB3. The following patch seems to fix the
> > problem. After applying it, I see iommu_groups under
> > /sys/kernel/iommu_groups/, and can also bind vfio-pci to an adapter,
> > which gives me a device at /dev/vfio/.
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> > ---
> >  arch/powerpc/platforms/powernv/pci-ioda.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> > index 084cdfa..2c6d173 100644
> > --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> > +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> > @@ -720,6 +720,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
> >  		tbl->it_type = TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE;
> >  	}
> >  	iommu_init_table(tbl, phb->hose->node);
> > +	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
> >  
> >  	if (pe->pdev)
> >  		set_iommu_table_base(&pe->pdev->dev, tbl);
> 
> 
> This does not seem absolutely right - normally set_iommu_table_base() is
> replaced with set_iommu_table_base_and_group() or you will not see some
> devices in a group and this may make VFIO unhappy.

Alexey,

Your patch "[PATCH v9] PPC: POWERNV: move iommu_add_device earlier" is
not upstream yet. It calls set_iommu_table_base_and_group properly.
However, without calling iommu_register_group, there is no group to add
the device to.

Compare to pnv_pci_ioda_setup_dma_pe which calls iommu_register_group
too. My patch fixes this discrepancy between IODA and IODA2.

Regards.
Cascardo.

> 
> But - if every single device gets assigned to some group, then we can push
> this to Frobisher and let people test in on power8.
> 
> 
> 
> -- 
> Alexey

