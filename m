Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaBJDDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:03:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:36633 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaBJDDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:03:20 -0500
Message-ID: <1392001351.3996.16.camel@pasglop>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Scott Wood <scottwood@freescale.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Date: Mon, 10 Feb 2014 14:02:31 +1100
In-Reply-To: <20140207090248.GB26811@lst.de>
References: <20140206103736.GA18054@lst.de>
	 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
	 <20140206173727.GA13048@lst.de>
	 <1391717992.6733.232.camel@snotra.buserror.net>
	 <20140207090248.GB26811@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 10:02 +0100, Torsten Duwe wrote:
> > > > Can you pair lwarx with sthcx ? I couldn't immediately find the answer
> > > > in the PowerISA doc. If so I think you can do better by being able to
> > > > atomically load both tickets but only storing the head without affecting
> > > > the tail.
> 
> Can I simply write the half word, without a reservation, or will the HW caches
> mess up the other half? Will it ruin the cache coherency on some (sub)architectures?

Yes, you can, I *think*

> > Plus, sthcx doesn't exist on all PPC chips.
> 
> Which ones are lacking it? Do all have at least a simple 16-bit store?

half word atomics (and byte atomics) are new, they've been added in architecture
2.06 I believe so it's fairly recent, but it's still worthwhile to investigate a
way to avoid atomics on unlock on recent processors (we can use instruction patching
if necessary based on CPU features) because there's definitely a significant cost
in doing a larx/stcx. sequence on powerpc, way higher than our current unlock path
of barrier + store.

Cheers,
Ben.


