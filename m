Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3LJRoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:44:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56979 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3LJRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:44:54 -0500
Date: Tue, 10 Dec 2013 18:43:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v5 tip/core/locking 5/7]
 Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Message-ID: <20131210174345.GF13532@twins.programming.kicks-ass.net>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131210131422.GG12849@twins.programming.kicks-ass.net>
 <20131210171247.GQ4208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210171247.GQ4208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:12:47AM -0800, Paul E. McKenney wrote:
> Good point -- the UNLOCK and LOCK are guaranteed to be ordered only
> if they both operate on the same lock variable.  OK, I will make the
> example use different lock variables and show the different outcomes.
> How about the following?
> 
> 	If it is necessary for an UNLOCK-LOCK pair to
> 	produce a full barrier, the LOCK can be followed by an
> 	smp_mb__after_unlock_lock() invocation.  This will produce a
> 	full barrier if either (a) the UNLOCK and the LOCK are executed
> 	by the same CPU or task, or (b) the UNLOCK and LOCK act on the
> 	same lock variable.  

So you're still requiring smp_mb__after_unlock_lock() even if they're on
the same variable?

> The smp_mb__after_unlock_lock() primitive is
> 	free on many architectures.  Without smp_mb__after_unlock_lock(),
> 	the UNLOCK and LOCK can cross:

Contradicted below :-)

> 		*A = a;
> 		UNLOCK M
> 		LOCK N
> 		*B = b;
> 
> 	could occur as:
> 
> 		LOCK N, STORE *B, STORE *A, UNLOCK M
> 
> 	With smp_mb__after_unlock_lock(), they cannot, so that:
> 
> 		*A = a;
> 		UNLOCK M
> 		LOCK N
> 		smp_mb__after_unlock_lock();
> 		*B = b;
> 
> 	will always occur as either of the following:
> 
> 		STORE *A, UNLOCK, LOCK, STORE *B
> 		STORE *A, LOCK, UNLOCK, STORE *B

See, UNLOCK and LOCK can still cross :-)

> 	If the UNLOCK and LOCK were instead both operating on the same
> 	lock variable, only the first of these two alternatives can occur.

Agreed.

Sorry for being a pedant. :-)
