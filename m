Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbaCTUYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:24:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:52729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725AbaCTUYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:24:19 -0400
Message-ID: <1395346982.3460.23.camel@pasglop>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: torvalds@linux-foundation.org
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, paulus@samba.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Date: Fri, 21 Mar 2014 07:23:02 +1100
In-Reply-To: <1395333093.14694.3.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <1395333093.14694.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 09:31 -0700, Davidlohr Bueso wrote:
> hmmm looking at ppc spinlock code, it seems that it doesn't have ticket
> spinlocks -- in fact Torsten Duwe has been trying to get them upstream
> very recently. Since we rely on the counter for detecting waiters, this
> might explain the issue. Could someone confirm this spinlock
> implementation difference? 

Indeed. I haven't merged ticket locks because they break lockref :-(

We have a problem here because we need to store the lock holder so we
can yield to the lock holder partition on contention and we are running
out of space in the spinlock.

The lock holder doesn't have to be atomic, so in theory we could have
the tickets and the lockref in the same 64-bit and the holder separately
but the way the layers are stacked at the moment that's not workable,
at least not without duplicating the whole lockref implementation and
breaking the spinlock in two, a "base" lock without older and the separate
variant with holder field. A mess...

I want to try sorting that out at some stage but haven't had a chance yet.

Cheers,
Ben.


