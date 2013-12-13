Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3LMPfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:35:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:18149 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3LMPfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:35:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,479,1384300800"; 
   d="scan'208";a="84319757"
Date: Fri, 13 Dec 2013 15:34:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>
Subject: Re: [PATCH V10 05/14] xen/pvh: balloon and grant changes.
In-Reply-To: <20131213145937.GB4770@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312131530030.8667@kaball.uk.xensource.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312131147230.8667@kaball.uk.xensource.com> <20131213143620.GH2923@phenom.dumpdata.com>
 <alpine.DEB.2.02.1312131448340.8667@kaball.uk.xensource.com> <20131213145937.GB4770@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Konrad Rzeszutek Wilk wrote:
> On Fri, Dec 13, 2013 at 02:49:15PM +0000, Stefano Stabellini wrote:
> > On Fri, 13 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Dec 13, 2013 at 11:56:31AM +0000, Stefano Stabellini wrote:
> > > > On Thu, 12 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > > 
> > > > > For balloon changes we skip setting of local P2M as it's updated
> > > > > in Xen. For grant, the shared grant frame is the PFN and not MFN,
> > > > > hence its mapped via the same code path as HVM.
> > > > > 
> > > > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > > [v1: Rebase on v3.7-rc3]
> > > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > > CC: <stefano.stabellini@eu.citrix.com>
> > > > > Conflicts:
> > > > > 	drivers/xen/balloon.c
> > > > > [v2: Rebase on v3.13-rc3 has lot of ARM changes.]
> > > > > ---
> > > > >  drivers/xen/balloon.c     |   37 ++++++++++++++++++++-----------------
> > > > >  drivers/xen/gntdev.c      |    3 ++-
> > > > >  drivers/xen/grant-table.c |   25 ++++++++++++++++++++++---
> > > > >  3 files changed, 44 insertions(+), 21 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > > > > index 55ea73f..0e9875a 100644
> > > > > --- a/drivers/xen/balloon.c
> > > > > +++ b/drivers/xen/balloon.c
> > > > > @@ -354,7 +354,9 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
> > > > >  
> > > > >  #ifdef CONFIG_XEN_HAVE_PVMMU
> > > > >  		/* Link back into the page tables if not highmem. */
> > > > > -		if (xen_pv_domain() && !PageHighMem(page)) {
> > > > > +		if (xen_pv_domain() && !PageHighMem(page) &&
> > > > > +		    !xen_feature(XENFEAT_auto_translated_physmap)) {
> > > > > +
> > > > >  			int ret;
> > > > >  			ret = HYPERVISOR_update_va_mapping(
> > > > >  				(unsigned long)__va(pfn << PAGE_SHIFT),
> > > > > @@ -411,28 +413,29 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
> > > > >  
> > > > >  		scrub_page(page);
> > > > >  
> > > > > -		/*
> > > > > -		 * Ballooned out frames are effectively replaced with
> > > > > -		 * a scratch frame.  Ensure direct mappings and the
> > > > > -		 * p2m are consistent.
> > > > > -		 */
> > > > > -		scratch_page = get_balloon_scratch_page();
> > > > > +		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> > > > > +			unsigned long p;
> > > > > +
> > > > > +			/*
> > > > > +			 * Ballooned out frames are effectively replaced with
> > > > > +			 * a scratch frame.  Ensure direct mappings and the
> > > > > +			 * p2m are consistent.
> > > > > +			 */
> > > > > +			scratch_page = get_balloon_scratch_page();
> > > > >  #ifdef CONFIG_XEN_HAVE_PVMMU
> > > > > -		if (xen_pv_domain() && !PageHighMem(page)) {
> > > > > -			ret = HYPERVISOR_update_va_mapping(
> > > > > -				(unsigned long)__va(pfn << PAGE_SHIFT),
> > > > > -				pfn_pte(page_to_pfn(scratch_page),
> > > > > +			if (xen_pv_domain() && !PageHighMem(page)) {
> > > > > +				ret = HYPERVISOR_update_va_mapping(
> > > > > +					(unsigned long)__va(pfn << PAGE_SHIFT),
> > > > > +					pfn_pte(page_to_pfn(scratch_page),
> > > > >  					PAGE_KERNEL_RO), 0);
> > > > > -			BUG_ON(ret);
> > > > > -		}
> > > > > +				BUG_ON(ret);
> > > > > +			}
> > > > >  #endif
> > > > > -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> > > > > -			unsigned long p;
> > > > >  			p = page_to_pfn(scratch_page);
> > > > >  			__set_phys_to_machine(pfn, pfn_to_mfn(p));
> > > > > -		}
> > > > > -		put_balloon_scratch_page();
> > > > >  
> > > > > +			put_balloon_scratch_page();
> > > > > +		}
> > > > >  		balloon_append(pfn_to_page(pfn));
> > > > >  	}
> > > > 
> > > > These changes to balloon.c are similar to my patch but:
> > > > 
> > > > - they don't prevent set_phys_to_machine from being called by
> > > > increase_reservation for auto_translated guests
> > > 
> > > <nods>
> > > > 
> > > > - they don't prevent wasteful balloon_scratch_page from being allocated
> > > > for auto_translated guests
> > > 
> > > <nods>
> > > > 
> > > > I think that it would be best to take my patch instead.
> > > 
> > > Lets focus the review on your patch then and have it part of this
> > > series. 
> > 
> > OK, but keep in mind that Xen on ARMv8 is currently broken without that
> > patch.
> 
> Hm. We could have another patch to just disable BALLOON on ARMv8 :-)
> 
> The question you have to ask - if your patch causes regression are you
> OK tracking/fixing it over the holidays :-) If yes, then yes - we can
> put that in v3.13-rc3 to make it work properly on ARMv8.

Damn, that was a good argument.
After thinking more about it, I think that I, or a member of my team,
can actually fix possible bugs during the holidays. Especially
considering that the patch doesn't alter the behavior of PV guests.

So in short, yes :)
