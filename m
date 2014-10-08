Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaJHQOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:14:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:38500 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaJHQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:14:23 -0400
Date: Wed, 8 Oct 2014 18:14:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
In-Reply-To: <1412782664.5179.75.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.11.1410081756250.4292@nanos>
References: <20141003194428.GA27084@sesse.net> <1412782664.5179.75.camel@marge.simpson.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014, Mike Galbraith wrote:
> Seems you opened a can of futex worms...

Bah.
 
> I don't see that on the 2 x E5-2697 box I borrowed to take a peek.  Once
> I got stockfish to actually run to completion by hunting down and brute
> force reverting the below, I see ~32 million nodes/sec throughput with
> 3.17 whether I use taskset or just let it do its thing.
> 
> Without the revert, the thing starts up fine, runs for 5 seconds or so,
> then comes to a screeching halt with one thread looping endlessly...
> 
> 1412780609.892144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000034>
> 1412780609.892216 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248307, {1412780609, 897000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004857>
> 1412780609.897144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000021>
> 1412780609.897202 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248309, {1412780609, 902000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004862>
> 1412780609.902157 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000025>
> 1412780609.902226 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248311, {1412780609, 907000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004845>
> 1412780609.907144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000021>
> 1412780609.907202 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248313, {1412780609, 912000000}, ffffffff^CProcess 2756 detached
>  <detached ...>

So that thread waits 5ms for the futex, times out, fiddles with a
different futex and waits some more...

As it looks from a short glance on the code it's a condition
variable... So if nothing updates and signals the condition, it will
show exactly that behaviour.
 
> I have not seen this on my little single socket E5620 box, nor on my 8
> socket 64 core DL980, but the DL980 is a poor crippled thing (8GB ram,
> interleaved), so may be too much of a slug (race? me? really!?!) to make
> anything bad happen.  The 2 socket E5-2697 (28 core) box OTOH is a fully
> repeatable fail.

> 11d4616bd07f38d496bd489ed8fad1dc4d928823 is the first bad commit
> commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Mar 20 22:11:17 2014 -0700
> 
>     futex: revert back to the explicit waiter counting code
>     
>     Srikar Dronamraju reports that commit b0c29f79ecea ("futexes: Avoid
>     taking the hb->lock if there's nothing to wake up") causes java threads
>     getting stuck on futexes when runing specjbb on a power7 numa box.
>     
>     The cause appears to be that the powerpc spinlocks aren't using the same
>     ticket lock model that we use on x86 (and other) architectures, which in
>     turn result in the "spin_is_locked()" test in hb_waiters_pending()
>     occasionally reporting an unlocked spinlock even when there are pending
>     waiters.

Well, unfortunately we cannot revert that for obvious reasons and I
really doubt, that it is the real problem.

It looks far more like an issue with the stocking fish code, but hell
with futexes one can never be sure.

Thanks,

	tglx

     
