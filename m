Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LKPhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:37:46 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44950 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3LKPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:37:45 -0500
Message-ID: <52A87EA4.1020101@hp.com>
Date: Wed, 11 Dec 2013 10:03:00 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <peterz@infradead.org>,
        Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com> <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com> <20131203085233.GA20179@gmail.com>
In-Reply-To: <20131203085233.GA20179@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:52 AM, Ingo Molnar wrote:
> *
> I think we try that, to make mutexes safer in general.
>
> Can you see a way to do that fairly cheaply?
>
> I can see two approaches, both rather radical:
>
> 1)
>
> Eliminate mutex->count and (ab-)use mutex->wait_lock as 'the' mutex
> lock: with TICKET_SLOWPATH_FLAG used to denote waiters or so and care
> taken to not use it as a 'real' spinlock but use the raw accessors.
>
> This would still allow a good mutex_lock() fastpath, as it would
> essentially become spin_trylock() with an asm goto slow path helper
> perhaps.
>
> Doing this would have various advantages:
>
>   - we'd eliminate much (all?) of per arch mutex code
>   - we'd share spinlock and mutex low level implementations
>   - we'd reduce struct mutex size by 4 bytes
>
> It's still early in the morning so I might be missing something
> trivial though - this sounds suspiciously too easy ;-) Having a proper
> mutex slowpath might not be so easy without changing the spinlock
> code.
>
> 2)
>
> Another method would be to do the opposite: eliminate mutex->wait_lock
> [for the non-debug case] and do everything via mutex->count and
> mutex->owner.
>
> This saves even more space and potentially enables a tighter slowpath.
>
> It probably won't hurt the massively parallel case, as we already do
> smart MCS locking via mutex->spin_mlock.
>
> So I'd argue for #2. (Assuming it addresses the problem)
>
> Thanks,
>
> 	Ingo
>
>

I also think that #2 is safer as messing with spinlock code can be 
risky. However, #2 probably won't work for architectures that use the 
generic mutex-xchg.h fastpath. Currently the following architectures use 
mutex-xchg.h - unicore32, arc, arm and hexagon. Is there a reason why 
they cannot be converted to use mutex-dec.h instead?

-Longman


