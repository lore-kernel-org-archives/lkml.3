Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaBFRhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:37:33 -0500
Received: from verein.lst.de ([213.95.11.211]:41607 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbaBFRhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:37:32 -0500
Date: Thu, 6 Feb 2014 18:37:27 +0100
From: Torsten Duwe <duwe@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140206173727.GA13048@lst.de>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206163837.GT2936@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:38:37PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2014 at 11:37:37AM +0100, Torsten Duwe wrote:
> > x86 has them, MIPS has them, ARM has them, even ia64 has them:
> > ticket locks. They reduce memory bus and cache pressure especially
> > for contended spinlocks, increasing performance.
> > 
> > This patch is a port of the x86 spin locks, mostly written in C,
> > to the powerpc, introducing inline asm where needed. The pSeries
> > directed yield for vCPUs is taken care of by an additional "holder"
> > field in the lock.
> > 
> 
> A few questions; what's with the ppc64 holder thing? Not having a 32bit
> spinlock_t is sad.

I must admit that I haven't tested the patch on non-pseries ppc64 nor on
ppc32. Only ppc64 has the ldarx and I tried to atomically replace the 
holder along with the locks. That might prove unneccessary.

> Can you pair lwarx with sthcx ? I couldn't immediately find the answer
> in the PowerISA doc. If so I think you can do better by being able to
> atomically load both tickets but only storing the head without affecting
> the tail.

V2.06b, Book II, Chapter 3, "sthcx" says:
| If a reservation exists and the length associated [...] is not 2 bytes,
| it is undefined whether (RS)_48:63 are stored [...]

That doesn't make me feel comfortable :(

	Torsten

