Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaARVWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 16:22:39 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37650 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaARVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:22:36 -0500
Date: Sat, 18 Jan 2014 13:22:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140118212227.GA10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115023958.GA10038@linux.vnet.ibm.com>
 <20140115080753.GW31570@twins.programming.kicks-ass.net>
 <20140115205346.GF10038@linux.vnet.ibm.com>
 <20140115232134.GM31570@twins.programming.kicks-ass.net>
 <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
 <20140116103659.GO7572@laptop.programming.kicks-ass.net>
 <20140118100105.GV10038@linux.vnet.ibm.com>
 <20140118113406.GY30183@twins.programming.kicks-ass.net>
 <20140118122548.GX10038@linux.vnet.ibm.com>
 <20140118124136.GZ30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140118124136.GZ30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011821-3532-0000-0000-000004D962A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 01:41:36PM +0100, Peter Zijlstra wrote:
> On Sat, Jan 18, 2014 at 04:25:48AM -0800, Paul E. McKenney wrote:
> > On Sat, Jan 18, 2014 at 12:34:06PM +0100, Peter Zijlstra wrote:
> > > On Sat, Jan 18, 2014 at 02:01:05AM -0800, Paul E. McKenney wrote:
> > > > OK, I will bite...  Aside from fine-grained code timing, what code could
> > > > you write to tell the difference between a real one-byte store and an
> > > > RMW emulating that store?
> > > 
> > > Why isn't fine-grained code timing an issue? I'm sure Alpha people will
> > > love it when their machine magically keels over every so often.
> > > 
> > > Suppose we have two bytes in a word that get concurrent updates:
> > > 
> > > union {
> > > 	struct {
> > > 		u8 a;
> > > 		u8 b;
> > > 	};
> > > 	int word;
> > > } ponies = { .word = 0, };
> > > 
> > > then two threads concurrently do:
> > > 
> > > CPU0:		CPU1:
> > > 
> > > ponies.a = 5	ponies.b = 10
> > > 
> > > 
> > > At which point you'd expect: a == 5 && b == 10
> > > 
> > > However, with a rmw you could end up like:
> > > 
> > > 
> > > 			load r, ponies.word
> > > load r, ponies.word
> > > and  r, ~0xFF
> > > or   r, 5
> > > store ponies.word, r
> > > 			and r, ~0xFF00
> > > 			or r, 10 << 8
> > > 			store ponies.word, r
> > > 
> > > which gives: a == 0 && b == 10
> > > 
> > > The same can be had on a single CPU if you make the second RMW an
> > > interrupt.
> > > 
> > > 
> > > In fact, we recently had such a RMW issue on PPC64 although from a
> > > slightly different angle, but we managed to hit it quite consistently.
> > > See commit ba1f14fbe7096.
> > > 
> > > The thing is, if we allow the above RMW 'atomic' store, we have to be
> > > _very_ careful that there cannot be such overlapping stores, otherwise
> > > things will go BOOM!
> > > 
> > > However, if we already have to make sure there's no overlapping stores,
> > > we might as well write a wide store and not allow the narrow stores to
> > > begin with, to force people to think about the issue.
> > 
> > Ah, I was assuming atomic rmw, which for Alpha would be implemented using
> > the LL and SC instructions.  Yes, lots of overhead, but if the CPU
> > designers chose not to provide a load/store byte...
> 
> I don't see how ll/sc will help any. Suppose we do the a store as
> smp_store_release() using ll/sc but the b store is unaware and doesn't
> do an ll/sc.
> 
> Then we're still up shit creek without no paddle.
> 
> Whatever you're going to do, you need to be intimately aware of what the
> other bits in your word are doing.

Yes, this requires that -all- updates to the fields in the machine word
in question use atomic rmw.  Which would not be pretty from a core-code
perspective.  Hence my suggestion of ceasing Linux-kernel support for
DEC Alpha CPUs that don't support byte operations.  Also need 16-bit
operations as well, of course...

							Thanx, Paul

