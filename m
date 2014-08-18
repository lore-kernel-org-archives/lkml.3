Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHRSrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:47:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:36270 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:47:43 -0400
Message-ID: <53F24A49.2010807@redhat.com>
Date: Mon, 18 Aug 2014 20:47:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: gleb@kernel.org, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <53F20653.2030204@redhat.com> <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
In-Reply-To: <9AD43423-2FF3-422D-A5AD-61CAE6339CCC@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 18:35, Xiao Guangrong ha scritto:
> 
> Hi Paolo,
> 
> Thank you to review the patch!
> 
> On Aug 18, 2014, at 9:57 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> Il 14/08/2014 09:01, Xiao Guangrong ha scritto:
>>> -	update_memslots(slots, new, kvm->memslots->generation);
>>> +	/* ensure generation number is always increased. */
>>> +	slots->generation = old_memslots->generation;
>>> +	update_memslots(slots, new);
>>> 	rcu_assign_pointer(kvm->memslots, slots);
>>> 	synchronize_srcu_expedited(&kvm->srcu);
>>> +	slots->generation++;
>>
>> I don't trust my brain enough to review this patch.
> 
> Sorry to make you confused. I should expain it more clearly.

Don't worry, it's not your fault. :)

>> kvm_current_mmio_generation seems like a very bad (race-prone) API.  One
>> patch I trust myself reviewing would change a bunch of functions in
>> kvm_main.c to take a memslots struct.  This would make it easy to
>> respect the hard and fast rule of not dereferencing the same pointer
>> twice.  But it would be a tedious change.
> 
> kvm_set_memory_region is the only place updating memslot and
> kvm_current_mmio_generation accesses memslot by rcu-dereference,
> i do not know why other places need to take into account.

The race occurs because gfn_to_pfn_many_atomic or some other function
has already used kvm_memslots().  Calling kvm_memslots() twice is the
root cause the bug.

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
> 
> I do not know how the bit works, page fault will cache the memslot before
> the bit set and cache the generation-number after the bit set.
> 
> Maybe i missed your idea, could you please detail it?

Something like this:

-	update_memslots(slots, new, kvm->memslots->generation);
+	/* ensure generation number is always increased. */
+	slots->generation = old_memslots->generation + 1;
+	update_memslots(slots, new);
	rcu_assign_pointer(kvm->memslots, slots);
	synchronize_srcu_expedited(&kvm->srcu);
+	slots->generation++;

Then case 1 and 2 will just have a cache miss.

The "low bit" is really just because each slot update does 2 generation
increases.

Paolo
