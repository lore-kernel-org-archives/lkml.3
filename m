Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaBFQit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:38:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaBFQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:38:48 -0500
Date: Thu, 6 Feb 2014 17:38:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140206163837.GT2936@laptop.programming.kicks-ass.net>
References: <20140206103736.GA18054@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206103736.GA18054@lst.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 11:37:37AM +0100, Torsten Duwe wrote:
> x86 has them, MIPS has them, ARM has them, even ia64 has them:
> ticket locks. They reduce memory bus and cache pressure especially
> for contended spinlocks, increasing performance.
> 
> This patch is a port of the x86 spin locks, mostly written in C,
> to the powerpc, introducing inline asm where needed. The pSeries
> directed yield for vCPUs is taken care of by an additional "holder"
> field in the lock.
> 

A few questions; what's with the ppc64 holder thing? Not having a 32bit
spinlock_t is sad.

Can you pair lwarx with sthcx ? I couldn't immediately find the answer
in the PowerISA doc. If so I think you can do better by being able to
atomically load both tickets but only storing the head without affecting
the tail.

In that case you can avoid the ll/sc on unlock, because only the lock
owner can modify the tail, so you can use a single half-word store.
