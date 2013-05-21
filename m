Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3EUDhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:37:10 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37160 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3EUDhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:37:08 -0400
Message-ID: <519AEBD9.9040909@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 11:36:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130520194624.GA21392@amt.cnet> <20130520201545.GC14287@redhat.com> <20130520204047.GA23364@amt.cnet>
In-Reply-To: <20130520204047.GA23364@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052103-8878-0000-0000-000007312064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:40 AM, Marcelo Tosatti wrote:
> On Mon, May 20, 2013 at 11:15:45PM +0300, Gleb Natapov wrote:
>> On Mon, May 20, 2013 at 04:46:24PM -0300, Marcelo Tosatti wrote:
>>> On Fri, May 17, 2013 at 05:12:58AM +0800, Xiao Guangrong wrote:
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
>>>> Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
>>>> are zapped by using lock-break technique
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |    2 +
>>>>  arch/x86/kvm/mmu.c              |  103 +++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/kvm/mmu.h              |    1 +
>>>>  3 files changed, 106 insertions(+), 0 deletions(-)
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
>>>> index 682ecb4..891ad2c 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -1839,6 +1839,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
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
>>>> @@ -1865,6 +1870,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>  		role.quadrant = quadrant;
>>>>  	}
>>>>  	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
>>>> +		if (is_obsolete_sp(vcpu->kvm, sp))
>>>> +			continue;
>>>> +
>>>
>>> Whats the purpose of not using pages which are considered "obsolete" ?
>>>
>> The same as not using page that is invalid, to not reuse stale
>> information. The page may contain ptes that point to invalid slot.
> 
> Any pages with stale information will be zapped by kvm_mmu_zap_all().
> When that happens, page faults will take place which will automatically 
> use the new generation number.

kvm_mmu_zap_all() uses lock-break technique to zap pages, before it zaps
all obsolete pages other vcpus can require mmu-lock and call kvm_mmu_get_page()
to install new page. In this case, obsolete page still live in hast-table and
can be found by kvm_mmu_get_page().

> 
> So still not clear why is this necessary.
> 
>>> The only purpose of the generation number should be to guarantee forward
>>> progress of kvm_mmu_zap_all in face of allocators (kvm_mmu_get_page).
>>>
>>> That is, on allocation you store the generation number on the shadow page.
>>> The only purpose of that number in the shadow page is so that
>>> kvm_mmu_zap_all can skip deleting shadow pages which have been created
>>> after kvm_mmu_zap_all began operation.
>>>
>>>>  		if (!need_sync && sp->unsync)
>>>>  			need_sync = true;
>>>>  
>>>> @@ -1901,6 +1909,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>  
>>>>  		account_shadowed(vcpu->kvm, gfn);
>>>>  	}
>>>> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>>>>  	init_shadow_page_table(sp);
>>>>  	trace_kvm_mmu_get_page(sp, true);
>>>>  	return sp;
>>>> @@ -2071,8 +2080,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>>>  	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>>>  	kvm_mmu_page_unlink_children(kvm, sp);
>>>>  	kvm_mmu_unlink_parents(kvm, sp);
>>>> +
>>>>  	if (!sp->role.invalid && !sp->role.direct)
>>>>  		unaccount_shadowed(kvm, sp->gfn);
>>>> +
>>>>  	if (sp->unsync)
>>>>  		kvm_unlink_unsync_page(kvm, sp);
>>>>  
>>>> @@ -4196,6 +4207,98 @@ restart:
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
>>>> +
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
>>>> +		 */
>>>> +		if (sp->role.invalid)
>>>> +			continue;
>>>> +		/*
>>>> +		 * Need not flush tlb since we only zap the sp with invalid
>>>> +		 * generation number.
>>>> +		 */
>>>> +		if (cond_resched_lock(&kvm->mmu_lock))
>>>> +			goto restart;
>>>
>>> Please don't do this, just release all pages and flush the TLB when
>>> dropping mmu_lock instead. This means for other mmu_lock users is that
>>> there is a consistent state.
>> You mean call kvm_mmu_commit_zap_page() on  current invalid_list before restart?
>> If yes, I agree.
> 
> I mean leaving pages which have been "partially deleted" while releasing
> mmu_lock. Say for example upon the need to delete a given page you do:
> 
> spin_lock(mmu_lock)
> shadow page = lookup page on hash list
> if (shadow page is not found)
> 	proceed assuming the page has been properly deleted (*)
> spin_unlock(mmu_lock)
> 
> At (*) we assume it has been 1) deleted and 2) TLB flushed.
> 
> So its better to just 
> 
> if (need_resched()) {
> 	kvm_mmu_complete_zap_page(&list);

is kvm_mmu_commit_zap_page()?

> 	cond_resched_lock(&kvm->mmu_lock);
> }
> 

