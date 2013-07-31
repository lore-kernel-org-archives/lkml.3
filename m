Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866Ab3GaWQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3GaWQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:16:18 -0400
Message-ID: <51F98CAB.80100@redhat.com>
Date: Wed, 31 Jul 2013 18:16:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, dzickus@redhat.com, Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
References: <20130731174335.006a58f9@annuminas.surriel.com> <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
In-Reply-To: <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 06:07 PM, Linus Torvalds wrote:
> On Wed, Jul 31, 2013 at 2:43 PM, Rik van Riel <riel@redhat.com> wrote:
>>
>> The cause turned out to be unnecessary atomic accesses to the
>> mm_cpumask. When in lazy TLB mode, the CPU is only removed from
>> the mm_cpumask if there is a TLB flush event.
>>
>> Most of the time, no such TLB flush happens, and the kernel
>> skips the TLB reload.  It can also skip the atomic memory
>> set & test.
>
> The patch looks obvious, and I'm not seeing any very clear reasons for
> why we would want that test-and-set to be atomic. That said, I'd like
> to have some explicit comments about exactly why it doesn't need the
> atomicity. Because afaik, there actually are concurrent readers _and_
> writers of that mask, and the accesses are not locked by anything
> here.
 >
> I _think_ the reason for this all being safe is simply that the only
> real race is "We need to set the bit before we load the page table,
> and we're protected against that bit being cleared because the TLB
> state is TLBSTATE_OK and thus TLB flushing will no longer leave that
> mm".
>
> But damn, it all looks subtle as hell. That code does:
>
>                  this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
>                  BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
>
>                  if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
>
> and I'm wondering if we need a barrier to make sure that that
> TLBSTATE_OK write happens *before* we test the cpumask. With
> test_and_set(), we have the barrier in the test-and-set. But with just
> test_bit, I'm not seeing why the compiler couldn't re-order them. I
> suspect it won't, but...

cpumask_set_bit expands to set_bit, which is atomic

Do we need any explicit compiler barrier in addition to the
atomic operation performed by set_bit?

I would be happy to rewrite the comment right above the
cpumask_set_cpu call if you want.

-- 
All rights reversed
