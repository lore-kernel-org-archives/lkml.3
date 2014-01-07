Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaAGFVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaAGFVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:21:02 -0500
Message-ID: <1389069604.3209.110.camel@bling.home>
Subject: Re: [PATCH] iommu/intel: SNP bit is not dependent on iommu domain
 coherency
From: Alex Williamson <alex.williamson@redhat.com>
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Date: Mon, 06 Jan 2014 21:40:04 -0700
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0A9A31C2@SHSMSX104.ccr.corp.intel.com>
References: <20131029162126.23362.58786.stgit@bling.home>
	 <1387821199.30327.107.camel@bling.home>
	 <A9667DDFB95DB7438FA9D7D576C3D87E0A9A31C2@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 00:54 +0000, Zhang, Yang Z wrote:
> Alex Williamson wrote on 2013-12-24:
> > David,
> > 
> > Any comments on this patch?  Thanks,
> > 
> 
> Hi Alex,
> 
> There do have some IOMMUs will treat SNP bit in the PTE as reserved
> (0) and will cause a reserved field violation fault if it is set but
> hardware not support snoop-control(bit 7 in ECAP_REG is 0). So your
> patch seems wrong to me.

Thanks for the reply Yang.  So effectively IOMMU_CACHE (SNP) is unusable
on intel-iommu if we want a domain that can manage any device in the
system, right?  We have no way to atomically change the SNP bit across a
domain so the only chance for enabling it is if all the DRHD units
support snoop-control, but then a hot-added DRHD makes that impossible
to predict.  Is there any way we can make intel-iommu "do the right
thing"?  These are rather low-level implementation details of
intel-iommu that I'd rather not know about as a user of the IOMMU API.
Thanks,

Alex  

> > On Tue, 2013-10-29 at 10:21 -0600, Alex Williamson wrote:
> >> The setting of the SNP bit in the intel-iommu page tables should not
> >> be dependent on the current capability of the iommu domain.  The
> >> current VT-d spec (2.2) indicates the SNP bit is "treated as
> >> reserved[0] by hardware implementations not supporting Snoop Control".
> >> Furthermore, section 3.7.3 indicates:
> >> 
> >>   If the Snoop Control (SC) field in extended capability Register is
> >>   reported as 0, snoop behavior for access to the page mapped through
> >>   second-level translation is determined by the no-snoop attribute in
> >>   the request.
> >> This all seems to indicate that hardware incapable of Snoop Control
> >> will handle the SNP bit as zero regardless of the value stored in
> >> the PTE.
> >> 
> >> The trouble with the current implementation is that mapping flags
> >> depend on the state of the iommu domain at the time of the mapping,
> >> yet no attempt is made to update existing mappings when the iommu
> >> domain composition changes.  This leaves the iommu domain in a state
> >> where some mappings may enforce coherency, others do not, and the
> >> user of the IOMMU API has no ability to later enable the desired
> >> flags atomically with respect to DMA.
> >> 
> >> If we always honor the IOMMU_CACHE flag then an IOMMU API user who
> >> specifies IOMMU_CACHE for all mappings can assume that the coherency
> >> of the mappings within a domain follow the coherency capability of
> >> the domain itself.
> >> 
> >> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >> ---
> >>  drivers/iommu/intel-iommu.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> diff --git a/drivers/iommu/intel-iommu.c
> >> b/drivers/iommu/intel-iommu.c index 15e9b57..c46c6a6 100644
> >> --- a/drivers/iommu/intel-iommu.c
> >> +++ b/drivers/iommu/intel-iommu.c
> >> @@ -4084,7 +4084,7 @@ static int intel_iommu_map(struct iommu_domain
> > *domain,
> >>  		prot |= DMA_PTE_READ;
> >>  	if (iommu_prot & IOMMU_WRITE)
> >>  		prot |= DMA_PTE_WRITE;
> >> -	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
> >> +	if (iommu_prot & IOMMU_CACHE)
> >>  		prot |= DMA_PTE_SNP;
> >>  
> >>  	max_addr = iova + size;
> > 
> >
> 
> 
> Best regards,
> Yang
> 
> 



