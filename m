Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966246Ab3E2Nnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:43:39 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44519 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965895Ab3E2Nng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:43:36 -0400
Message-ID: <51A605FC.8060802@linux.vnet.ibm.com>
Date: Wed, 29 May 2013 21:43:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce kvm_mmu_prepare_zap_obsolete_page
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130528001302.GA1359@amt.cnet> <51A4C47A.7090405@linux.vnet.ibm.com> <20130529122552.GB5931@amt.cnet>
In-Reply-To: <20130529122552.GB5931@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052913-2674-0000-0000-0000092711DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 08:25 PM, Marcelo Tosatti wrote:
> On Tue, May 28, 2013 at 10:51:38PM +0800, Xiao Guangrong wrote:
>> On 05/28/2013 08:13 AM, Marcelo Tosatti wrote:
>>> On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
>>>> It is only used to zap the obsolete page. Since the obsolete page
>>>> will not be used, we need not spend time to find its unsync children
>>>> out. Also, we delete the page from shadow page cache so that the page
>>>> is completely isolated after call this function.
>>>>
>>>> The later patch will use it to collapse tlb flushes
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
>>>>  1 files changed, 41 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>> index 9b57faa..e676356 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>>>>  {
>>>>  	ASSERT(is_empty_shadow_page(sp->spt));
>>>> -	hlist_del(&sp->hash_link);
>>>> +	hlist_del_init(&sp->hash_link);
>>>>  	list_del(&sp->link);
>>>>  	free_page((unsigned long)sp->spt);
>>>>  	if (!sp->role.direct)
>>>> @@ -2069,14 +2069,19 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>>>>  	return zapped;
>>>>  }
>>>>  
>>>> -static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>>> -				    struct list_head *invalid_list)
>>>> +static int
>>>> +__kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>>> +			   bool zap_unsync_children,
>>>> +			   struct list_head *invalid_list)
>>>>  {
>>>> -	int ret;
>>>> +	int ret = 0;
>>>>  
>>>>  	trace_kvm_mmu_prepare_zap_page(sp);
>>>>  	++kvm->stat.mmu_shadow_zapped;
>>>> -	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>>> +
>>>> +	if (likely(zap_unsync_children))
>>>> +		ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
>>>> +
>>>
>>> Why is this an important case to be optimized?
>>>
>>> 1) shadow is the uncommon, obsolete case.
>>> 2) mmu_zap_unsync_children has
>>>
>>>         if (parent->role.level == PT_PAGE_TABLE_LEVEL)
>>>                 return 0;
>>>
>>> So the large majority of pages are already optimized.
>>
>> Hmm, if we zap the high level page (e.g level = 4), it should walk its
>> children and its children's children. It is high overload.
>> (IMHO, trivial optimization is still necessary, especially, the change
>> is really slight.)
>>
>> And, there is another point me mentioned in the changelog:
>> "Also, we delete the page from shadow page cache so that the page
>> is completely isolated after call this function."
>> Skipping zapping unsync-children can ensure that only one page is
>> zapped so that we can use "hlist_del_init(&sp->hash_link)" to completely
>> remove the page from mmu-cache.
>>
>> Now, Gleb and i got a agreement that skipping obsolete page when
>> walking hash list is a better way.
>>
>> BTW, zapping unsync-children is unnecessary, is it?
> 
> It is necessary that if an unsync page exists, that 
> invlpg emulation is able to reach it, or that at kvm_mmu_get_page 
> time they are synchronized.

Hmmm? It is not always better.

If unsync pages is zapped, mmu will map a new alloced-page which all
of its entries are nonpresent. It can cause more #PF than the case
we sync the page.
Especially, for the invlpg case, in that case you zap the page which
still have been being mapped on other vcpu's page table which currently
being used.

And, It does the further-possible work at once - spend time to walk/zap all
the unsync children but they may not be used at all. So delaying this work
until they are used is better.

> 
> You transfer the synchronization work to pagefault time, which directly
> affects guest performance, while it could have been done by the host
> (this was the reason for zapping unsync children).

It seem no, most case doing zap_page is in the vcpu context, not host.


