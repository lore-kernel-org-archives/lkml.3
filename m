Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3H1MPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:15:47 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55477 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3H1MPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:15:45 -0400
Message-ID: <521DE9E8.2040908@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 20:15:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828092001.GQ22899@redhat.com> <521DC3FD.1020507@linux.vnet.ibm.com> <20130828094630.GR22899@redhat.com> <521DCD57.7000401@linux.vnet.ibm.com> <20130828104938.GT22899@redhat.com>
In-Reply-To: <20130828104938.GT22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082812-2000-0000-0000-00000D7D81C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 06:49 PM, Gleb Natapov wrote:
> On Wed, Aug 28, 2013 at 06:13:43PM +0800, Xiao Guangrong wrote:
>> On 08/28/2013 05:46 PM, Gleb Natapov wrote:
>>> On Wed, Aug 28, 2013 at 05:33:49PM +0800, Xiao Guangrong wrote:
>>>>> Or what if desc is moved to another rmap, but then it
>>>>> is moved back to initial rmap (but another place in the desc list) so
>>>>> the check here will not catch that we need to restart walking?
>>>>
>>>> It is okay. We always add the new desc to the head, then we will walk
>>>> all the entires under this case.
>>>>
>>> Which races another question: What if desc is added in front of the list
>>> behind the point where lockless walker currently is?
>>
>> That case is new spte is being added into the rmap. We need not to care the
>> new sptes since it will set the dirty-bitmap then they can be write-protected
>> next time.
>>
> OK.
> 
>>>
>>>> Right?
>>> Not sure. While lockless walker works on a desc rmap can be completely
>>> destroyed and recreated again. It can be any order.
>>
>> I think the thing is very similar as include/linux/rculist_nulls.h
> include/linux/rculist_nulls.h is for implementing hash tables, so they
> may not care about add/del/lookup race for instance, but may be we are
> (you are saying above that we are not), so similarity does not prove
> correctness for our case. 

We do not care the "add" and "del" too when lookup the rmap. Under the "add"
case, it is okay, the reason i have explained above. Under the "del" case,
the spte becomes unpresent and flush all tlbs immediately, so it is also okay.

I always use a stupid way to check the correctness, that is enumerating
all cases we may meet, in this patch, we may meet these cases:

1) kvm deletes the desc before we are current on
   that descs have been checked, do not need to care it.

2) kvm deletes the desc after we are currently on
   Since we always add/del the head desc, we can sure the current desc has been
   deleted, then we will meet case 3).

3) kvm deletes the desc that we are currently on
   3.a): the desc stays in slab cache (do not be reused).
         all spte entires are empty, then the fn() will skip the nonprsent spte,
         and desc->more is
         3.a.1) still pointing to next-desc, then we will continue the lookup
         3.a.2) or it is the "nulls list", that means we reach the last one,
                then finish the walk.

   3.b): the desc is alloc-ed from slab cache and it's being initialized.
         we will see "desc->more == NULL" then restart the walking. It's okay.

   3.c): the desc is added to rmap or pte_list again.
         3.c.1): the desc is added to the current rmap again.
		 the new desc always acts as the head desc, then we will walk
                 all entries, some entries are double checked and not entry
                 can be missed. It is okay.

         3.c.2): the desc is added to another rmap or pte_list
                 since kvm_set_memory_region() and get_dirty are serial by slots-lock.
                 so the "nulls" can not be reused during lookup. Then we we will
                 meet the different "nulls" at the end of walking that will cause
                 rewalk.

I know check the algorithm like this is really silly, do you have other idea?

> BTW I do not see
> rcu_assign_pointer()/rcu_dereference() in your patches which hints on

IIUC, We can not directly use rcu_assign_pointer(), that is something like:
p = v to assign a pointer to a pointer. But in our case, we need:
   *pte_list = (unsigned long)desc | 1;

So i add the smp_wmb() by myself:
		/*
		 * Esure the old spte has been updated into desc, so
		 * that the another side can not get the desc from pte_list
		 * but miss the old spte.
		 */
		smp_wmb();

		*pte_list = (unsigned long)desc | 1;

But i missed it when inserting a empty desc, in that case, we need the barrier
too since we should make desc->more visible before assign it to pte_list to
avoid the lookup side seeing the invalid "nulls".

I also use own code instead of rcu_dereference():
pte_list_walk_lockless():
	pte_list_value = ACCESS_ONCE(*pte_list);
	if (!pte_list_value)
		return;

	if (!(pte_list_value & 1))
		return fn((u64 *)pte_list_value);

	/*
	 * fetch pte_list before read sptes in the desc, see the comments
	 * in pte_list_add().
	 *
	 * There is the data dependence since the desc is got from pte_list.
	 */
	smp_read_barrier_depends();

That part can be replaced by rcu_dereference().

> incorrect usage of RCU. I think any access to slab pointers will need to
> use those.

Remove desc is not necessary i think since we do not mind to see the old
info. (hlist_nulls_del_rcu() does not use rcu_dereference() too)



