Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3IBKM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3IBKM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:12:26 -0400
Date: Mon, 2 Sep 2013 13:11:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, glin@suse.de, agraf@suse.de, brogers@suse.de,
        afaerber@suse.de, lnussel@suse.de, edk2-devel@lists.sf.net,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
Message-ID: <20130902101114.GR22899@redhat.com>
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
 <20130901091744.GF22899@redhat.com>
 <52245D81.7060402@linux.vnet.ibm.com>
 <20130902094907.GP22899@redhat.com>
 <522462D6.8090806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522462D6.8090806@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 06:05:10PM +0800, Xiao Guangrong wrote:
> On 09/02/2013 05:49 PM, Gleb Natapov wrote:
> > On Mon, Sep 02, 2013 at 05:42:25PM +0800, Xiao Guangrong wrote:
> >> On 09/01/2013 05:17 PM, Gleb Natapov wrote:
> >>> On Fri, Aug 30, 2013 at 02:41:37PM +0200, Paolo Bonzini wrote:
> >>>> Page tables in a read-only memory slot will currently cause a triple
> >>>> fault because the page walker uses gfn_to_hva and it fails on such a slot.
> >>>>
> >>>> OVMF uses such a page table; however, real hardware seems to be fine with
> >>>> that as long as the accessed/dirty bits are set.  Save whether the slot
> >>>> is readonly, and later check it when updating the accessed and dirty bits.
> >>>>
> >>> The fix looks OK to me, but some comment below.
> >>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Cc: gleb@redhat.com
> >>>> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >>>> ---
> >>>> 	CCing to stable@ since the regression was introduced with
> >>>> 	support for readonly memory slots.
> >>>>
> >>>>  arch/x86/kvm/paging_tmpl.h |  7 ++++++-
> >>>>  include/linux/kvm_host.h   |  1 +
> >>>>  virt/kvm/kvm_main.c        | 14 +++++++++-----
> >>>>  3 files changed, 16 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> >>>> index 0433301..dadc5c0 100644
> >>>> --- a/arch/x86/kvm/paging_tmpl.h
> >>>> +++ b/arch/x86/kvm/paging_tmpl.h
> >>>> @@ -99,6 +99,7 @@ struct guest_walker {
> >>>>  	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
> >>>>  	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
> >>>>  	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
> >>>> +	bool pte_writable[PT_MAX_FULL_LEVELS];
> >>>>  	unsigned pt_access;
> >>>>  	unsigned pte_access;
> >>>>  	gfn_t gfn;
> >>>> @@ -235,6 +236,9 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
> >>>>  		if (pte == orig_pte)
> >>>>  			continue;
> >>>>  
> >>>> +		if (unlikely(!walker->pte_writable[level - 1]))
> >>>> +			return -EACCES;
> >>>> +
> >>>>  		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
> >>>>  		if (ret)
> >>>>  			return ret;
> >>>> @@ -309,7 +313,8 @@ retry_walk:
> >>>>  			goto error;
> >>>>  		real_gfn = gpa_to_gfn(real_gfn);
> >>>>  
> >>>> -		host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
> >>>> +		host_addr = gfn_to_hva_read(vcpu->kvm, real_gfn,
> >>>> +					    &walker->pte_writable[walker->level - 1]);
> >>> The use of gfn_to_hva_read is misleading. The code can still write into
> >>> gfn. Lets rename gfn_to_hva_read to gfn_to_hva_prot() and gfn_to_hva()
> >>> to gfn_to_hva_write().
> >>
> >> Yes. I agreed.
> >>
> >>>
> >>> This makes me think are there other places where gfn_to_hva() was
> >>> used, but gfn_to_hva_prot() should have been?
> >>>  - kvm_host_page_size() looks incorrect. We never use huge page to map
> >>>    read only memory slots currently.
> >>
> >> It only checks whether gfn have been mapped, I think we can use
> >> gfn_to_hva_read() instead, the real permission will be checked when we translate
> >> the gfn to pfn.
> >>
> > Yes, all the cases I listed should be changed to use function that looks
> > at both regular and RO slots.
> > 
> >>>  - kvm_handle_bad_page() also looks incorrect and may cause incorrect
> >>>    address to be reported to userspace.
> >>
> >> I have no idea on this point. kvm_handle_bad_page() is called when it failed to
> >> translate the target gfn to pfn, then the emulator can detect the error on target gfn
> >> properly. no? Or i misunderstood your meaning?
> >>
> > I am talking about the following code:
> > 
> >         if (pfn == KVM_PFN_ERR_HWPOISON) {
> >                 kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
> >                 return 0;
> >         }
> > 
> > pfn will be KVM_PFN_ERR_HWPOISON gfn is backed by faulty memory, we need
> > to report the liner address of the faulty memory to a userspace here,
> > but if gfn is in a RO slot gfn_to_hva() will not return correct address
> > here.
> 
> Got it, thanks for your explanation.
> 
> BTW, if you and Paolo are busy on other things, i am happy to fix these issues. :)
I am busy with reviews mostly :). If you are not to busy with lockless
write protection then fine with me. Lest wait for Paolo's input on
proposed API though.

--
			Gleb.
