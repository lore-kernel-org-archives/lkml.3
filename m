Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3EWGNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:13:23 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36242 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3EWGNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:13:17 -0400
Message-ID: <519DB372.3080803@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 14:13:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce kvm_mmu_prepare_zap_obsolete_page
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130523055725.GA26157@redhat.com>
In-Reply-To: <20130523055725.GA26157@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052306-4790-0000-0000-000008706C91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 01:57 PM, Gleb Natapov wrote:
> On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
>> It is only used to zap the obsolete page. Since the obsolete page
>> will not be used, we need not spend time to find its unsync children
>> out. Also, we delete the page from shadow page cache so that the page
>> is completely isolated after call this function.
>>
>> The later patch will use it to collapse tlb flushes
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 41 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 9b57faa..e676356 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>>  {
>>  	ASSERT(is_empty_shadow_page(sp->spt));
>> -	hlist_del(&sp->hash_link);
>> +	hlist_del_init(&sp->hash_link);
> Why do you need hlist_del_init() here? Why not move it into

Since the hlist will be double freed. We will it like this:

kvm_mmu_prepare_zap_obsolete_page(page, list);
kvm_mmu_commit_zap_page(list);
   kvm_mmu_free_page(page);

The first place is kvm_mmu_prepare_zap_obsolete_page(page), which have
deleted the hash list.

> kvm_mmu_prepare_zap_page() like we discussed it here:
> https://patchwork.kernel.org/patch/2580351/ instead of doing
> it differently for obsolete and non obsolete pages?

It is can break the hash-list walking: we should rescan the
hash list once the page is prepared-ly zapped.

I mentioned it in the changelog:

  4): drop the patch which deleted page from hash list at the "prepare"
      time since it can break the walk based on hash list.
> 
>>  	list_del(&sp->link);
>>  	free_page((unsigned long)sp->spt);
>>  	if (!sp->role.direct)
>> @@ -2069,14 +2069,19 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>>  	return zapped;
>>  }
>>  
>> -static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>> -				    struct list_head *invalid_list)
>> +static int
>> +__kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>> +			   bool zap_unsync_children,
>> +			   struct list_head *invalid_list)
>>  {
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	trace_kvm_mmu_prepare_zap_page(sp);
>>  	++kvm->stat.mmu_shadow_zapped;
>> -	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>> +
>> +	if (likely(zap_unsync_children))
>> +		ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>> +
>>  	kvm_mmu_page_unlink_children(kvm, sp);
>>  	kvm_mmu_unlink_parents(kvm, sp);
>>  
>> @@ -2099,6 +2104,37 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * The obsolete page will not be used, we need not spend time to find
>> + * its unsync children out. Also, we delete the page from shadow page
>> + * cache so that the page is completely isolated after call this
>> + * function.
>> + *
>> + * Note: if we use this function in for_each_gfn_xxx macros, we should
>> + * re-walk the list when it successfully zaps one page.
>> + */
>> +static int
>> +kvm_mmu_prepare_zap_obsolete_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>> +				  struct list_head *invalid_list)
>> +{
>> +	int ret;
>> +
>> +	WARN_ON(!is_obsolete_sp(kvm, sp));
>> +
>> +	ret = __kvm_mmu_prepare_zap_page(kvm, sp, false, invalid_list);
>> +	if (ret)
>> +		hlist_del_init(&sp->hash_link);
> Why hlist_del() is not enough?

Since it will be deleted again in kvm_mmu_free_page().
I am not sure if has another better way to do this.

