Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaBJRxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:53:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBJRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:53:37 -0500
Date: Mon, 10 Feb 2014 18:53:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc ticket locks
Message-ID: <20140210175325.GA27965@twins.programming.kicks-ass.net>
References: <20140207165801.GC2107@lst.de>
 <1392001823.3996.21.camel@pasglop>
 <20140210155217.GF2107@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210155217.GF2107@lst.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:52:17PM +0100, Torsten Duwe wrote:
> Opinions, anyone?

Since the holder thing is a performance thing, not a correctness thing;
one thing you could do is something like:

static const int OWNER_HASH_SIZE = CONFIG_NR_CPUS * 4;
static const int OWNER_HASH_BITS = ilog2(OWNER_HASH_SIZE);

u16 lock_owner_array[OWNER_HASH_SIZE] = { 0, };

void set_owner(struct arch_spinlock_t *lock, int owner)
{
	int hash = hash_ptr(lock, OWNER_HASH_BITS);
	lock_owner_array[hash] = owner;
}

void yield_to_owner(struct arch_spinlock_t *lock)
{
	int hash = hash_ptr(lock, OWNER_HASH_BITS);
	int owner = lock_owner_array[hash];
	yield_to_cpu(owner);
}

And call set_owner() after the ticket lock is acquired, and don't bother
clearing it again; a new acquire will overwrite, a collision we have to
live with.

It should on average get you the right yield and does away with having
to track the owner field in place.

It does however get you an extra cacheline miss on acquire :/

One could consider patching it out when you know your kernel is not
running on an overloaded partition.
