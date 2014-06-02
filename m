Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaFBOPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:15:23 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:31772 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbaFBOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:15:20 -0400
Message-ID: <538C86E2.1070806@hp.com>
Date: Mon, 02 Jun 2014 10:14:58 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 01:53 PM, Mikulas Patocka wrote:
> The code in kernel/locking/mcs_spinlock.c is broken.

The osq_lock and osq_unlock functions aren't the only ones that need to 
be changed, the mcs_spin_lock and mcs_spin_unlock have exactly the same 
problem. There aren't certainly problems in other places as well.

> PA-RISC doesn't have xchg or cmpxchg atomic instructions like other
> processors. It only has ldcw and ldcd instructions that load a word (or
> doubleword) from memory and atomically store zero at the same location.
> These instructions can only be used to implement spinlocks, direct
> implementation of other atomic operations is impossible.
>
> Consequently, Linux xchg and cmpxchg functions are implemented in such a
> way that they hash the address, use the hash to index a spinlock, take the
> spinlock, perform the xchg or cmpxchg operation non-atomically and drop
> the spinlock.
>
> If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
> the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
> so, in this case, cmpxchg or xchg isn't really atomic at all.
>
> This patch fixes the bug by introducing a new type atomic_pointer_t
> (backed by atomic_long_t) and replacing the offending pointer with it.
> atomic_long_set takes the hashed spinlock, so it avoids the race
> condition.

I believe the mixing of cmpxchg/xchg  and ACCESS_ONCE() is fairly common 
in the kernel, it will be an additional burden on the kernel developers 
to make sure that this kind of breakage won't happen. We also need clear 
documentation somewhere to document this kind of architecture specific 
behavior, maybe in the memory-barrier.txt.
> Index: linux-3.15-rc7/kernel/locking/mcs_spinlock.h
> ===================================================================
> --- linux-3.15-rc7.orig/kernel/locking/mcs_spinlock.h	2014-05-31 19:01:01.000000000 +0200
> +++ linux-3.15-rc7/kernel/locking/mcs_spinlock.h	2014-06-01 14:17:49.000000000 +0200
> @@ -13,6 +13,7 @@
>   #define __LINUX_MCS_SPINLOCK_H
>
>   #include<asm/mcs_spinlock.h>
> +#include<linux/atomic.h>
>
>   struct mcs_spinlock {
>   	struct mcs_spinlock *next;
> @@ -119,7 +120,8 @@ void mcs_spin_unlock(struct mcs_spinlock
>    */
>
>   struct optimistic_spin_queue {
> -	struct optimistic_spin_queue *next, *prev;
> +	atomic_pointer_t next;
> +	struct optimistic_spin_queue *prev;
>   	int locked; /* 1 if lock acquired */
>   };

Is there a way to do it without changing the pointer type? It will make 
the code harder to read and understand.

-Longman
