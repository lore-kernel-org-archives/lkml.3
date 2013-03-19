Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3CSDHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:07:16 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57027 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab3CSDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:07:14 -0400
Message-ID: <5147D63B.4000400@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 11:06:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: fast zap all shadow pages
References: <514006AC.2020904@linux.vnet.ibm.com> <514007A0.1040400@linux.vnet.ibm.com> <20130318204601.GA16208@amt.cnet>
In-Reply-To: <20130318204601.GA16208@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031902-0260-0000-0000-000002AFBF2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 04:46 AM, Marcelo Tosatti wrote:
> On Wed, Mar 13, 2013 at 12:59:12PM +0800, Xiao Guangrong wrote:
>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
>> walk and zap all shadow pages one by one, also it need to zap all guest
>> page's rmap and all shadow page's parent spte list. Particularly, things
>> become worse if guest uses more memory or vcpus. It is not good for
>> scalability.
>>
>> Since all shadow page will be zapped, we can directly zap the mmu-cache
>> and rmap so that vcpu will fault on the new mmu-cache, after that, we can
>> directly free the memory used by old mmu-cache.
>>
>> The root shadow page is little especial since they are currently used by
>> vcpus, we can not directly free them. So, we zap the root shadow pages and
>> re-add them into the new mmu-cache.
>>
>> After this patch, kvm_mmu_zap_all can be faster 113% than before
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 56 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index e326099..536d9ce 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4186,18 +4186,68 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>>
>>  void kvm_mmu_zap_all(struct kvm *kvm)
>>  {
>> -	struct kvm_mmu_page *sp, *node;
>> +	LIST_HEAD(root_mmu_pages);
>>  	LIST_HEAD(invalid_list);
>> +	struct list_head pte_list_descs;
>> +	struct kvm_mmu_cache *cache = &kvm->arch.mmu_cache;
>> +	struct kvm_mmu_page *sp, *node;
>> +	struct pte_list_desc *desc, *ndesc;
>> +	int root_sp = 0;
>>
>>  	spin_lock(&kvm->mmu_lock);
>> +
>>  restart:
>> -	list_for_each_entry_safe(sp, node,
>> -	      &kvm->arch.mmu_cache.active_mmu_pages, link)
>> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
>> -			goto restart;
>> +	/*
>> +	 * The root shadow pages are being used on vcpus that can not
>> +	 * directly removed, we filter them out and re-add them to the
>> +	 * new mmu cache.
>> +	 */
>> +	list_for_each_entry_safe(sp, node, &cache->active_mmu_pages, link)
>> +		if (sp->root_count) {
>> +			int ret;
>> +
>> +			root_sp++;
>> +			ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>> +			list_move(&sp->link, &root_mmu_pages);
>> +			if (ret)
>> +				goto restart;
>> +		}
>> +
>> +	list_splice(&cache->active_mmu_pages, &invalid_list);
>> +	list_replace(&cache->pte_list_descs, &pte_list_descs);
>> +
>> +	/*
>> +	 * Reset the mmu cache so that later vcpu will fault on the new
>> +	 * mmu cache.
>> +	 */
>> +	memset(cache, 0, sizeof(*cache));
>> +	kvm_mmu_init(kvm);
> 
> Xiao,
> 
> I suppose zeroing of kvm_mmu_cache can be avoided, if the links are
> removed at prepare_zap_page. So perhaps

The purpose of zeroing of kvm_mmu_cache is resetting the hashtable and
some count numbers.
[.n_request_mmu_pages and .n_max_mmu_pages should not be changed, i will
fix this].

> 
> - spin_lock(mmu_lock)
> - for each page
> 	- zero sp->spt[], remove page from linked lists

sizeof(mmu_cache) is:
(1 << 10) * sizeof (hlist_head) + 4 * sizeof(unsigned int) = 2^13 + 16
and it is constant. In your way, for every sp, we need to zap:
512 entries + a hash-node = 2^12 + 8
especially the workload depends on the size of guest memory.
Why you think this way is better?

> - flush remote TLB (batched)
> - spin_unlock(mmu_lock)
> - free data (which is safe because freeing has its own serialization)

We should free the root sp in mmu-lock like my patch.

> - spin_lock(mmu_lock)
> - account for the pages freed
> - spin_unlock(mmu_lock)

The count numbers are still inconsistent if other thread hold mmu-lock between
zero shadow page and recount.

Marcelo, i really confused what is the benefit in this way but i might
completely misunderstand it.

