Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3E0W7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:59:35 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40715 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3E0W7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:59:34 -0400
Message-ID: <51A3E54C.5040504@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 06:59:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 03/11] KVM: MMU: fast invalidate all pages
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524202307.GA4525@amt.cnet> <20130526082649.GQ4725@redhat.com> <20130526203716.GA11569@amt.cnet>
In-Reply-To: <20130526203716.GA11569@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052722-6102-0000-0000-00000397A4D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 04:37 AM, Marcelo Tosatti wrote:
> On Sun, May 26, 2013 at 11:26:49AM +0300, Gleb Natapov wrote:
>> On Fri, May 24, 2013 at 05:23:07PM -0300, Marcelo Tosatti wrote:
>>> Hi Xiao,
>>>
>>> On Thu, May 23, 2013 at 03:55:52AM +0800, Xiao Guangrong wrote:
>>>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
>>>> walk and zap all shadow pages one by one, also it need to zap all guest
>>>> page's rmap and all shadow page's parent spte list. Particularly, things
>>>> become worse if guest uses more memory or vcpus. It is not good for
>>>> scalability
>>>>
>>>> In this patch, we introduce a faster way to invalidate all shadow pages.
>>>> KVM maintains a global mmu invalid generation-number which is stored in
>>>> kvm->arch.mmu_valid_gen and every shadow page stores the current global
>>>> generation-number into sp->mmu_valid_gen when it is created
>>>>
>>>> When KVM need zap all shadow pages sptes, it just simply increase the
>>>> global generation-number then reload root shadow pages on all vcpus.
>>>> Vcpu will create a new shadow page table according to current kvm's
>>>> generation-number. It ensures the old pages are not used any more.
>>>> Then the obsolete pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
>>>> are zapped by using lock-break technique
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |    2 +
>>>>  arch/x86/kvm/mmu.c              |   84 +++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/kvm/mmu.h              |    1 +
>>>>  3 files changed, 87 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 3741c65..bff7d46 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -222,6 +222,7 @@ struct kvm_mmu_page {
>>>>  	int root_count;          /* Currently serving as active root */
>>>>  	unsigned int unsync_children;
>>>>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
>>>> +	unsigned long mmu_valid_gen;
>>>>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
>>>>  
>>>>  #ifdef CONFIG_X86_32
>>>> @@ -529,6 +530,7 @@ struct kvm_arch {
>>>>  	unsigned int n_requested_mmu_pages;
>>>>  	unsigned int n_max_mmu_pages;
>>>>  	unsigned int indirect_shadow_pages;
>>>> +	unsigned long mmu_valid_gen;
>>>>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>>>>  	/*
>>>>  	 * Hash table of struct kvm_mmu_page.
>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>> index f8ca2f3..f302540 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -1838,6 +1838,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
>>>>  	__clear_sp_write_flooding_count(sp);
>>>>  }
>>>>  
>>>> +static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>>>> +{
>>>> +	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
>>>> +}
>>>> +
>>>>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>  					     gfn_t gfn,
>>>>  					     gva_t gaddr,
>>>> @@ -1900,6 +1905,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>  
>>>>  		account_shadowed(vcpu->kvm, gfn);
>>>>  	}
>>>> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>>>>  	init_shadow_page_table(sp);
>>>>  	trace_kvm_mmu_get_page(sp, true);
>>>>  	return sp;
>>>> @@ -2070,8 +2076,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>>>  	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>>>  	kvm_mmu_page_unlink_children(kvm, sp);
>>>>  	kvm_mmu_unlink_parents(kvm, sp);
>>>> +
>>>>  	if (!sp->role.invalid && !sp->role.direct)
>>>>  		unaccount_shadowed(kvm, sp->gfn);
>>>> +
>>>>  	if (sp->unsync)
>>>>  		kvm_unlink_unsync_page(kvm, sp);
>>>>  	if (!sp->root_count) {
>>>> @@ -4195,6 +4203,82 @@ restart:
>>>>  	spin_unlock(&kvm->mmu_lock);
>>>>  }
>>>>  
>>>> +static void kvm_zap_obsolete_pages(struct kvm *kvm)
>>>> +{
>>>> +	struct kvm_mmu_page *sp, *node;
>>>> +	LIST_HEAD(invalid_list);
>>>> +
>>>> +restart:
>>>> +	list_for_each_entry_safe_reverse(sp, node,
>>>> +	      &kvm->arch.active_mmu_pages, link) {
>>>> +		/*
>>>> +		 * No obsolete page exists before new created page since
>>>> +		 * active_mmu_pages is the FIFO list.
>>>> +		 */
>>>> +		if (!is_obsolete_sp(kvm, sp))
>>>> +			break;
>>>
>>> Can you add a comment to list_add(x, active_mmu_pages) callsites
>>> mentioning this case?
>>>
>>> Because it'll break silently if people do list_add_tail().
>>>
>>>> +		/*
>>>> +		 * Do not repeatedly zap a root page to avoid unnecessary
>>>> +		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
>>>> +		 * progress:
>>>> +		 *    vcpu 0                        vcpu 1
>>>> +		 *                         call vcpu_enter_guest():
>>>> +		 *                            1): handle KVM_REQ_MMU_RELOAD
>>>> +		 *                                and require mmu-lock to
>>>> +		 *                                load mmu
>>>> +		 * repeat:
>>>> +		 *    1): zap root page and
>>>> +		 *        send KVM_REQ_MMU_RELOAD
>>>> +		 *
>>>> +		 *    2): if (cond_resched_lock(mmu-lock))
>>>> +		 *
>>>> +		 *                            2): hold mmu-lock and load mmu
>>>> +		 *
>>>> +		 *                            3): see KVM_REQ_MMU_RELOAD bit
>>>> +		 *                                on vcpu->requests is set
>>>> +		 *                                then return 1 to call
>>>> +		 *                                vcpu_enter_guest() again.
>>>> +		 *            goto repeat;
>>>> +		 *
>>>> +		 * Since we are reversely walking the list and the invalid
>>>> +		 * list will be moved to the head, skip the invalid page
>>>> +		 * can help us to avoid the infinity list walking.
>>>> +		 */
>>>> +		if (sp->role.invalid)
>>>> +			continue;
>>>
>>> But this allows completing (that is returning), with page that should 
>>> be zapped still present (even though its invalid).
>>>
>>> Is another pass needed at the end to take care of the invalid pages?
>>> Which at that point must have their root_count decreased.
>>>
>> It is not different from how it work now. Invalid page can still be not
>> zapped after zap_all() completes. They are ignored by all relevant code
>> paths.
> 
> It is different. kvm_mmu_zap_all() returns with 0 pages at
> mmu_active_pages today.

Do not think so.

kvm_mmu_zap_all() also keeps role.root && role.invalid pages on mmu_active_pages.
role.root && role.invalid pages should be zapped in vcpu context.

> 
> It is probably worthwhile to maintain behaviour (instead of every other
> code path does the right thing).
> 
>>> Also this function should be serialized, that is, should not allow
>>> simultaneous kvm_mmu_invalidate_zap_all_pages. If thats so
>>> assert(mutex_is_locked(kvm->lock)) would help.
>>>
>>> Probably fine to have simultaneous users, but not necessary AFAICS.
>> I raced this point on previous patch submission. The function can be
>> executed simultaneously only during vmexit when zap_all is called by mm
>> notifiers. During regular work the function is only called by slot
>> manipulation functions and those are serialized by slot lock.
> 
> How about fix hypercall vs kvm_set_memory?

In this version, we have dropped call kvm_mmu_zap_all in hypercall since
it is useless.

(pacthing hypercall is broken for a long time:
https://lkml.org/lkml/2013/5/22/388)

