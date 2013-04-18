Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967342Ab3DRPVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:21:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43184 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966917Ab3DRPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:21:10 -0400
Message-ID: <51700F59.6080707@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 23:20:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 12/15] KVM: MMU: fast invalid all shadow pages
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1366093973-2617-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130418000550.GE31059@amt.cnet> <516F6FD0.5050902@linux.vnet.ibm.com> <20130418130306.GA29705@amt.cnet> <20130418132924.GB29705@amt.cnet>
In-Reply-To: <20130418132924.GB29705@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041815-5140-0000-0000-0000030EAFAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 09:29 PM, Marcelo Tosatti wrote:
> On Thu, Apr 18, 2013 at 10:03:06AM -0300, Marcelo Tosatti wrote:
>> On Thu, Apr 18, 2013 at 12:00:16PM +0800, Xiao Guangrong wrote:
>>>>
>>>> What is the justification for this? 
>>>
>>> We want the rmap of being deleted memslot is removed-only that is
>>> needed for unmapping rmap out of mmu-lock.
>>>
>>> ======
>>> 1) do not corrupt the rmap
>>> 2) keep pte-list-descs available
>>> 3) keep shadow page available
>>>
>>> Resolve 1):
>>> we make the invalid rmap be remove-only that means we only delete and
>>> clear spte from the rmap, no new sptes can be added to it.
>>> This is reasonable since kvm can not do address translation on invalid rmap
>>> (gfn_to_pfn is failed on invalid memslot) and all sptes on invalid rmap can
>>> not be reused (they belong to invalid shadow page).
>>> ======
>>>
>>> clear_flush_young / test_young / change_pte of mmu-notify can rewrite
>>> rmap with the present-spte (P bit is set), we should umap rmap in
>>> these handlers.
>>>
>>>>
>>>>> +
>>>>> +	/*
>>>>> +	 * To ensure that all vcpus and mmu-notify are not clearing
>>>>> +	 * spte and rmap entry.
>>>>> +	 */
>>>>> +	synchronize_srcu_expedited(&kvm->srcu);
>>>>> +}
>>>>> +
>>>>>  #ifdef MMU_DEBUG
>>>>>  static int is_empty_shadow_page(u64 *spt)
>>>>>  {
>>>>> @@ -2219,6 +2283,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
>>>>>  	__clear_sp_write_flooding_count(sp);
>>>>>  }
>>>>>  
>>>>> +static bool is_valid_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>>>>> +{
>>>>> +	return likely(sp->mmu_valid_gen == kvm->arch.mmu_valid_gen);
>>>>> +}
>>>>> +
>>>>>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>>  					     gfn_t gfn,
>>>>>  					     gva_t gaddr,
>>>>> @@ -2245,6 +2314,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>>  		role.quadrant = quadrant;
>>>>>  	}
>>>>>  	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
>>>>> +		if (!is_valid_sp(vcpu->kvm, sp))
>>>>> +			continue;
>>>>> +
>>>>>  		if (!need_sync && sp->unsync)
>>>>>  			need_sync = true;
>>>>>  
>>>>> @@ -2281,6 +2353,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>>>>  
>>>>>  		account_shadowed(vcpu->kvm, gfn);
>>>>>  	}
>>>>> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>>>>>  	init_shadow_page_table(sp);
>>>>>  	trace_kvm_mmu_get_page(sp, true);
>>>>>  	return sp;
>>>>> @@ -2451,8 +2524,12 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>>>>  	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>>>>  	kvm_mmu_page_unlink_children(kvm, sp);
>>>>
>>>> The rmaps[] arrays linked to !is_valid_sp() shadow pages should not be
>>>> accessed (as they have been freed already).
>>>>
>>>> I suppose the is_valid_sp() conditional below should be moved earlier,
>>>> before kvm_mmu_unlink_parents or any other rmap access.
>>>>
>>>> This is fine: the !is_valid_sp() shadow pages are only reachable
>>>> by SLAB and the hypervisor itself.
>>>
>>> Unfortunately we can not do this. :(
>>>
>>> The sptes in shadow pape can linked to many slots, if the spte is linked
>>> to the rmap of being deleted memslot, it is ok, otherwise, the rmap of
>>> still used memslot is miss updated.
>>>
>>> For example, slot 0 is being deleted, sp->spte[0] is linked on slot[0].rmap,
>>> sp->spte[1] is linked on slot[1].rmap. If we do not access rmap of this 'sp',
>>> the already-freed spte[1] is still linked on slot[1].rmap.
>>>
>>> We can let kvm update the rmap for sp->spte[1] and do not unlink sp->spte[0].
>>> This is also not allowed since mmu-notify can access the invalid rmap before
>>> the memslot is destroyed, then mmu-notify will get already-freed spte on
>>> the rmap or page Access/Dirty is miss tracked (if let mmu-notify do not access
>>> the invalid rmap).
>>
>> Why not release all rmaps?
>>
>> Subject: [PATCH v2 3/7] KVM: x86: introduce kvm_clear_all_gfn_page_info
>>
>> This function is used to reset the rmaps and page info of all guest page
>> which will be used in later patch
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Which you have later in patchset.

The patch you mentioned is old (v2), now it only resets lpage-info excluding
rmap:

======
[PATCH v3 11/15] KVM: MMU: introduce kvm_clear_all_lpage_info

This function is used to reset the large page info of all guest page
which will be used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
======

We can not release all rmaps. If we do this, ->invalidate_page and
->invalidate_range_start can not find any spte using the host page,
that means, Accessed/Dirty for host page is missing tracked.
(missing call kvm_set_pfn_accessed and kvm_set_pfn_dirty properly.)

Furthermore, when we drop a invalid-gen spte, we will call
kvm_set_pfn_dirty/kvm_set_pfn_dirty for a already-freed host page since
mmu-notify can not find the spte by rmap.
(we can skip drop-spte for the invalid-gen sp, but A/D for host page
can be missed)

That is why i introduced unmap_invalid_rmap out of mmu-lock.

> 
> So, what is the justification for the zap root + generation number increase 
> to work on a per memslot basis, given that
> 
>         /*
>          * If memory slot is created, or moved, we need to clear all
>          * mmio sptes.
>          */
>         if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
>                 kvm_mmu_zap_mmio_sptes(kvm);
>                 kvm_reload_remote_mmus(kvm);
>         }
> 
> Is going to be dealt with generation number on mmio spte idea?

Yes. Actually, this patchset (v3) is based on other two patchset:

======
This patchset is based on my previous two patchset:
[PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
(https://lkml.org/lkml/2013/4/1/2)

[PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
(https://lkml.org/lkml/2013/4/1/134)
======

We did that it [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes.

> 
> Note at the moment all shadows pages are zapped on deletion / move,
> and there is no performance complaint for those cases.

Yes, zap-mmio is only needed for MEMSLOT_CREATE.

> 
> In fact, for what case is generation number on mmio spte optimizes for?
> The cases are where slots are deleted/moved/created on a live guest
> are:
> 
> - Legacy VGA mode operation where VGA slots are created/deleted. Zapping
> all shadow not a performance issue in that case.
> - Device hotplug (not performance critical).
> - Remapping of PCI memory regions (not a performance issue).
> - Memory hotplug (not a performance issue).
> 
> These are all rare events in which there is no particular concern about
> rebuilding shadow pages to resume cruise speed operation.
> 
> So from this POV (please correct if not accurate) avoiding problems
> with huge number of shadow pages is all thats being asked for.
> 
> Which is handled nicely by zap roots + sp gen number increase.

So, we can use "zap roots + sp gen number" instead of current zap-mmio-sp?
If yes, i totally agree with you.



