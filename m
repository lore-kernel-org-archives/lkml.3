Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIIN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:57:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaIIN5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:57:15 -0400
Date: Tue, 9 Sep 2014 15:57:10 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 04/12] iommu/arm-smmu: Convert to iommu_capable() API
 function
Message-ID: <20140909135710.GE2519@suse.de>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-5-git-send-email-joro@8bytes.org>
 <20140908165136.GW26030@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908165136.GW26030@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Mon, Sep 08, 2014 at 05:51:36PM +0100, Will Deacon wrote:
> On Fri, Sep 05, 2014 at 11:52:56AM +0100, Joerg Roedel wrote:
> >  	switch (cap) {
> >  	case IOMMU_CAP_CACHE_COHERENCY:
> > -		return features & ARM_SMMU_FEAT_COHERENT_WALK;
> > +		/*
> > +		 * Use ARM_SMMU_FEAT_COHERENT_WALK as an indicator on whether
> > +		 * the SMMU can force coherency on the DMA transaction. If it
> > +		 * supports COHERENT_WALK it must be behind a coherent
> > +		 * interconnect.
> > +		 * A domain can be attached to any SMMU, so to reliably support
> > +		 * IOMMU_CAP_CACHE_COHERENCY all SMMUs in the system need to be
> > +		 * behind a coherent interconnect.
> > +		 */
> 
> I don't think we should rely on the SMMU's advertisement of the coherent
> table walk to mean anything other than `the SMMU can emit cacheable page
> table walks'. The actual walker is a separate observer, and could have a
> different route to memory than transactions flowing through the SMMU.

Okay, so this should be advertised via DT then.

> In reality, all we can report here is what the SMMU (as opposed to the rest
> of the system) is capable of. The SMMU can always emit cacheable
> transactions for a master if a stage-1 translation is in use so, without
> extending the device-tree binding, we should report true here
> unconditionally.

Sounds more like we should return false here unconditionally until we
have a reliable way to tell whether this feature is available, no? When
we return true the user of the IOMMU-API might rely on coherency that is
not available.

> An alternative is to extend the device-tree bindings to have something like
> "dma-coherent" for the SMMU node, which would imply that the interconnect is
> configured to honour snoops from the SMMU into the CPU caches. We might want
> an additional property on top of that to indicate that the table walker is
> also coherent (and we could check this against our ARM_SMMU_FEAT_COHERENT_WALK
> flag)

Sounds like a good idea, as long as there is no other way to detect
this.


	Joerg

