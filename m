Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3JOD5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab3JOD5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:57:10 -0400
Date: Tue, 15 Oct 2013 06:57:05 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-ID: <20131015035705.GB30802@redhat.com>
References: <525533DB.1060104@gmail.com>
 <20131010014710.GA2198@amt.cnet>
 <20131010120845.GT3574@redhat.com>
 <20131010164222.GB3211@amt.cnet>
 <20131010191646.GE15954@redhat.com>
 <20131010210301.GA7275@amt.cnet>
 <20131011053831.GG15954@redhat.com>
 <20131011203017.GA29576@amt.cnet>
 <20131012055356.GC14789@redhat.com>
 <20131014192945.GA22655@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014192945.GA22655@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:29:45PM -0300, Marcelo Tosatti wrote:
> On Sat, Oct 12, 2013 at 08:53:56AM +0300, Gleb Natapov wrote:
> > On Fri, Oct 11, 2013 at 05:30:17PM -0300, Marcelo Tosatti wrote:
> > > On Fri, Oct 11, 2013 at 08:38:31AM +0300, Gleb Natapov wrote:
> > > > > n_max_mmu_pages is not a suitable limit to throttle freeing of pages via
> > > > > RCU (its too large). If the free memory watermarks are smaller than 
> > > > > n_max_mmu_pages for all guests, OOM is possible.
> > > > > 
> > > > Ah, yes. I am not saying n_max_mmu_pages will throttle RCU, just saying
> > > > that slab size will be bound, so hopefully shrinker will touch it
> > > > rarely.
> > > > 
> > > > > > > > and, in addition, page released to slab is immediately
> > > > > > > > available for allocation, no need to wait for grace period. 
> > > > > > > 
> > > > > > > See SLAB_DESTROY_BY_RCU comment at include/linux/slab.h.
> > > > > > > 
> > > > > > This comment is exactly what I was referring to in the code you quoted. Do
> > > > > > you see anything problematic in what comment describes?
> > > > > 
> > > > > "This delays freeing the SLAB page by a grace period, it does _NOT_
> > > > > delay object freeing." The page is not available for allocation.
> > > > By "page" I mean "spt page" which is a slab object. So "spt page"
> > > > AKA slab object will be available fo allocation immediately.
> > > 
> > > The object is reusable within that SLAB cache only, not the 
> > > entire system (therefore it does not prevent OOM condition).
> > > 
> > Since object is allocatable immediately by shadow paging code the number
> > of SLAB objects is bound by n_max_mmu_pages. If there is no enough
> > memory for n_max_mmu_pages OOM condition can happen anyway since shadow
> > paging code will usually have exactly n_max_mmu_pages allocated.
> > 
> > > OK, perhaps it is useful to use SLAB_DESTROY_BY_RCU, but throttling 
> > > is still necessary, as described in the RCU documentation.
> > > 
> > I do not see what should be throttled if we use SLAB_DESTROY_BY_RCU. RCU
> > comes into play only when SLAB cache is shrunk and it happens far from
> > kvm code.
> 
> You are right.
> 
> Why is it safe to allow access, by the lockless page write protect
> side, to spt pointer for shadow page A that can change to a shadow page 
> pointer of shadow page B?
> 
> Write protect spte of any page at will? Or verify that in fact thats the
> shadow you want to write protect?
> 
> Note that spte value might be the same for different shadow pages, 
> so cmpxchg succeeding does not guarantees its the same shadow page that
> has been protected.
> 
Two things can happen: spte that we accidentally write protect is some
other last level spte - this is benign, it will be unprotected on next
fault.  If spte is not last level this is a problem and Xiao propose to
fix it by encoding spte level into spte itself. Another way to fix it is
to handle fault that is caused by write protected middle sptes in KVM -
just unprotected them and go back to a guest.

--
			Gleb.
