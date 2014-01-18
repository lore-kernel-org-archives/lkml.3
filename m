Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaARLel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:34:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaARLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:34:39 -0500
Date: Sat, 18 Jan 2014 12:34:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140118113406.GY30183@twins.programming.kicks-ass.net>
References: <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
 <20140115023958.GA10038@linux.vnet.ibm.com>
 <20140115080753.GW31570@twins.programming.kicks-ass.net>
 <20140115205346.GF10038@linux.vnet.ibm.com>
 <20140115232134.GM31570@twins.programming.kicks-ass.net>
 <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
 <20140116103659.GO7572@laptop.programming.kicks-ass.net>
 <20140118100105.GV10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140118100105.GV10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 02:01:05AM -0800, Paul E. McKenney wrote:
> OK, I will bite...  Aside from fine-grained code timing, what code could
> you write to tell the difference between a real one-byte store and an
> RMW emulating that store?

Why isn't fine-grained code timing an issue? I'm sure Alpha people will
love it when their machine magically keels over every so often.

Suppose we have two bytes in a word that get concurrent updates:

union {
	struct {
		u8 a;
		u8 b;
	};
	int word;
} ponies = { .word = 0, };

then two threads concurrently do:

CPU0:		CPU1:

ponies.a = 5	ponies.b = 10


At which point you'd expect: a == 5 && b == 10

However, with a rmw you could end up like:


			load r, ponies.word
load r, ponies.word
and  r, ~0xFF
or   r, 5
store ponies.word, r
			and r, ~0xFF00
			or r, 10 << 8
			store ponies.word, r

which gives: a == 0 && b == 10

The same can be had on a single CPU if you make the second RMW an
interrupt.


In fact, we recently had such a RMW issue on PPC64 although from a
slightly different angle, but we managed to hit it quite consistently.
See commit ba1f14fbe7096.

The thing is, if we allow the above RMW 'atomic' store, we have to be
_very_ careful that there cannot be such overlapping stores, otherwise
things will go BOOM!

However, if we already have to make sure there's no overlapping stores,
we might as well write a wide store and not allow the narrow stores to
begin with, to force people to think about the issue.
