Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3H2JIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3H2JIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:08:38 -0400
Date: Thu, 29 Aug 2013 12:08:33 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130829090833.GA22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130828092001.GQ22899@redhat.com>
 <521DC3FD.1020507@linux.vnet.ibm.com>
 <20130828094630.GR22899@redhat.com>
 <521DCD57.7000401@linux.vnet.ibm.com>
 <20130828104938.GT22899@redhat.com>
 <521DE9E8.2040908@linux.vnet.ibm.com>
 <20130828133635.GU22899@redhat.com>
 <521EEF4B.4040107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521EEF4B.4040107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 02:50:51PM +0800, Xiao Guangrong wrote:
> >>> BTW I do not see
> >>> rcu_assign_pointer()/rcu_dereference() in your patches which hints on
> >>
> >> IIUC, We can not directly use rcu_assign_pointer(), that is something like:
> >> p = v to assign a pointer to a pointer. But in our case, we need:
> >>    *pte_list = (unsigned long)desc | 1;
> >>From Documentation/RCU/whatisRCU.txt:
> > 
> > The updater uses this function to assign a new value to an RCU-protected pointer.
> > 
> > This is what we do, no? (assuming slot->arch.rmap[] is what rcu protects here)
> > The fact that the value is not correct pointer should not matter.
> > 
> 
> Okay. Will change that code to:
> 
> +
> +#define rcu_assign_head_desc(pte_list_p, value)        \
> +       rcu_assign_pointer(*(unsigned long __rcu **)(pte_list_p), (unsigned long *)(value))
> +
>  /*
>   * Pte mapping structures:
>   *
> @@ -1006,14 +1010,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>                 desc->sptes[1] = spte;
>                 desc_mark_nulls(pte_list, desc);
> 
> -               /*
> -                * Esure the old spte has been updated into desc, so
> -                * that the another side can not get the desc from pte_list
> -                * but miss the old spte.
> -                */
> -               smp_wmb();
> -
> -               *pte_list = (unsigned long)desc | 1;
> +               rcu_assign_head_desc(pte_list, (unsigned long)desc | 1);
> 
> >>
> >> So i add the smp_wmb() by myself:
> >> 		/*
> >> 		 * Esure the old spte has been updated into desc, so
> >> 		 * that the another side can not get the desc from pte_list
> >> 		 * but miss the old spte.
> >> 		 */
> >> 		smp_wmb();
> >>
> >> 		*pte_list = (unsigned long)desc | 1;
> >>
> >> But i missed it when inserting a empty desc, in that case, we need the barrier
> >> too since we should make desc->more visible before assign it to pte_list to
> >> avoid the lookup side seeing the invalid "nulls".
> >>
> >> I also use own code instead of rcu_dereference():
> >> pte_list_walk_lockless():
> >> 	pte_list_value = ACCESS_ONCE(*pte_list);
> >> 	if (!pte_list_value)
> >> 		return;
> >>
> >> 	if (!(pte_list_value & 1))
> >> 		return fn((u64 *)pte_list_value);
> >>
> >> 	/*
> >> 	 * fetch pte_list before read sptes in the desc, see the comments
> >> 	 * in pte_list_add().
> >> 	 *
> >> 	 * There is the data dependence since the desc is got from pte_list.
> >> 	 */
> >> 	smp_read_barrier_depends();
> >>
> >> That part can be replaced by rcu_dereference().
> >>
> > Yes please, also see commit c87a124a5d5e8cf8e21c4363c3372bcaf53ea190 for
> > kind of scary bugs we can get here.
> 
> Right, it is likely trigger-able in our case, will fix it.
> 
> > 
> >>> incorrect usage of RCU. I think any access to slab pointers will need to
> >>> use those.
> >>
> >> Remove desc is not necessary i think since we do not mind to see the old
> >> info. (hlist_nulls_del_rcu() does not use rcu_dereference() too)
> >>
> > May be a bug. I also noticed that rculist_nulls uses rcu_dereference()
> 
> But list_del_rcu() does not use rcu_assign_pointer() too.
> 
This also suspicious.

> > to access ->next, but it does not use rcu_assign_pointer() pointer to
> > assign it.
> 
> You mean rcu_dereference() is used in hlist_nulls_for_each_entry_rcu()? I think
> it's because we should validate the prefetched data before entry->next is
> accessed, it is paired with the barrier in rcu_assign_pointer() when add a
> new entry into the list. rcu_assign_pointer() make other fields in the entry
> be visible before linking entry to the list. Otherwise, the lookup can access
> that entry but get the invalid fields.
> 
> After more thinking, I still think rcu_assign_pointer() is unneeded when a entry
> is removed. The remove-API does not care the order between unlink the entry and
> the changes to its fields. It is the caller's responsibility:
> - in the case of rcuhlist, the caller uses call_rcu()/synchronize_rcu(), etc to
>   enforce all lookups exit and the later change on that entry is invisible to the
>   lookups.
> 
> - In the case of rculist_nulls, it seems refcounter is used to guarantee the order
>   (see the example from Documentation/RCU/rculist_nulls.txt).
> 
> - In our case, we allow the lookup to see the deleted desc even if it is in slab cache
>   or its is initialized or it is re-added.
> 
> Your thought?
>

As Documentation/RCU/whatisRCU.txt says:
 
        As with rcu_assign_pointer(), an important function of
        rcu_dereference() is to document which pointers are protected by
        RCU, in particular, flagging a pointer that is subject to changing
        at any time, including immediately after the rcu_dereference().
        And, again like rcu_assign_pointer(), rcu_dereference() is
        typically used indirectly, via the _rcu list-manipulation
        primitives, such as list_for_each_entry_rcu().

The documentation aspect of rcu_assign_pointer()/rcu_dereference() is
important. The code is complicated, so self documentation will not hurt.
I want to see what is actually protected by rcu here. Freeing shadow
pages with call_rcu() further complicates matters: does it mean that
shadow pages are also protected by rcu? 

--
			Gleb.
