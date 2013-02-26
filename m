Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab3B0BDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:03:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760226Ab3BZX5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:48 -0500
MIME-Version: 1.0
Message-ID: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
Date: Tue, 26 Feb 2013 15:57:35 -0800 (PST)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- hpa@zytor.com wrote:

> On 02/26/2013 02:56 PM, Boris Ostrovsky wrote:
> > When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
> > kernel_map_pages() are not made visible (via TLB flush) immediately
> if lazy
> > MMU is on. In environments that support lazy MMU (e.g. Xen) this may
> lead to
> > fatal page faults, for example, when zap_pte_range() needs to
> allocate pages
> > in __tlb_remove_page() -> tlb_next_batch().
> > 
> > Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > ---
> >  arch/x86/mm/pageattr.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index ca1f1c2..7b3216e 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -1369,6 +1369,8 @@ void kernel_map_pages(struct page *page, int
> numpages, int enable)
> >  	 * but that can deadlock->flush only current cpu:
> >  	 */
> >  	__flush_tlb_all();
> > +
> > +	arch_flush_lazy_mmu_mode();
> >  }
> >  
> >  #ifdef CONFIG_HIBERNATION
> > 
> 
> This sounds like a critical fix, i.e. a -stable candidate.  Am I
> correct?

I considered copying stable but then I decided that this is a debugging feature
--- kernel_map_pages() is only defined if CONFIG_DEBUG_PAGEALLOC is set and my
thinking was that stable kernels usually don't do this.


-boris
