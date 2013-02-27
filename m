Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3B0XAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:00:15 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34008 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B0XAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:00:13 -0500
Date: Wed, 27 Feb 2013 15:00:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130227230009.GA32465@kroah.com>
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
 <512E8B41.8000504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E8B41.8000504@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 02:40:01PM -0800, H. Peter Anvin wrote:
> Greg, policy opinion?
> 
> 	-hpa
> 
> On 02/26/2013 03:57 PM, Boris Ostrovsky wrote:
> > 
> > ----- hpa@zytor.com wrote:
> > 
> >> On 02/26/2013 02:56 PM, Boris Ostrovsky wrote:
> >>> When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
> >>> kernel_map_pages() are not made visible (via TLB flush) immediately
> >> if lazy
> >>> MMU is on. In environments that support lazy MMU (e.g. Xen) this may
> >> lead to
> >>> fatal page faults, for example, when zap_pte_range() needs to
> >> allocate pages
> >>> in __tlb_remove_page() -> tlb_next_batch().
> >>>
> >>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >>> ---
> >>>  arch/x86/mm/pageattr.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> >>> index ca1f1c2..7b3216e 100644
> >>> --- a/arch/x86/mm/pageattr.c
> >>> +++ b/arch/x86/mm/pageattr.c
> >>> @@ -1369,6 +1369,8 @@ void kernel_map_pages(struct page *page, int
> >> numpages, int enable)
> >>>  	 * but that can deadlock->flush only current cpu:
> >>>  	 */
> >>>  	__flush_tlb_all();
> >>> +
> >>> +	arch_flush_lazy_mmu_mode();
> >>>  }
> >>>  
> >>>  #ifdef CONFIG_HIBERNATION
> >>>
> >>
> >> This sounds like a critical fix, i.e. a -stable candidate.  Am I
> >> correct?
> > 
> > I considered copying stable but then I decided that this is a debugging feature
> > --- kernel_map_pages() is only defined if CONFIG_DEBUG_PAGEALLOC is set and my
> > thinking was that stable kernels usually don't do this.

"Stable" kernels are used all over the place, like in distros, which
might enable this.

I have no objection to taking this patch in a stable release, as it does
fix a real problem.

thanks,

greg k-h
