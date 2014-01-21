Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaAUGhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:37:35 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63941 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAUGhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:37:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140120102051.GB16496@mudshark.cambridge.arm.com>
References: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
	<20140120102051.GB16496@mudshark.cambridge.arm.com>
Date: Tue, 21 Jan 2014 12:07:31 +0530
Message-ID: <CAJ8eaTwH3kov0Bo_sCDvgxzQWtRB2tKit=_rKFBhQ6jBZcND-A@mail.gmail.com>
Subject: Re: BUG: spinlock lockup
From: naveen yadav <yad.naveen@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Will,

Thanks for your reply,

We are using Cortex A15.
yes,  this is with ticket lock.

We will check value of arch_spinlock_t and share it. It is bit
difficult to reproduce this scenario.

If you have some idea ,please suggest how to reproduce it.

thanks

On Mon, Jan 20, 2014 at 3:50 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Sat, Jan 18, 2014 at 07:25:51AM +0000, naveen yadav wrote:
>> We are using 3.8.x  kernel on ARM, We are facing soft lockup issue.
>> Following are the logs.
>
> Which CPU/SoC are you using?


>
>> BUG: spinlock lockup suspected on CPU#0, process1/525
>> lock: 0xd8ac9a64, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
>>
>>
>> 1 . Looks like lock is available as owner is -1, why arch_spin_trylock
>> is getting failed ?
>
> Is this with or without the ticket lock patches? Can you inspect the actual
> value of the arch_spinlock_t?

>
>> 2. There is a patch : ARM: spinlock: retry trylock operation if strex
>> fails on free lock
>> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/240913
>> In this patch, A loop has been added around strexeq %2, %0, [%3]".
>> {Comment "retry the trylock operation if the lock appears
>> to be free but the strex reported failure"}
>>
>> but arch_spin_trylock is called by __spin_lock_debug and its already
>> getting called in loops. So what purpose is resolves?
>
> Does this patch help your issue? The purpose of it is to distinguish between
> two types of contention:
>
>   (1) The lock is actually taken
>   (2) The lock is free, but two people are doing a trylock at the same time
>
> In the case of (2), we do actually want to spin again otherwise you could
> potentially end up in a pathological case where the two CPUs repeatedly
> shoot down each other's monitor and forward progress isn't made until the
> sequence is broken by something like an interrupt.
>
>> static void __spin_lock_debug(raw_spinlock_t *lock)
>> {
>>         u64 i;
>>         u64 loops = loops_per_jiffy * HZ;
>>
>>         for (i = 0; i < loops; i++) {
>>                 if (arch_spin_trylock(&lock->raw_lock))
>>                         return;
>>                 __delay(1);
>>         }
>>         /* lockup suspected: */
>>         spin_dump(lock, "lockup suspected");
>> }
>>
>> 3. Is this patch useful to us, How can we reproduce this scenario ?
>> Scenario : Lock is available but arch_spin_trylock  is returning as failure
>
> Potentially. Why can't you simply apply the patch and see if it resolves your
> issue?
>
> Will
