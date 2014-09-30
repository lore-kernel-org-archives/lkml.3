Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaI3MfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaI3MfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:35:08 -0400
Message-ID: <542AA33E.2050008@redhat.com>
Date: Tue, 30 Sep 2014 08:34:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com, oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched, time: cmpxchg does not work on 64-bit variable
References: <2547036.UshV4pXvhf@wuerfel>
In-Reply-To: <2547036.UshV4pXvhf@wuerfel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/30/2014 07:56 AM, Arnd Bergmann wrote:
> A recent change to update the stime/utime members of task_struct 
> using atomic cmpxchg broke configurations on 32-bit machines with 
> CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that uses 64-bit 
> nanoseconds, leading to a link-time error:
> 
> kernel/built-in.o: In function `cputime_adjust': :(.text+0x25234):
> undefined reference to `__bad_cmpxchg'
> 
> This reverts the change that caused the problem, I suspect the real
> fix is to conditionally use cmpxchg64 instead, but I have not
> checked if that will work on all architectures.

I see that kernel/sched/clock.c uses cmpxchg64 in a non
architecture, non 64 bit specific piece of code, and
nobody complained about that file not building, so I have
to assume cmpxchg64 works :)

The revert seems like a bad idea, since it will reintroduce
a race condition with sys_times().

One problem is that include/asm-generic/cputime_nsecs.h
defines cputime_t as u64, while cputime_jiffies.h defines
cputime_t as a long...

Will anybody barf at a cmpxchg_cputime, or is the solution
to fix cmpxchg on architectures where it does not accept a
64 bit type?  Not quite sure how to do the latter...

Arnd, on which architecture are you seeing a build failure?
Is it just 32 bit arm?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de> Fixes: eb1b4af0a64a
> ("sched, time: Atomically increment stime & utime") --- found in
> ARM randconfig builds on linux-next
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c index
> 64492dff8a81..e99e7e54131c 100644 --- a/kernel/sched/cputime.c +++
> b/kernel/sched/cputime.c @@ -603,12 +603,9 @@ static void
> cputime_adjust(struct task_cputime *curr, * If the tick based count
> grows faster than the scheduler one, * the result of the scaling
> may go backward. * Let's enforce monotonicity. -	 * Atomic exchange
> protects against concurrent cputime_adjust(). */ -	while (stime >
> (rtime = ACCESS_ONCE(prev->stime))) -		cmpxchg(&prev->stime, rtime,
> stime); -	while (utime > (rtime = ACCESS_ONCE(prev->utime))) -
> cmpxchg(&prev->utime, rtime, utime); +	prev->stime =
> max(prev->stime, stime); +	prev->utime = max(prev->utime, utime);
> 
> out: *ut = prev->utime;
> 


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUKqM+AAoJEM553pKExN6Dc8EH/3BuP9ZSvWTXpFI070Wy0uuo
/gqpFqdyLLtJ+i850HW4356ew5SeIYjzKHxDcWFJDYYUBI2/LuUjyaOo02KK/AjX
0G0Qblli94dYB9B1eiMqQc9pU9VLjGHD1Gh5T0IjahTpmxKUCTNw4tv80ykdIDEe
JVrZGNAxFUQXJ+3S2RwhRHRLHGVN3/EGPvhkibPK+xvth17isasv/AdIFkgdDYPY
6UtDuKPtLAilmIEXit82z/OOqInSYPrMzvcB+psnY3NlqHwTWW8IuI5zZmEh2h+a
aQhA/D+4he49Xc2O+7eIFwzLJbBnv0+4mlUQwiw9v2bBXHg1MepqUT8hwveggxE=
=SPyM
-----END PGP SIGNATURE-----
