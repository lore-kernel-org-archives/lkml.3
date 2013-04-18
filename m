Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967676Ab3DRQgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:36:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab3DRQge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:36:34 -0400
Date: Thu, 18 Apr 2013 19:36:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
Message-ID: <20130418163603.GG5807@redhat.com>
References: <20130322112811.GV9382@redhat.com>
 <514C42EC.6000303@linux.vnet.ibm.com>
 <20130322114715.GW9382@redhat.com>
 <514C4878.5000404@linux.vnet.ibm.com>
 <20130322121254.GX9382@redhat.com>
 <514C508D.6070903@linux.vnet.ibm.com>
 <20130322191524.GY9382@redhat.com>
 <20130417203904.GA29493@amt.cnet>
 <20130418094239.GR8997@redhat.com>
 <20130418140118.GA32288@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418140118.GA32288@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:01:18AM -0300, Marcelo Tosatti wrote:
> On Thu, Apr 18, 2013 at 12:42:39PM +0300, Gleb Natapov wrote:
> > > > that, but if not then less code is better.
> > > 
> > > The number of sp->role.invalid=1 pages is small (only shadow roots). It
> > > can grow but is bounded to a handful. No improvement visible there.
> > > 
> > > The number of shadow pages with old mmu_gen_number is potentially large.
> > > 
> > > Returning all shadow pages to the allocator is problematic because it
> > > takes a long time (therefore the suggestion to postpone it).
> > > 
> > > Spreading the work to free (or reuse) those shadow pages to individual
> > > page fault instances alleviates the mmu_lock hold time issue without
> > > significant reduction to post kvm_mmu_zap_all operation (which has to
> > > rebuilt all pagetables anyway).
> > > 
> > > You prefer to modify SLAB allocator to aggressively free these stale
> > > shadow pages rather than kvm_mmu_get_page to reuse them?
> > Are you saying that what makes kvm_mmu_zap_all() slow is that we return
> > all the shadow pages to the SLAB allocator? As far as I understand what
> > makes it slow is walking over huge number of shadow pages via various
> > lists, actually releasing them to the SLAB is not an issue, otherwise
> > the problem could have been solved by just moving
> > kvm_mmu_commit_zap_page() out of the mmu_lock. If there is measurable
> > SLAB overhead from not reusing the pages I am all for reusing them, but
> > is this really the case or just premature optimization?
> 
> Actually releasing them is not a problem. Walking all pages, lists and
> releasing in the process part of the problem ("returning them to the allocator"
> would have been clearer with "freeing them").
> 
> Point is at some point you have to walk all pages and release their data
> structures. With Xiaos scheme its possible to avoid this lengthy process
> by either:
> 
> 1) reusing the pages with stale generation number
> or
> 2) releasing them via the SLAB shrinker more aggressively
> 
But is it really so? The number of allocated shadow pages are limited
via n_max_mmu_pages mechanism, so I expect most freeing to happen in
make_mmu_pages_available() which is called during page fault so freeing
will be spread across page faults more or less equally. Doing
kvm_mmu_prepare_zap_page()/kvm_mmu_commit_zap_page() and zapping unknown
number of shadow pages during kvm_mmu_get_page() just to reuse one does
not sound like a clear win to me.

> (another typo, i meant "SLAB shrinker" not "SLAB allocator").
> 
> But you seem to be concerned for 1) due to code complexity issues?
> 
It adds code that looks to me redundant. I may be wrong of course, if
it is a demonstrable win I am all for it.

--
			Gleb.
