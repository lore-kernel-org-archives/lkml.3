Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3EWHu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:50:29 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45796 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3EWHu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:50:27 -0400
Message-ID: <519DCA38.30200@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 15:50:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce kvm_mmu_prepare_zap_obsolete_page
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130523055725.GA26157@redhat.com> <519DB372.3080803@linux.vnet.ibm.com> <20130523061818.GC26157@redhat.com> <519DB7D3.7030101@linux.vnet.ibm.com> <20130523073708.GE26157@redhat.com>
In-Reply-To: <20130523073708.GE26157@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052307-8256-0000-0000-0000079E0395
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 03:37 PM, Gleb Natapov wrote:
> On Thu, May 23, 2013 at 02:31:47PM +0800, Xiao Guangrong wrote:
>> On 05/23/2013 02:18 PM, Gleb Natapov wrote:
>>> On Thu, May 23, 2013 at 02:13:06PM +0800, Xiao Guangrong wrote:
>>>> On 05/23/2013 01:57 PM, Gleb Natapov wrote:
>>>>> On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
>>>>>> It is only used to zap the obsolete page. Since the obsolete page
>>>>>> will not be used, we need not spend time to find its unsync children
>>>>>> out. Also, we delete the page from shadow page cache so that the page
>>>>>> is completely isolated after call this function.
>>>>>>
>>>>>> The later patch will use it to collapse tlb flushes
>>>>>>
>>>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>>>> ---
>>>>>>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
>>>>>>  1 files changed, 41 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>>>> index 9b57faa..e676356 100644
>>>>>> --- a/arch/x86/kvm/mmu.c
>>>>>> +++ b/arch/x86/kvm/mmu.c
>>>>>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>>>>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>>>>>>  {
>>>>>>  	ASSERT(is_empty_shadow_page(sp->spt));
>>>>>> -	hlist_del(&sp->hash_link);
>>>>>> +	hlist_del_init(&sp->hash_link);
>>>>> Why do you need hlist_del_init() here? Why not move it into
>>>>
>>>> Since the hlist will be double freed. We will it like this:
>>>>
>>>> kvm_mmu_prepare_zap_obsolete_page(page, list);
>>>> kvm_mmu_commit_zap_page(list);
>>>>    kvm_mmu_free_page(page);
>>>>
>>>> The first place is kvm_mmu_prepare_zap_obsolete_page(page), which have
>>>> deleted the hash list.
>>>>
>>>>> kvm_mmu_prepare_zap_page() like we discussed it here:
>>>>> https://patchwork.kernel.org/patch/2580351/ instead of doing
>>>>> it differently for obsolete and non obsolete pages?
>>>>
>>>> It is can break the hash-list walking: we should rescan the
>>>> hash list once the page is prepared-ly zapped.
>>>>
>>>> I mentioned it in the changelog:
>>>>
>>>>   4): drop the patch which deleted page from hash list at the "prepare"
>>>>       time since it can break the walk based on hash list.
>>> Can you elaborate on how this can happen?
>>
>> There is a example:
>>
>> int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>> {
>> 	struct kvm_mmu_page *sp;
>> 	LIST_HEAD(invalid_list);
>> 	int r;
>>
>> 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
>> 	r = 0;
>> 	spin_lock(&kvm->mmu_lock);
>> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
>> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
>> 			 sp->role.word);
>> 		r = 1;
>> 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>> 	}
>> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>> 	spin_unlock(&kvm->mmu_lock);
>>
>> 	return r;
>> }
>>
>> It works fine since kvm_mmu_prepare_zap_page does not touch the hash list.
>> If we delete hlist in kvm_mmu_prepare_zap_page(), this kind of codes should
>> be changed to:
>>
>> restart:
>> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
>> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
>> 			 sp->role.word);
>> 		r = 1;
>> 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
>> 			goto restart;
>> 	}
>> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>>
> Hmm, yes. So lets leave it as is and always commit invalid_list before

So, you mean drop this patch and the patch of
KVM: MMU: collapse TLB flushes when zap all pages?

But, we only introduced less code in this patch, most of them is reusing
the code of __kvm_mmu_prepare_zap_page...

Furthermore, maybe not related to this patch, i do not think calling
mmu_zap_unsync_children() in kvm_mmu_prepare_zap_page() is necessary,
but i need to test it very carefully. Why not let
kvm_mmu_prepare_zap_obsolete_page for the first step? :(

> releasing lock in kvm_zap_obsolete_pages() or skip obsolete pages while
> walking hash table. Former is clearer I think.
> 
> --
> 			Gleb.
> 
> 
> 

