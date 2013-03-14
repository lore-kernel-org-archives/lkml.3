Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3CNEm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:42:29 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57064 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3CNEmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:42:20 -0400
Message-ID: <51415521.7060506@linux.vnet.ibm.com>
Date: Thu, 14 Mar 2013 12:42:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: fast zap all shadow pages
References: <514006AC.2020904@linux.vnet.ibm.com> <514007A0.1040400@linux.vnet.ibm.com> <20130314010706.GC3851@amt.cnet> <20130314013525.GA11710@amt.cnet>
In-Reply-To: <20130314013525.GA11710@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031404-9574-0000-0000-000007014FAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 09:35 AM, Marcelo Tosatti wrote:
> On Wed, Mar 13, 2013 at 10:07:06PM -0300, Marcelo Tosatti wrote:
>> On Wed, Mar 13, 2013 at 12:59:12PM +0800, Xiao Guangrong wrote:
>>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
>>> walk and zap all shadow pages one by one, also it need to zap all guest
>>> page's rmap and all shadow page's parent spte list. Particularly, things
>>> become worse if guest uses more memory or vcpus. It is not good for
>>> scalability.
>>>
>>> Since all shadow page will be zapped, we can directly zap the mmu-cache
>>> and rmap so that vcpu will fault on the new mmu-cache, after that, we can
>>> directly free the memory used by old mmu-cache.
>>>
>>> The root shadow page is little especial since they are currently used by
>>> vcpus, we can not directly free them. So, we zap the root shadow pages and
>>> re-add them into the new mmu-cache.
>>>
>>> After this patch, kvm_mmu_zap_all can be faster 113% than before
>>>
>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>> ---
>>>  arch/x86/kvm/mmu.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++-----
>>>  1 files changed, 56 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>> index e326099..536d9ce 100644
>>> --- a/arch/x86/kvm/mmu.c
>>> +++ b/arch/x86/kvm/mmu.c
>>> @@ -4186,18 +4186,68 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>>>
>>>  void kvm_mmu_zap_all(struct kvm *kvm)
>>>  {
>>> -	struct kvm_mmu_page *sp, *node;
>>> +	LIST_HEAD(root_mmu_pages);
>>>  	LIST_HEAD(invalid_list);
>>> +	struct list_head pte_list_descs;
>>> +	struct kvm_mmu_cache *cache = &kvm->arch.mmu_cache;
>>> +	struct kvm_mmu_page *sp, *node;
>>> +	struct pte_list_desc *desc, *ndesc;
>>> +	int root_sp = 0;
>>>
>>>  	spin_lock(&kvm->mmu_lock);
>>> +
>>>  restart:
>>> -	list_for_each_entry_safe(sp, node,
>>> -	      &kvm->arch.mmu_cache.active_mmu_pages, link)
>>> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
>>> -			goto restart;
>>> +	/*
>>> +	 * The root shadow pages are being used on vcpus that can not
>>> +	 * directly removed, we filter them out and re-add them to the
>>> +	 * new mmu cache.
>>> +	 */
>>> +	list_for_each_entry_safe(sp, node, &cache->active_mmu_pages, link)
>>> +		if (sp->root_count) {
>>> +			int ret;
>>> +
>>> +			root_sp++;
>>> +			ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>>> +			list_move(&sp->link, &root_mmu_pages);
>>> +			if (ret)
>>> +				goto restart;
>>> +		}
>>
>> Why is it safe to skip flushing of root pages, for all
>> kvm_flush_shadow() callers?
> 
> You are not skipping the flush, only moving to the new mmu cache.
> 
>> Should revisit KVM_REQ_MMU_RELOAD... not clear it is necessary for NPT
>> (unrelated).
> 
> Actually, what i meant is: you can batch KVM_REQ_MMU_RELOAD requests to
> the end of kvm_mmu_zap_all. Waking up vcpus is not optimal since they're
> going to contend for mmu_lock anyway.

Yes, I agree. Will move KVM_REQ_MMU_RELOAD to the end of kvm_mmu_zap_all in
the V2.

BTW, the TLB flushed is not needed if no root shadow page zapped since all
vcpus are not using shadow pages. The code may be simplified to (after batch
KVM_REQ_MMU_RELOAD):

if (root_sp)
	kvm_reload_remote_mmus()
> 
> Need more time to have more useful comments to this patchset, sorry.

No problem. ;) The current comments is really useful for me.


