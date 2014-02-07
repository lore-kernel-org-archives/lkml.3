Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaBGRIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:08:50 -0500
Received: from verein.lst.de ([213.95.11.211]:44622 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBGRIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:08:49 -0500
Date: Fri, 7 Feb 2014 18:08:45 +0100
From: Torsten Duwe <duwe@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207170845.GD2107@lst.de>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <1391717992.6733.232.camel@snotra.buserror.net> <20140207090248.GB26811@lst.de> <20140207103139.GP5002@laptop.programming.kicks-ass.net> <20140207104530.GG5126@laptop.programming.kicks-ass.net> <20140207114949.GA2107@lst.de> <20140207122837.GA3104@twins.programming.kicks-ass.net> <20140207151847.GB3104@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207151847.GB3104@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:18:47PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 07, 2014 at 01:28:37PM +0100, Peter Zijlstra wrote:
> > Anyway, you can do a version with lwarx/stwcx if you're looking get rid
> > of lharx.
> 
> the below seems to compile into relatively ok asm. It can be done better
> if you write the entire thing by hand though.

[...]

> 
> static inline unsigned int xadd(unsigned int *v, unsigned int i)
> {
> 	int t, ret;
> 	
> 	__asm__ __volatile__ (
> "1:	lwarx	%0, 0, %4\n"
> "	mr	%1, %0\n"
> "	add	%0, %3, %0\n"
> "	stwcx.	%0, %0, %4\n"
> "	bne-	1b\n"
> 	: "=&r" (t), "=&r" (ret), "+m" (*v)
> 	: "r" (i), "r" (v)
> 	: "cc");
> 
> 	return ret;
> }
> 
I don't like this xadd thing -- it's so x86 ;)
x86 has its LOCK prefix, ppc has ll/sc.
That should be reflected somehow IMHO.

Maybe if xadd became mandatory for some kernel library.

> 
> void ticket_unlock(tickets_t *lock)
> {
> 	ticket_t tail = lock->tail + 1;
> 
> 	/*
> 	 * The store is save against the xadd for it will make the ll/sc fail
> 	 * and try again. Aside from that PowerISA guarantees single-copy
> 	 * atomicy for half-word writes.
> 	 *
> 	 * And since only the lock owner will ever write the tail, we're good.
> 	 */
> 	smp_store_release(&lock->tail, tail);
> }

Yeah, let's try that on top of v2 (just posted).
First, I want to see v2 work as nicely as v1 --
compiling a debug kernel takes a while...

	Torsten

