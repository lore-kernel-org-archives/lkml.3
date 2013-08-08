Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965798Ab3HHPH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965689Ab3HHPHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:07:24 -0400
Date: Thu, 8 Aug 2013 12:06:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte
 writable
Message-ID: <20130808150659.GA23075@amt.cnet>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130807014828.GA4781@amt.cnet>
 <5201C7D9.20004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201C7D9.20004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:06:49PM +0800, Xiao Guangrong wrote:
> On 08/07/2013 09:48 AM, Marcelo Tosatti wrote:
> > On Tue, Jul 30, 2013 at 09:02:02PM +0800, Xiao Guangrong wrote:
> >> Make sure we can see the writable spte before the dirt bitmap is visible
> >>
> >> We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
> >> on the dirty bitmap, we should ensure the writable spte can be found in rmap
> >> before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
> >> failed to write-protect the page
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > Can you explain why this is safe, with regard to the rule 
> > at edde99ce05290e50 ?
> 
> BTW, this log fixed this case:
> 
>      VCPU 0                KVM migration control
> 
>                            write-protects all pages
> #Pf happen then the page
> become writable, set dirty
> bit on the bitmap
> 
>                           swap the bitmap, current bitmap is empty
> 
> write the page (no dirty log)
> 
>                           stop the guest and push
>                           the remaining dirty pages
> Stopped
>                           See current bitmap is empty that means
>                           no page is dirty.
> > 
> > "The rule is that all pages are either dirty in the current bitmap,
> > or write-protected, which is violated here."
> 
> Actually, this rule is not complete true, there's the 3th case:
> the window between write guest page and set dirty bitmap is valid.
> In that window, page is write-free and not dirty logged.
> 
> This case is based on the fact that at the final step of live migration,
> kvm should stop the guest and push the remaining dirty pages to the
> destination.
> 
> They're some examples in the current code:
> example 1, in fast_pf_fix_direct_spte():
> 	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
> 		/* The window in here... */
> 		mark_page_dirty(vcpu->kvm, gfn);
> 
> example 2, in kvm_write_guest_page():
> 	r = __copy_to_user((void __user *)addr + offset, data, len);
> 	if (r)
> 		return -EFAULT;
> 	/*
> 	 * The window is here, the page is dirty but not logged in
>          * The bitmap.
> 	 */
> 	mark_page_dirty(kvm, gfn);
> 	return 0;
> 
> > 
> > Overall, please document what is the required order of operations for
> > both set_spte and get_dirty_log and why this order is safe (right on top
> > of the code).
> 
> Okay.
> 
> The order we required here is, we should 1) set spte to writable __before__
> set the dirty bitmap and 2) add the spte into rmap __before__ set the dirty
> bitmap.
> 
> The point 1) is the same as fast_pf_fix_direct_spte(), which i explained above.
> The point 1) and 2) can ensure we can find the spte on rmap and see the spte is
> writable when we do lockless write-protection, otherwise these cases will happen
> 
> VCPU 0					kvm ioctl doing get-dirty-pages
> 
> mark_page_dirty(gfn) which
> set the gfn on the dirty maps
>                                       mask = xchg(dirty_bitmap, 0)
> 
>                                       walk all gfns which set on "mask" and
>                                       locklessly write-protect the gfn,
>                                       then walk rmap, see no spte on that rmap
> 	
> 
> add the spte into rmap
> 
> !!!!!! Then the page can be freely wrote but not recorded in the dirty bitmap.
> 
> Or:
> 
> VCPU 0					kvm ioctl doing get-dirty-pages
> 
> mark_page_dirty(gfn) which
> set the gfn on the dirty maps
> 
> add spte into rmap
>                                       mask = xchg(dirty_bitmap, 0)
> 
>                                       walk all gfns which set on "mask" and
>                                       locklessly write-protect the gfn,
>                                       then walk rmap, see spte is on the ramp
>                                       but it is readonly or nonpresent.
> 	
> Mark spte writable
> 
> !!!!!! Then the page can be freely wrote but not recorded in the dirty bitmap.
> 
> Hopefully, i have clarified it, if you have any questions, please let me know.

Yes, partially. Please on top of the explanation above, have something along
the lines of

"The flush IPI assumes that a thread switch happens in this order"
comment at arch/x86/mm/tlb.c

"With get_user_pages_fast, we walk down the pagetables without taking"
comment at arch/x86/mm/gup.c


What about the relation between read-only spte and respective TLB flush?
That is:

vcpu0					vcpu1

lockless write protect
mark spte read-only
					either some mmu-lockless path or not
					write protect page:
					find read-only page
					assumes tlb is flushed
				
kvm_flush_remote_tlbs


In general, i think write protection is a good candidate for lockless operation.
However, i would also be concerned about the larger problem of mmu-lock 
contention and how to solve it. Did you ever consider splitting it?

> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 35d4b50..0fe56ad 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >>  		}
> >>  	}
> >>  
> >> -	if (pte_access & ACC_WRITE_MASK)
> >> -		mark_page_dirty(vcpu->kvm, gfn);
> >> -
> >>  set_pte:
> >>  	if (mmu_spte_update(sptep, spte))
> >>  		kvm_flush_remote_tlbs(vcpu->kvm);
> > 
> > Here, there is a modified guest page without dirty log bit set (think
> > another vcpu writing to the page via this spte).
> 
> This is okay since we call mark_page_dirty(vcpu->kvm, gfn) after that, this
> is the same case as fast_pf_fix_direct_spte() and i have explained why it is
> safe above.

Right. 
