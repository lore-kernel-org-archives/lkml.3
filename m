Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaATKVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:21:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60135 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbaATKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:21:04 -0500
Date: Mon, 20 Jan 2014 10:20:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock lockup
Message-ID: <20140120102051.GB16496@mudshark.cambridge.arm.com>
References: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 07:25:51AM +0000, naveen yadav wrote:
> We are using 3.8.x  kernel on ARM, We are facing soft lockup issue.
> Following are the logs.

Which CPU/SoC are you using?

> BUG: spinlock lockup suspected on CPU#0, process1/525
> lock: 0xd8ac9a64, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> 
> 
> 1 . Looks like lock is available as owner is -1, why arch_spin_trylock
> is getting failed ?

Is this with or without the ticket lock patches? Can you inspect the actual
value of the arch_spinlock_t?

> 2. There is a patch : ARM: spinlock: retry trylock operation if strex
> fails on free lock
> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/240913
> In this patch, A loop has been added around strexeq %2, %0, [%3]".
> {Comment "retry the trylock operation if the lock appears
> to be free but the strex reported failure"}
> 
> but arch_spin_trylock is called by __spin_lock_debug and its already
> getting called in loops. So what purpose is resolves?

Does this patch help your issue? The purpose of it is to distinguish between
two types of contention:

  (1) The lock is actually taken
  (2) The lock is free, but two people are doing a trylock at the same time

In the case of (2), we do actually want to spin again otherwise you could
potentially end up in a pathological case where the two CPUs repeatedly
shoot down each other's monitor and forward progress isn't made until the
sequence is broken by something like an interrupt.

> static void __spin_lock_debug(raw_spinlock_t *lock)
> {
>         u64 i;
>         u64 loops = loops_per_jiffy * HZ;
> 
>         for (i = 0; i < loops; i++) {
>                 if (arch_spin_trylock(&lock->raw_lock))
>                         return;
>                 __delay(1);
>         }
>         /* lockup suspected: */
>         spin_dump(lock, "lockup suspected");
> }
> 
> 3. Is this patch useful to us, How can we reproduce this scenario ?
> Scenario : Lock is available but arch_spin_trylock  is returning as failure

Potentially. Why can't you simply apply the patch and see if it resolves your
issue?

Will
