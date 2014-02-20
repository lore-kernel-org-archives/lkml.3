Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaBTSR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:17:29 -0500
Received: from smtp.citrix.com ([66.165.176.89]:12486 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbaBTSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:17:27 -0500
X-IronPort-AV: E=Sophos;i="4.97,513,1389744000"; 
   d="scan'208";a="104423979"
Date: Thu, 20 Feb 2014 18:17:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v9] xen/grant-table: Avoid m2p_override during mapping
In-Reply-To: <53063D2B.1040502@citrix.com>
Message-ID: <alpine.DEB.2.02.1402201746560.15812@kaball.uk.xensource.com>
References: <1392238453-26147-1-git-send-email-zoltan.kiss@citrix.com> <alpine.DEB.2.02.1402161828380.4307@kaball.uk.xensource.com> <5301F74E.3070107@citrix.com> <alpine.DEB.2.02.1402201724430.15812@kaball.uk.xensource.com> <53063D2B.1040502@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Zoltan Kiss wrote:
> On 20/02/14 17:26, Stefano Stabellini wrote:
> > On Mon, 17 Feb 2014, Zoltan Kiss wrote:
> > > On 16/02/14 18:36, Stefano Stabellini wrote:
> > > > On Wed, 12 Feb 2014, Zoltan Kiss wrote:
> > > > > diff --git a/arch/arm/include/asm/xen/page.h
> > > > > b/arch/arm/include/asm/xen/page.h
> > > > > index e0965ab..4eaeb3f 100644
> > > > > --- a/arch/arm/include/asm/xen/page.h
> > > > > +++ b/arch/arm/include/asm/xen/page.h
> > > > > @@ -97,16 +97,15 @@ static inline pte_t *lookup_address(unsigned long
> > > > > address, unsigned int *level)
> > > > >    	return NULL;
> > > > >    }
> > > > > 
> > > > > -static inline int m2p_add_override(unsigned long mfn, struct page
> > > > > *page,
> > > > > -		struct gnttab_map_grant_ref *kmap_op)
> > > > > -{
> > > > > -	return 0;
> > > > > -}
> > > > > -
> > > > > -static inline int m2p_remove_override(struct page *page, bool
> > > > > clear_pte)
> > > > > -{
> > > > > -	return 0;
> > > > > -}
> > > > > +extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref
> > > > > *map_ops,
> > > > > +				   struct gnttab_map_grant_ref
> > > > > *kmap_ops,
> > > > > +				   struct page **pages, unsigned int
> > > > > count,
> > > > > +				   bool m2p_override);
> > > > > +
> > > > > +extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref
> > > > > *unmap_ops,
> > > > > +				     struct gnttab_map_grant_ref
> > > > > *kmap_ops,
> > > > > +				     struct page **pages, unsigned int
> > > > > count,
> > > > > +				     bool m2p_override);
> > > > 
> > > > Much much better.
> > > > The only comment I have is about this m2p_override boolean parameter.
> > > > m2p_override is now meaningless in this context, what we really want to
> > > > let the arch specific implementation know is whether the mapping is a
> > > > kernel only mapping or a userspace mapping.
> > > > Testing for kmap_ops != NULL might even be enough, but it would not
> > > > improve the interface.
> > > gntdev is the only user of this, the kmap_ops parameter there is:
> > > use_ptemod ? map->kmap_ops + offset : NULL
> > > where:
> > > use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);
> > > So I think we can't rely on kmap_ops to decide whether we should
> > > m2p_override
> > > or not.
> > > 
> > > > Is it possible to realize if the mapping is a userspace mapping by
> > > > checking for GNTMAP_application_map in map_ops?
> > > > Otherwise I would keep the boolean and rename it to user_mapping.
> > > Sounds better, but as far as I see gntdev set that flag in
> > > find_grant_ptes,
> > > which is called only
> > > 
> > > if (use_ptemod) {
> > > 	err = apply_to_page_range(vma->vm_mm, vma->vm_start,
> > > 				  vma->vm_end - vma->vm_start,
> > > 				  find_grant_ptes, map);
> > > 
> > > So if xen_feature(XENFEAT_auto_translated_physmap), we don't have
> > > kmap_ops,
> > > and GNTMAP_application_map is not set as well, but I guess we still need
> > > m2p_override. Or not? I'm a bit confused, maybe because of Monday ...
> > 
> > If xen_feature(XENFEAT_auto_translated_physmap) we shouldn't need the
> > m2p_override.
> > 
> 
> So it's safe to assume that we need m2p_override only if kmap_ops != NULL, and
> we can avoid the extra bool parameter, is that correct? At least with the
> current users of grant mapping it seems to be true.
> In which case we don't need the wrappers for gnttab_[un]map_refs as well.
> Actually the most of m2p_add/remove_override takes effect only if there is a
> kmap_op parameter, but what about the rest of the code there?

It is safe to assume that we only need the m2p_override if
!xen_feature(XENFEAT_auto_translated_physmap).
I wouldn't make any assumptions on kmap_ops != NULL.

I would remove the bool m2p_override parameter completely and determine
whether we need to call the m2p_override functions from the x86
implementation of set/clear_foreign_p2m_mapping by checking
xen_feature(XENFEAT_auto_translated_physmap).

David, does it seem reasonable to you?
