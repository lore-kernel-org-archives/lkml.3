Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaHRSVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:21:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61470 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaHRSVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Aug 2014 11:20:41 -0700
Message-ID: <CALzav=fHM5na-bp0ydVgeYKw5EaO8XD_Z9JxhCbULiPxTPphAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 9:35 AM, Xiao Guangrong
<xiaoguangrong.eric@gmail.com> wrote:
>
> Hi Paolo,
>
> Thank you to review the patch!
>
> On Aug 18, 2014, at 9:57 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>> Il 14/08/2014 09:01, Xiao Guangrong ha scritto:
>>> -    update_memslots(slots, new, kvm->memslots->generation);
>>> +    /* ensure generation number is always increased. */
>>> +    slots->generation = old_memslots->generation;
>>> +    update_memslots(slots, new);
>>>      rcu_assign_pointer(kvm->memslots, slots);
>>>      synchronize_srcu_expedited(&kvm->srcu);
>>> +    slots->generation++;
>>
>> I don't trust my brain enough to review this patch.

Xiao, I thought about your approach a lot and I can't think of a bad race
that isn't already possible due to the fact that kvm allows memslot
mutation to race with vm exits. That being said, it's hard to reason about
all the other "clients" of memslots and what weirdness (or badness) will
be caused by updating generation after srcu_synch. I like Paolo's two
approaches because they fix the bug without any side-effects.

> Sorry to make you confused. I should expain it more clearly.
>
> What this patch tried to fix is:  kvm will generate wrong mmio-exit forever
> if no luck event cleans mmio spte. (eg. if no memory pressure or  no
> context-sync on that spte.)
>
> Note, it is hard to do precise sync between kvm_vm_ioctl_set_memory_region
> and mmio-exit - that means userspace is able to get mmio-exit even if
> kvm_vm_ioctl_set_memory_region have finished, for example, kvm identifies
> a mmio access before issuing the ioctl and injects mmio-exit to userspace after
> ioctl return. So checking if mmio-exit is a real mmio access in userspace is
> needed anyway.
>
>> kvm_current_mmio_generation seems like a very bad (race-prone) API.  One
>> patch I trust myself reviewing would change a bunch of functions in
>> kvm_main.c to take a memslots struct.  This would make it easy to
>> respect the hard and fast rule of not dereferencing the same pointer
>> twice.  But it would be a tedious change.
>
> kvm_set_memory_region is the only place updating memslot and
> kvm_current_mmio_generation accesses memslot by rcu-dereference,
> i do not know why other places need to take into account.

If you rcu_dereference() more than once, you can't trust previous
decisions based on rcu_dereference()'s. If the mmio cache code only
did one rcu_dereference() per vm exit, this bug would be gone.

> I think this patch is auditable, page-fault is always called by holding
> srcu-lock so that a page fault can’t go across synchronize_srcu_expedited.
> Only these cases can happen:
>
> 1)  page fault occurs before synchronize_srcu_expedited.
>     In this case, vcpu will generate mmio-exit for the memslot being registered
>     by the ioctl. That’s ok since the ioctl have not finished.
>
> 2) page fault occurs after synchronize_srcu_expedited and during
>    increasing generation-number.
>    In this case, userspace may get wrong mmio-exit (that happen if handing
>    page-fault is slower that the ioctl), that’s ok too since userspace need do
>   the check anyway like i said above.
>
> 3) page fault occurs after generation-number update
>    that’s definitely correct. :)
>
>> Another alternative could be to use the low bit to mark an in-progress
>> change, and skip the caching if the low bit is set.  Similar to a
>> seqcount (except if read_seqcount_retry fails, we just punt and not
>> retry anything), you could use it even though the memory barriers
>> provided by write_seqcount_begin/end are not too useful in this case.

I like this approach best. It would have the least code changes and provide
the same guarantees.

> I do not know how the bit works, page fault will cache the memslot before
> the bit set and cache the generation-number after the bit set.
>
> Maybe i missed your idea, could you please detail it?

In vcpu_cache_mmio_info() if generation is odd, just don't do the caching
because memslots were changed while we were running and we just assume the
worst case.
