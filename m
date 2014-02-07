Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaBGRTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:19:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGRTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:19:08 -0500
Date: Fri, 7 Feb 2014 18:19:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207171900.GS5002@laptop.programming.kicks-ass.net>
References: <20140206163837.GT2936@laptop.programming.kicks-ass.net>
 <20140206173727.GA13048@lst.de>
 <1391717992.6733.232.camel@snotra.buserror.net>
 <20140207090248.GB26811@lst.de>
 <20140207103139.GP5002@laptop.programming.kicks-ass.net>
 <20140207104530.GG5126@laptop.programming.kicks-ass.net>
 <20140207114949.GA2107@lst.de>
 <20140207122837.GA3104@twins.programming.kicks-ass.net>
 <20140207151847.GB3104@twins.programming.kicks-ass.net>
 <20140207170845.GD2107@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207170845.GD2107@lst.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 06:08:45PM +0100, Torsten Duwe wrote:
> > static inline unsigned int xadd(unsigned int *v, unsigned int i)
> > {
> > 	int t, ret;
> > 	
> > 	__asm__ __volatile__ (
> > "1:	lwarx	%0, 0, %4\n"
> > "	mr	%1, %0\n"
> > "	add	%0, %3, %0\n"
> > "	stwcx.	%0, %0, %4\n"
> > "	bne-	1b\n"
> > 	: "=&r" (t), "=&r" (ret), "+m" (*v)
> > 	: "r" (i), "r" (v)
> > 	: "cc");
> > 
> > 	return ret;
> > }
> > 
> I don't like this xadd thing -- it's so x86 ;)
> x86 has its LOCK prefix, ppc has ll/sc.
> That should be reflected somehow IMHO.

Its the operational semantics I care about; this version is actually
nicer in that it doesn't actually imply all sorts of barriers :-)

> Maybe if xadd became mandatory for some kernel library.

call it fetch_add() its not an uncommon operation and many people
understand the semantics.

But you can simply include the asm bits in ticket_lock() and be done
with it. In that case you can also replace the add with an addi which
might be a little more efficient.

> > void ticket_unlock(tickets_t *lock)
> > {
> > 	ticket_t tail = lock->tail + 1;
> > 
> > 	/*
> > 	 * The store is save against the xadd for it will make the ll/sc fail
> > 	 * and try again. Aside from that PowerISA guarantees single-copy
> > 	 * atomicy for half-word writes.
> > 	 *
> > 	 * And since only the lock owner will ever write the tail, we're good.
> > 	 */
> > 	smp_store_release(&lock->tail, tail);
> > }
> 
> Yeah, let's try that on top of v2 (just posted).
> First, I want to see v2 work as nicely as v1 --
> compiling a debug kernel takes a while...

Use a faster machine... it can be done < 1 minute :-)
