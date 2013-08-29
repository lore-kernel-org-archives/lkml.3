Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3H2L0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:26:51 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47477 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3H2L0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:26:50 -0400
Message-ID: <521F2FF0.9060105@linux.vnet.ibm.com>
Date: Thu, 29 Aug 2013 19:26:40 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <20130828092001.GQ22899@redhat.com> <521DC3FD.1020507@linux.vnet.ibm.com> <20130828094630.GR22899@redhat.com> <521DCD57.7000401@linux.vnet.ibm.com> <20130828104938.GT22899@redhat.com> <521DE9E8.2040908@linux.vnet.ibm.com> <20130828133635.GU22899@redhat.com> <521EEF4B.4040107@linux.vnet.ibm.com> <20130829090833.GA22899@redhat.com> <521F14FE.3070900@linux.vnet.ibm.com> <20130829095120.GD22899@redhat.com>
In-Reply-To: <20130829095120.GD22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082911-1618-0000-0000-000004894B3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 05:51 PM, Gleb Natapov wrote:
> On Thu, Aug 29, 2013 at 05:31:42PM +0800, Xiao Guangrong wrote:
>>> As Documentation/RCU/whatisRCU.txt says:
>>>
>>>         As with rcu_assign_pointer(), an important function of
>>>         rcu_dereference() is to document which pointers are protected by
>>>         RCU, in particular, flagging a pointer that is subject to changing
>>>         at any time, including immediately after the rcu_dereference().
>>>         And, again like rcu_assign_pointer(), rcu_dereference() is
>>>         typically used indirectly, via the _rcu list-manipulation
>>>         primitives, such as list_for_each_entry_rcu().
>>>
>>> The documentation aspect of rcu_assign_pointer()/rcu_dereference() is
>>> important. The code is complicated, so self documentation will not hurt.
>>> I want to see what is actually protected by rcu here. Freeing shadow
>>> pages with call_rcu() further complicates matters: does it mean that
>>> shadow pages are also protected by rcu? 
>>
>> Yes, it stops shadow page to be freed when we do write-protection on
>> it.
>>
> Yeah, I got the trick, what I am saying that we have a data structure
> here protected by RCU, but we do not use RCU functions to access it...

Yes, they are not used when insert a spte into rmap and get the rmap from
the entry... but do we need to use these functions to guarantee the order?

The worst case is, we fetch the spte from the desc but the spte is not
updated yet, we can happily skip this spte since it will set the
dirty-bitmap later, this is guaranteed by the barrier between mmu_spte_update()
and mark_page_dirty(), the code is:

set_spte():

	if (mmu_spte_update(sptep, spte))
		kvm_flush_remote_tlbs(vcpu->kvm);

	if (!remap) {
		if (rmap_add(vcpu, sptep, gfn) > RMAP_RECYCLE_THRESHOLD)
			rmap_recycle(vcpu, sptep, gfn);

		if (level > PT_PAGE_TABLE_LEVEL)
			++vcpu->kvm->stat.lpages;
	}

	smp_wmb();

	if (pte_access & ACC_WRITE_MASK)
		mark_page_dirty(vcpu->kvm, gfn);

So, i guess if we can guaranteed the order by ourself, we do not need
to call the rcu functions explicitly...

But, the memory barres in the rcu functions are really light on x86 (store
can not be reordered with store), so i do not mind to explicitly use them
if you think this way is more safe. :)

> BTW why not allocate sp->spt from SLAB_DESTROY_BY_RCU cache too? We may
> switch write protection on a random spt occasionally if page is deleted
> and reused for another spt though. For last level spt it should not be a
> problem and for non last level we have is_last_spte() check in
> __rmap_write_protect_lockless(). Can it work?

Yes, i also considered this way. It can work if we handle is_last_spte()
properly. Since the sp->spte can be reused, we can not get the mapping
level from sp. We need to encode the mapping level into spte so that
cmpxhg can understand if the page table has been moved to another mapping
level. Could you allow me to make this optimization separately after this
patchset be merged?




