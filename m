Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaAaKR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:17:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaAaKRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:17:54 -0500
Date: Fri, 31 Jan 2014 11:17:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: George Spelvin <linux@horizon.com>
Cc: Waiman.Long@hp.com, akpm@linux-foundation.org, andi@firstfloor.org,
        arnd@arndb.de, aswin@hp.com, hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, tim.c.chen@linux.intel.com,
        torvalds@linux-foundation.org, walken@google.com, x86@kernel.org
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140131101729.GA8874@twins.programming.kicks-ass.net>
References: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
 <20140131100348.8867.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131100348.8867.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 05:03:48AM -0500, George Spelvin wrote:
> How about getting rid of that TICKET_MSB mess and doing something like:
> 
> #define TICKET_MASK	0xFFFF
> 
> static inline void ticket_spin_unlock(atomic_t *tickets)
> {
> 	u32 t = *tickets;
> 
> 	smp_mb__before_atomic_inc();
> 
> 	/* Increment the low 16 bits without affecting the upper. */
> 	if (unlikely((~t & TICKET_MASK) == 0))
> 		atomic_add(-(atomic_t)TICKET_MASK, tickets);
> 	else
> 		atomic_inc(tickets);
> }
> 
> That also allows up to 2^16 waiters, up from 2^15.
> (Minus one on both cases, if you want to be fussy.)

Ah indeed. That'll work. That said, any arch that can single-copy
address shorts can probably do better than this generic atomic_t thing.

My main point was that we should seriously look at a ticket lock instead
of the MCS one, because while the MCS has better contention behaviour,
we shouldn't optimize locks for the worst contention.
