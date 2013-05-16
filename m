Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3EPNZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:25:39 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54091 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3EPNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:25:37 -0400
Message-ID: <5194DE48.3050208@linux.vnet.ibm.com>
Date: Thu, 16 May 2013 21:25:28 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/8] KVM: MMU: fast invalidate all pages
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130516124349.GC14597@redhat.com>
In-Reply-To: <20130516124349.GC14597@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051613-5816-0000-0000-0000080218EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 08:43 PM, Gleb Natapov wrote:
> On Thu, May 16, 2013 at 08:17:48PM +0800, Xiao Guangrong wrote:
>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
>> walk and zap all shadow pages one by one, also it need to zap all guest
>> page's rmap and all shadow page's parent spte list. Particularly, things
>> become worse if guest uses more memory or vcpus. It is not good for
>> scalability
>>
>> In this patch, we introduce a faster way to invalidate all shadow pages.
>> KVM maintains a global mmu invalid generation-number which is stored in
>> kvm->arch.mmu_valid_gen and every shadow page stores the current global
>> generation-number into sp->mmu_valid_gen when it is created
>>
>> When KVM need zap all shadow pages sptes, it just simply increase the
>> global generation-number then reload root shadow pages on all vcpus.
>> Vcpu will create a new shadow page table according to current kvm's
>> generation-number. It ensures the old pages are not used any more.
>> Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
>> are zapped by using lock-break technique
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    2 +
>>  arch/x86/kvm/mmu.c              |   98 +++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/mmu.h              |    2 +
>>  3 files changed, 102 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 3741c65..bff7d46 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -222,6 +222,7 @@ struct kvm_mmu_page {
>>  	int root_count;          /* Currently serving as active root */
>>  	unsigned int unsync_children;
>>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
>> +	unsigned long mmu_valid_gen;
>>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
>>  
>>  #ifdef CONFIG_X86_32
>> @@ -529,6 +530,7 @@ struct kvm_arch {
>>  	unsigned int n_requested_mmu_pages;
>>  	unsigned int n_max_mmu_pages;
>>  	unsigned int indirect_shadow_pages;
>> +	unsigned long mmu_valid_gen;
>>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>>  	/*
>>  	 * Hash table of struct kvm_mmu_page.
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 682ecb4..d9343fe 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1839,6 +1839,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
>>  	__clear_sp_write_flooding_count(sp);
>>  }
>>  
>> +static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>> +{
>> +	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
>> +}
>> +
>>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>  					     gfn_t gfn,
>>  					     gva_t gaddr,
>> @@ -1865,6 +1870,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>  		role.quadrant = quadrant;
>>  	}
>>  	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
>> +		if (is_obsolete_sp(vcpu->kvm, sp))
>> +			continue;
>> +
>>  		if (!need_sync && sp->unsync)
>>  			need_sync = true;
>>  
>> @@ -1901,6 +1909,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>  
>>  		account_shadowed(vcpu->kvm, gfn);
>>  	}
>> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>>  	init_shadow_page_table(sp);
>>  	trace_kvm_mmu_get_page(sp, true);
>>  	return sp;
>> @@ -2071,8 +2080,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>  	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>  	kvm_mmu_page_unlink_children(kvm, sp);
>>  	kvm_mmu_unlink_parents(kvm, sp);
>> +
>>  	if (!sp->role.invalid && !sp->role.direct)
>>  		unaccount_shadowed(kvm, sp->gfn);
>> +
>>  	if (sp->unsync)
>>  		kvm_unlink_unsync_page(kvm, sp);
>>  
>> @@ -4196,6 +4207,93 @@ restart:
>>  	spin_unlock(&kvm->mmu_lock);
>>  }
>>  
>> +static void zap_invalid_pages(struct kvm *kvm)
>> +{
>> +	struct kvm_mmu_page *sp, *node;
>> +	LIST_HEAD(invalid_list);
>> +
>> +restart:
>> +	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
>> +		if (!is_obsolete_sp(kvm, sp))
>> +			continue;
> What if we save kvm->arch.active_mmu_pages on the stack and init
> kvm->arch.active_mmu_pages to be empty at the entrance to
> zap_invalid_pages(). This loop will iterate over saved list. This will
> allow us to drop the is_obsolete_sp() check and will save time since we
> will not be iterating over newly created sps.

This idea is really smart.

It also seems tricky, vcpu can see the page in its page table and hash table but
it has already been deleted from kvm->active_list, but i do not see any issue.

Hmm, can we walk kvm->ative_mmu_pages from tail to head then break the walking
if we meet the sp->valid_gen == kvm->valid_gen? This way also can skip walking
new created sps and more straight.


