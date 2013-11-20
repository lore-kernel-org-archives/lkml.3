Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3KTAa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:30:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab3KTAaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:30:20 -0500
Date: Tue, 19 Nov 2013 22:29:20 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte
 writable
Message-ID: <20131120002920.GA14230@amt.cnet>
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

Why is this valid ? That is, the obviously correct rule is

"that all pages are either dirty in the current bitmap,
or write-protected, which is violated here."

With the window above, GET_DIRTY_LOG can be called 100 times while the 
page is dirty, but the corresponding bit not set in the dirty bitmap.

It violates the documentation:

/* for KVM_GET_DIRTY_LOG */
struct kvm_dirty_log {
        __u32 slot;
        __u32 padding;
        union {
                void __user *dirty_bitmap; /* one bit per page */
                __u64 padding;
        };
};

Given a memory slot, return a bitmap containing any pages dirtied
since the last call to this ioctl.  Bit 0 is the first page in the
memory slot.  Ensure the entire structure is cleared to avoid padding
issues.

The point about migration, is that GET_DIRTY_LOG is strictly correct
because it stops vcpus.

But what guarantee does userspace require, from GET_DIRTY_LOG, while vcpus are
executing? 

With fast page fault:

       if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
               /* The window in here... */
               mark_page_dirty(vcpu->kvm, gfn);
 
And the $SUBJECT set_spte reordering, the rule becomes

A call to GET_DIRTY_LOG guarantees to return correct information about 
dirty pages before invocation of the previous GET_DIRTY_LOG call.

(see example 1: the next GET_DIRTY_LOG will return the dirty information
there).

The rule for sptes that is, because kvm_write_guest does not match the
documentation at all.

So before example 1 and this patch, the rule (well for sptes at least) was

"Given a memory slot, return a bitmap containing any pages dirtied
since the last call to this ioctl.  Bit 0 is the first page in the
memory slot.  Ensure the entire structure is cleared to avoid padding
issues."

Can you explain why it is OK to relax this rule?

Thanks

(reviewing the nulls desc patch...).


