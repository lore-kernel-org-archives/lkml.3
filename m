Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3H1JeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:34:02 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58124 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3H1Jd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:33:59 -0400
Message-ID: <521DC3FD.1020507@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 17:33:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828092001.GQ22899@redhat.com>
In-Reply-To: <20130828092001.GQ22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082809-4790-0000-0000-00000A0530B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 05:20 PM, Gleb Natapov wrote:
> On Tue, Jul 30, 2013 at 09:02:07PM +0800, Xiao Guangrong wrote:
>> The basic idea is from nulls list which uses a nulls to indicate
>> whether the desc is moved to different pte-list
>>
>> Thanks to SLAB_DESTROY_BY_RCU, the desc can be quickly reused
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 36caf6a..f8fc0cc 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1010,6 +1010,14 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>>  		desc->sptes[0] = (u64 *)*pte_list;
>>  		desc->sptes[1] = spte;
>>  		desc_mark_nulls(pte_list, desc);
>> +
>> +		/*
>> +		 * Esure the old spte has been updated into desc, so
>> +		 * that the another side can not get the desc from pte_list
>> +		 * but miss the old spte.
>> +		 */
>> +		smp_wmb();
>> +
>>  		*pte_list = (unsigned long)desc | 1;
>>  		return 1;
>>  	}
>> @@ -1131,6 +1139,47 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
>>  	WARN_ON(desc_get_nulls_value(desc) != pte_list);
>>  }
>>  
>> +/* The caller should hold rcu lock. */
>> +typedef void (*pte_list_walk_lockless_fn) (u64 *spte, int level);
>> +static void pte_list_walk_lockless(unsigned long *pte_list,
>> +				   pte_list_walk_lockless_fn fn, int level)
>> +{
>> +	struct pte_list_desc *desc;
>> +	unsigned long pte_list_value;
>> +	int i;
>> +
>> +restart:
>> +	pte_list_value = ACCESS_ONCE(*pte_list);
>> +	if (!pte_list_value)
>> +		return;
>> +
>> +	if (!(pte_list_value & 1))
>> +		return fn((u64 *)pte_list_value, level);
>> +
>> +	/*
>> +	 * fetch pte_list before read sptes in the desc, see the comments
>> +	 * in pte_list_add().
>> +	 *
>> +	 * There is the data dependence since the desc is got from pte_list.
>> +	 */
>> +	smp_read_barrier_depends();
>> +
>> +	desc = (struct pte_list_desc *)(pte_list_value & ~1ul);
>> +	while (!desc_is_a_nulls(desc)) {
>> +		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
>> +			fn(desc->sptes[i], level);
>> +
>> +		desc = ACCESS_ONCE(desc->more);
>> +
>> +		/* It is being initialized. */
>> +		if (unlikely(!desc))
>> +			goto restart;
>> +	}
>> +
>> +	if (unlikely(desc_get_nulls_value(desc) != pte_list))
>> +		goto restart;
> So is it really enough to guaranty safety and correctness? What if desc
> is moved to another rmap while we walking it so fn() is called on
> incorrect sptes? 

Then fn() will do needless write-protection. It is the unnecessary work
but it is acceptable for the rare case.

There has a bug that we can not detect mapping level from rmap since
the desc can be moved as you said, it can case we do write-protection
on the middle spte. Can fix it by getting mapping level from sp->role.level
since sp can not be reused when rcu is hold.

> Or what if desc is moved to another rmap, but then it
> is moved back to initial rmap (but another place in the desc list) so
> the check here will not catch that we need to restart walking?

It is okay. We always add the new desc to the head, then we will walk
all the entires under this case.

Right?

