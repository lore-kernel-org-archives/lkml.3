Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbaGWXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:06:28 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36291 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbaGWXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1407231752350.20654@gentwo.org>
References: <1405913633-4619-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407231752350.20654@gentwo.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 19:05:54 -0400
Message-ID: <CAJhHMCCXFEwZmUPsTo+nKuLj=n4m0fNB3Jt2NLWNnAcMH8r7Yw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] doc: Add remote CPU access details and others to this_cpu_ops.txt
To: Christoph Lameter <cl@gentwo.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 6:58 PM, Christoph Lameter <cl@gentwo.org> wrote:
> On Sun, 20 Jul 2014, Pranith Kumar wrote:
>
>> -this_cpu ops are interrupt safe. Some architecture do not support
>> +this_cpu ops are interrupt safe. Some architectures do not support
>>  these per cpu local operations. In that case the operation must be
>>  replaced by code that disables interrupts, then does the operations
>>  that are guaranteed to be atomic and then reenable interrupts. Doing
>>  so is expensive. If there are other reasons why the scheduler cannot
>>  change the processor we are executing on then there is no reason to
>> -disable interrupts. For that purpose the __this_cpu operations are
>> -provided. For example.
>> +disable interrupts. For that purpose the following __this_cpu operations
>> +are provided.
>> +
>> +These operations have no guarantee against concurrent interrupts or
>> +preemption. If a per cpu variable is not used in an interrupt context
>> +and the scheduler cannot preempt then they are safe.
>> +
>> +Note that interrupts may still occur while an operation is
>> +in progress and if the interrupt too modifies the variable, then RMW
>> +actions may not be atomic.
>
> This paragraph is restating what the one before already said. Make these
> two one paragraph and condense a bit?

OK, I will fix this.

>
>
>> +Remote access to per cpu data
>> +------------------------------
>> +
>> +Per cpu data structures are designed to be used by one cpu exclusively.
>> +If you use the variables as intended, this_cpu_ops() are guaranteed to
>> +be "atomic" as no other CPU has access to these data structures. In this
>> +context, a remote access means an access to a per cpu data structure
>> +from a CPU without using the this_cpu_* operations.
>> +
>> +There are special cases where you might need to access per cpu data
>> +structures remotely. One such case is to perform maintenance tasks of
>> +idle CPUs without having to wake them up using IPIs for power saving
>> +purposes. It is usually safe to do a remote read access and that is
>> +frequently done to summarize counters. Remote write access is the one
>> +which is problematic. This is not recommended unless absolutely
>> +necessary. Remote write accesses to per cpu data structures are highly
>
> Two sentences making the same point.
>

The idea is to *strongly* discourage use of remote accesses ;)
I will fix this too.

>> +discouraged. Please consider using an IPI to wake up the remote CPU and
>> +perform the update to its per cpu area.
>
>
>> +
>> +
>> +     struct test {
>> +             atomic_t a;
>> +             int b;
>> +     };
>> +
>> +     DEFINE_PER_CPU(struct test, onecacheline);
>> +
>> +You cannot update the field 'a' remotely from one processor and expect
>> +this_cpu ops to work on the field b from the local CPU with atomic
>> +semantics. Care should be taken that such simultaneous access to data
>> +within the same cache line is avoided. Also costly synchronization is
>> +necessary when you are unsure of such cases. IPI is generally recommeded
>> +in such scenarios instead of remote write to per cpu areas.
>> +
>> +Given these drawbacks, it is adviced to seriously consider the option of
>> +not using per cpu areas when you have a high rate of remote writes.
>
> Well even any low late of remote writes still evicts the performance
> sensitive  cacheline from the processor that needs it. Should it be asleep
> and wake up then it will be missing the cacheline so the wakeup times are
> prolonged.
>
>

Yes, that can be the case. Should I add this para to the text?


-- 
Pranith
