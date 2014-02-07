Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaBGPn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:43:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaBGPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:43:55 -0500
Date: Fri, 7 Feb 2014 16:43:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207154346.GC3104@twins.programming.kicks-ass.net>
References: <20140206103736.GA18054@lst.de>
 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
 <20140206173727.GA13048@lst.de>
 <1391717992.6733.232.camel@snotra.buserror.net>
 <20140207090248.GB26811@lst.de>
 <20140207103139.GP5002@laptop.programming.kicks-ass.net>
 <20140207104530.GG5126@laptop.programming.kicks-ass.net>
 <20140207114949.GA2107@lst.de>
 <20140207122837.GA3104@twins.programming.kicks-ass.net>
 <20140207151847.GB3104@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207151847.GB3104@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:18:47PM +0100, Peter Zijlstra wrote:
> void ticket_lock(tickets_t *lock)
> {
> 	tickets_t t;
> 
> 	/*
> 	 * Because @head is MSB, the direct increment wrap doesn't disturb
> 	 * @tail.
> 	 */
> 	t.pair = xadd(&lock->pair, 1<<16);
> 
> 	if (likely(t.head == t.tail)) {
> 		__lwsync(); /* acquire */
> 		return;
> 	}
> 
> 	while (smp_load_acquire(&lock->tail) != t.tail)
> 		cpu_relax();

That should be "!= t.head", for that contains our ticket.

I'm hopelessly scatter brained today it seems :/


> }
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
