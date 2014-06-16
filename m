Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaFPPNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:13:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932088AbaFPPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:13:34 -0400
Date: Mon, 16 Jun 2014 16:13:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Message-ID: <20140616151329.GQ16758@arm.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
 <20140608103129.GC3279@lvm>
 <20140616145344.GD18986@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616145344.GD18986@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:53:44PM +0100, Joerg Roedel wrote:
> On Sun, Jun 08, 2014 at 12:31:29PM +0200, Christoffer Dall wrote:
> > On Thu, Jun 05, 2014 at 07:03:12PM +0200, Antonios Motakis wrote:
> > > With an ARM SMMU, interrupt remapping should always be safe from the
> > > SMMU's point of view, as it is properly handled by the GIC.
> > > 
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > ---
> > >  drivers/iommu/arm-smmu.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> > > index 15ab2af..ff29402 100644
> > > --- a/drivers/iommu/arm-smmu.c
> > > +++ b/drivers/iommu/arm-smmu.c
> > > @@ -1544,7 +1544,7 @@ static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
> > >  	if (smmu_domain->root_cfg.smmu->features & ARM_SMMU_FEAT_COHERENT_WALK)
> > >  		caps |= IOMMU_CAP_CACHE_COHERENCY;
> > >  
> > > -	caps |= IOMMU_CAP_NOEXEC;
> > > +	caps |= IOMMU_CAP_NOEXEC | IOMMU_CAP_INTR_REMAP;
> > >  
> > >  	return !!(cap & caps);
> > >  }
> > > -- 
> > > 1.8.3.2
> > > 
> > What does IOMMU_CAP_INTR_REMAP signify exactly?  Is there docs/examples
> > somewhere I can look at?  (A quick scan of the Linux souce code doesn't
> > reveal much, and I'm not sure if this is purely MSI related or what...)
> 
> The flag was introduced for x86 IOMMUs to detect whether an IOMMU in the
> system has and enables interrupt remapping to allow safe device
> assignment to KVM guests. Without interrupt remapping a malicious guest
> could attack the host with MSIs from the attached device.
> 
> How are PCI MSIs implemented on ARM with SMMU and GIC enabled. MSIs are
> only memory dma transactions in the end, is it guaranteed on ARM that a
> device only sends MSI transactions it is allowed to?

MSIs look just like memory accesses made by the device, so the SMMU will
translate them to point at the GIC ITS (doorbell). The ITS then has tables
to work out how to route the MSI.

So, if IOMMU_CAP_INTR_REMAP is simply supposed to indicate that the SMMU can
translate MSIs to point somewhere else, then the ARM SMMU can always do it.
If it's supposed to indicate that the actual MSI payload can be
filtered/routed, then that requires the GIC ITS.

The part I'm unsure of is how VFIO knows where to map the MSIs to. That
requires knowledge of the physical and virtual doorbell pages -- is that
discoverable in the API?

Will
