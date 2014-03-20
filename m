Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbaCTRmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:42:05 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:47265 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaCTRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	<20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	<1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 20 Mar 2014 10:42:02 -0700
X-Google-Sender-Auth: mQ0GEb-ihBDRcNJoeHaRaMsJ7XU
Message-ID: <CA+55aFw-gGQ5hTdVPovpRgcEHGyhf3YDzoSLpavzP4SefkkBDg@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 10:18 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> It strikes me that the "spin_is_locked()" test has no barriers wrt the
>> writing of the new futex value on the wake path. And the read barrier
>> obviously does nothing wrt the write either. Or am I missing
>> something? So the write that actually released the futex might be
>> almost arbitrarily delayed on the waking side. So the waiting side may
>> not see the new value, even though the waker assumes it does due to
>> the ordering of it doing the write first.
>
> Aha, that would certainly violate the ordering guarantees. I feared
> _something_ like that when we originally discussed your suggestion as
> opposed to the atomics one, but didn't have any case for it either.

Actually, looking closer, we have the memory barrier in
get_futex_key_refs() (called by "get_futex_key()") so that's not it.
In fact, your "atomic_read(&hb->waiters)" doesn't have any more
serialization than the spin_is_locked() test had.

But the spin_is_locked() and queue-empty tests are two separate memory
reads, and maybe there is some ordering wrt those two that we missed,
so the "waiters" patch is worth trying anyway.

I do still dislike how the "waiters" thing adds an atomic update, but whatever..

          Linus
