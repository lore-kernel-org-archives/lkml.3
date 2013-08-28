Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3H1JTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:19:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35353 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3H1JTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:19:33 -0400
Message-ID: <521DC09B.2070000@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 17:19:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 07/12] KVM: MMU: redesign the algorithm of pte_list
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828081205.GN22899@redhat.com> <521DB6CC.4030107@linux.vnet.ibm.com> <20130828085841.GP22899@redhat.com>
In-Reply-To: <20130828085841.GP22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082820-3568-0000-0000-0000042656E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 04:58 PM, Gleb Natapov wrote:
> On Wed, Aug 28, 2013 at 04:37:32PM +0800, Xiao Guangrong wrote:
>> On 08/28/2013 04:12 PM, Gleb Natapov wrote:
>>
>>>> +
>>>> +	rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
>>>> +	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
>>>> +
>>>> +	/* No empty position in the desc. */
>>>> +	if (desc->sptes[PTE_LIST_EXT - 1]) {
>>>> +		struct pte_list_desc *new_desc;
>>>> +		new_desc = mmu_alloc_pte_list_desc(vcpu);
>>>> +		new_desc->more = desc;
>>>> +		desc = new_desc;
>>>> +		*pte_list = (unsigned long)desc | 1;
>>>>  	}
>>>> -	return count;
>>>> +
>>>> +	free_pos = find_first_free(desc);
>>>> +	desc->sptes[free_pos] = spte;
>>>> +	return count_spte_number(desc);
>>> Should it be count_spte_number(desc) - 1? The function should returns
>>> the number of pte entries before the spte was added.
>>
>> Yes. We have handled it count_spte_number(), we count the number like this:
>>
>> 	return first_free + desc_num * PTE_LIST_EXT;
>>
>> The first_free is indexed from 0.
>>
> Suppose when pte_list_add() is called there is one full desc, so the
> number that should be returned is PTE_LIST_EXT, correct? But since
> before calling count_spte_number() one more desc will be added and
> desc->sptes[0] will be set in it the first_free in count_spte_number
> will be 1 and PTE_LIST_EXT + 1 will be returned.

Oh, yes, you are right. Will fix it in the next version, thanks for you
pointing it out.

> 
>> Maybe it is clearer to let count_spte_number() return the real number.
>>
>>>
>>>>  }
>>>>  
>>>>  static void
>>>> -pte_list_desc_remove_entry(unsigned long *pte_list, struct pte_list_desc *desc,
>>>> -			   int i, struct pte_list_desc *prev_desc)
>>>> +pte_list_desc_remove_entry(unsigned long *pte_list,
>>>> +			   struct pte_list_desc *desc, int i)
>>>>  {
>>>> -	int j;
>>>> +	struct pte_list_desc *first_desc;
>>>> +	int last_used;
>>>> +
>>>> +	first_desc = (struct pte_list_desc *)(*pte_list & ~1ul);
>>>> +	last_used = find_last_used(first_desc);
>>>>  
>>>> -	for (j = PTE_LIST_EXT - 1; !desc->sptes[j] && j > i; --j)
>>>> -		;
>>>> -	desc->sptes[i] = desc->sptes[j];
>>>> -	desc->sptes[j] = NULL;
>>>> -	if (j != 0)
>>>> +	/*
>>>> +	 * Move the entry from the first desc to this position we want
>>>> +	 * to remove.
>>>> +	 */
>>>> +	desc->sptes[i] = first_desc->sptes[last_used];
>>>> +	first_desc->sptes[last_used] = NULL;
>>>> +
>>> What if desc == first_desc and i < last_used. You still move spte
>>> backwards so lockless walk may have already examined entry at i and
>>> will miss spte that was moved there from last_used position, no?
>>
>> Right. I noticed it too and fixed in the v2 which is being tested.
>> I fixed it by bottom-up walk desc, like this:
>>
>> pte_list_walk_lockless():
>>
>> 	desc = (struct pte_list_desc *)(pte_list_value & ~1ul);
>> 	while (!desc_is_a_nulls(desc)) {
>> 		/*
>> 		 * We should do bottom-up walk since we always use the
>> 		 * bottom entry to replace the deleted entry if only
>> 		 * one desc is used in the rmap when a spte is removed.
>> 		 * Otherwise the moved entry will be missed.
>> 		 */
> I would call it top-down walk since we are walking from big indices to
> smaller once.

Okay, will fix the comments.

> 
>> 		for (i = PTE_LIST_EXT - 1; i >= 0; i--)
>> 			fn(desc->sptes[i]);
>>
>> 		desc = ACCESS_ONCE(desc->more);
>>
>> 		/* It is being initialized. */
>> 		if (unlikely(!desc))
>> 			goto restart;
>> 	}
>>
>> How about this?
>>
> Tricky, very very tricky :)
> 
>>>
>>>> +	/* No valid entry in this desc, we can free this desc now. */
>>>> +	if (!first_desc->sptes[0]) {
>>>> +		struct pte_list_desc *next_desc = first_desc->more;
>>>> +
>>>> +		/*
>>>> +		 * Only one entry existing but still use a desc to store it?
>>>> +		 */
>>>> +		WARN_ON(!next_desc);
>>>> +
>>>> +		mmu_free_pte_list_desc(first_desc);
>>>> +		first_desc = next_desc;
>>>> +		*pte_list = (unsigned long)first_desc | 1ul;
>>>>  		return;
>>>> -	if (!prev_desc && !desc->more)
>>>> -		*pte_list = (unsigned long)desc->sptes[0];
>>>> -	else
>>>> -		if (prev_desc)
>>>> -			prev_desc->more = desc->more;
>>>> -		else
>>>> -			*pte_list = (unsigned long)desc->more | 1;
>>>> -	mmu_free_pte_list_desc(desc);
>>>> +	}
>>>> +
>>>> +	WARN_ON(!first_desc->sptes[0]);
>>>> +
>>>> +	/*
>>>> +	 * Only one entry in this desc, move the entry to the head
>>>> +	 * then the desc can be freed.
>>>> +	 */
>>>> +	if (!first_desc->sptes[1] && !first_desc->more) {
>>>> +		*pte_list = (unsigned long)first_desc->sptes[0];
>>>> +		mmu_free_pte_list_desc(first_desc);
>>>> +	}
>>>>  }
>>>>  
>>>>  static void pte_list_remove(u64 *spte, unsigned long *pte_list)
>>>>  {
>>>>  	struct pte_list_desc *desc;
>>>> -	struct pte_list_desc *prev_desc;
>>>>  	int i;
>>>>  
>>>>  	if (!*pte_list) {
>>>> -		printk(KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
>>>> -		BUG();
>>>> -	} else if (!(*pte_list & 1)) {
>>>> +		WARN(1, KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
>>> Why change BUG() to WARN() here and below?
>>
>> WARN(1, "xxx") can replace two lines in the origin code. And personally,
>> i prefer WARN() to BUG() since sometimes BUG() can stop my box and i need to
>> get the full log by using kdump.
>>
>> If you object it, i will change it back in the next version. :)
>>
> For debugging WARN() is doubtlessly better, but outside of development
> you do not want to allow kernel to run after serious MMU corruption is
> detected. It may be exploitable further, we do not know, so the safe
> choice is to stop the kernel.

Okay, will keep BUG() in the next version.