Isn't it what Gleb said?

> If you want to collapse TLB flushes, please do it in a later patch.

Good to me.

> 
>>>> +		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
>>>> +			goto restart;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * Should flush tlb before free page tables since lockless-walking
>>>> +	 * may use the pages.
>>>> +	 */
>>>> +	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Fast invalidate all shadow pages.
>>>> + *
>>>> + * @zap_obsolete_pages indicates whether all the obsolete pages should
>>>> + * be zapped. This is required when memslot is being deleted or VM is
>>>> + * being destroyed, in these cases, we should ensure that KVM MMU does
>>>> + * not use any resource of the being-deleted slot or all slots after
>>>> + * calling the function.
>>>> + *
>>>> + * @zap_obsolete_pages == false means the caller just wants to flush all
>>>> + * shadow page tables.
>>>> + */
>>>> +void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
>>>> +{
>>>> +	spin_lock(&kvm->mmu_lock);
>>>> +	kvm->arch.mmu_valid_gen++;
>>>> +
>>>> +	/*
>>>> +	 * Notify all vcpus to reload its shadow page table
>>>> +	 * and flush TLB. Then all vcpus will switch to new
>>>> +	 * shadow page table with the new mmu_valid_gen.
>>>
>>> Only if you zap the roots, which we agreed would be a second step, after
>>> being understood its necessary.
>>>
>> I've lost you here. The patch implement what was agreed upon.
> 
> "
> + /*
> +  * Notify all vcpus to reload its shadow page table
> +  * and flush TLB. Then all vcpus will switch to new
> +  * shadow page table with the new mmu_valid_gen.
> "
> 
> What was suggested was... go to phrase which starts with "The only purpose
> of the generation number should be to".
> 
> The comment quoted here does not match that description.

So, is this your want?

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2c512e8..2fd4c04 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4275,10 +4275,19 @@ restart:
  */
 void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
 {
+       bool zap_root = fase;
+       struct kvm_mmu_page *sp;
+
        spin_lock(&kvm->mmu_lock);
        trace_kvm_mmu_invalidate_all_pages(kvm, zap_obsolete_pages);
        kvm->arch.mmu_valid_gen++;

+       list_for_each_entry(sp, kvm->arch.active_mmu_pages, link)
+               if (sp->root_count && !sp->role.invalid) {
+                       zap_root = true;
+                       break;
+               }
+
        /*
         * Notify all vcpus to reload its shadow page table
         * and flush TLB. Then all vcpus will switch to new
@@ -4288,7 +4297,8 @@ void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
         * mmu-lock, otherwise, vcpu would purge shadow page
         * but miss tlb flush.
         */
-       kvm_reload_remote_mmus(kvm);
+       if (zap_root)
+               kvm_reload_remote_mmus(kvm);

        if (zap_obsolete_pages)
                kvm_zap_obsolete_pages(kvm);

> 
>>>> +	 *
>>>> +	 * Note: we should do this under the protection of
>>>> +	 * mmu-lock, otherwise, vcpu would purge shadow page
>>>> +	 * but miss tlb flush.
>>>> +	 */
>>>> +	kvm_reload_remote_mmus(kvm);
>>>> +
>>>> +	if (zap_obsolete_pages)
>>>> +		kvm_zap_obsolete_pages(kvm);
>>>
>>> Please don't condition behaviour on parameters like this, its confusing. 
>>> Can probably just use
>>>
>>> spin_lock(&kvm->mmu_lock);
>>> kvm->arch.mmu_valid_gen++;
>>> kvm_reload_remote_mmus(kvm);
>>> spin_unlock(&kvm->mmu_lock);
>>>
>>> Directly when needed.
>>
>> Please, no. Better have one place where mmu_valid_gen is
>> handled. If parameter is confusing better have two functions:
>> kvm_mmu_invalidate_all_pages() and kvm_mmu_invalidate_zap_all_pages(),
>> but to minimize code duplication they will call the same function with
>> a parameter anyway, so I am not sure this is a win.
> 
> OK.

Will introduce these two functions.

Thank you all. ;)


