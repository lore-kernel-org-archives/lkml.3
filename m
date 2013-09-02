Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3IBIue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:50:34 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35147 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3IBIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:50:32 -0400
Message-ID: <5224514A.4040307@linux.vnet.ibm.com>
Date: Mon, 02 Sep 2013 16:50:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <521DC3FD.1020507@linux.vnet.ibm.com> <20130828094630.GR22899@redhat.com> <521DCD57.7000401@linux.vnet.ibm.com> <20130828104938.GT22899@redhat.com> <521DE9E8.2040908@linux.vnet.ibm.com> <20130828133635.GU22899@redhat.com> <521EEF4B.4040107@linux.vnet.ibm.com> <20130829093141.GC22899@redhat.com> <521F319B.9000006@linux.vnet.ibm.com> <521F3856.70305@linux.vnet.ibm.com> <20130830114426.GB1844@redhat.com>
In-Reply-To: <20130830114426.GB1844@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090208-9574-0000-0000-0000096F55A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 07:44 PM, Gleb Natapov wrote:
> On Thu, Aug 29, 2013 at 08:02:30PM +0800, Xiao Guangrong wrote:
>> On 08/29/2013 07:33 PM, Xiao Guangrong wrote:
>>> On 08/29/2013 05:31 PM, Gleb Natapov wrote:
>>>> On Thu, Aug 29, 2013 at 02:50:51PM +0800, Xiao Guangrong wrote:
>>>>> After more thinking, I still think rcu_assign_pointer() is unneeded when a entry
>>>>> is removed. The remove-API does not care the order between unlink the entry and
>>>>> the changes to its fields. It is the caller's responsibility:
>>>>> - in the case of rcuhlist, the caller uses call_rcu()/synchronize_rcu(), etc to
>>>>>   enforce all lookups exit and the later change on that entry is invisible to the
>>>>>   lookups.
>>>>>
>>>>> - In the case of rculist_nulls, it seems refcounter is used to guarantee the order
>>>>>   (see the example from Documentation/RCU/rculist_nulls.txt).
>>>>>
>>>>> - In our case, we allow the lookup to see the deleted desc even if it is in slab cache
>>>>>   or its is initialized or it is re-added.
>>>>>
>>>> BTW is it a good idea? We can access deleted desc while it is allocated
>>>> and initialized to zero by kmem_cache_zalloc(), are we sure we cannot
>>>> see partially initialized desc->sptes[] entry? On related note what about
>>>> 32 bit systems, they do not have atomic access to desc->sptes[].
>>
>> Ah... wait. desc is a array of pointers:
>>
>> struct pte_list_desc {
>> 	u64 *sptes[PTE_LIST_EXT];
>> 	struct pte_list_desc *more;
>> };
>>
> Yep, I misread it to be u64 bits and wondered why do we use u64 to store
> pointers.
> 
>> assigning a pointer is aways aotomic, but we should carefully initialize it
>> as you said. I will introduce a constructor for desc slab cache which initialize
>> the struct like this:
>>
>> for (i = 0; i < PTE_LIST_EXT; i++)
>> 	desc->sptes[i] = NULL;
>>
>> It is okay.
>>
> I hope slab does not write anything into allocated memory internally if
> constructor is present. 

If only constructor is present (no SLAB_DESTROY_BY_RCU), It'll temporarily
write the "poison" value into the memory then call the constructor to initialize
it again, e.g, in slab.c:

static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
				gfp_t flags, void *objp, unsigned long caller)
{
		if (cachep->flags & SLAB_POISON) {
		......
		poison_obj(cachep, objp, POISON_INUSE);
		}
	......
	if (cachep->ctor && cachep->flags & SLAB_POISON)
		cachep->ctor(objp);
}

But SLAB_DESTROY_BY_RCU can force the allocer to don't touch
the memory, this is true in our case.

> BTW do you know what happens when SLAB debug is enabled
> and SLAB_DESTROY_BY_RCU is set? 

When SLAB debug is enabled, these 3 flags may be set:
#define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
#define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
#define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */

Only SLAB_POISON can write something into the memory, and ...

> Does poison value is written into freed
> object (freed to slab, but not yet to page allocator)?

SLAB_POISON is cleared if SLAB_DESTROY_BY_RCU is used.
- In slab,  There is the code in __kmem_cache_create():
  	if (flags & SLAB_DESTROY_BY_RCU)
		BUG_ON(flags & SLAB_POISON);

- In slub, the code is in calculate_sizes():
	/*
	 * Determine if we can poison the object itself. If the user of
	 * the slab may touch the object after free or before allocation
	 * then we should never poison the object itself.
	 */
	if ((flags & SLAB_POISON) && !(flags & SLAB_DESTROY_BY_RCU) &&
			!s->ctor)
		s->flags |= __OBJECT_POISON;
	else
		s->flags &= ~__OBJECT_POISON;

- in slob, it seems it does not support SLAB DEBUG.

