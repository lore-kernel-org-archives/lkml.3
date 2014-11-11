Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaKKTro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:47:44 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56408 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaKKTrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:47:41 -0500
Date: Tue, 11 Nov 2014 19:47:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
Message-ID: <20141111194734.GL16265@arm.com>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 11, 2014 at 06:57:05PM +0000, alexander.duyck@gmail.com wrote:
> From: Alexander Duyck <alexander.h.duyck@redhat.com>
> 
> In the case of device drivers it is common to utilize receive descriptors
> in which a single field is used to determine if the descriptor is currently
> in the possession of the device or the CPU.  In order to prevent any other
> fields from being read a rmb() is used resulting in something like code
> snippet from ixgbe_main.c:
> 
> 	if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_DD))
> 		break;
> 
> 	/*
> 	 * This memory barrier is needed to keep us from reading
> 	 * any other fields out of the rx_desc until we know the
> 	 * RXD_STAT_DD bit is set
> 	 */
> 	rmb();
> 
> On reviewing the documentation and code for smp_load_acquire() it occured
> to me that implementing something similar for CPU <-> device interraction
> would be worth while.  This commit provides just the load/read side of this
> in the form of read_acquire().  This new primative orders the specified
> read against any subsequent reads.  As a result we can reduce the above
> code snippet down to:
> 
> 	/* This memory barrier is needed to keep us from reading
> 	 * any other fields out of the rx_desc until we know the
> 	 * RXD_STAT_DD bit is set
> 	 */
> 	if (!(read_acquire(&rx_desc->wb.upper.status_error) &

Minor nit on naming, but load_acquire would match what we do with barriers,
where you simply drop the smp_ prefix if you want the thing to work on UP
systems too.

> 	      cpu_to_le32(IXGBE_RXD_STAT_DD)))
> 		break;

I'm not familiar with the driver in question, but how are the descriptors
mapped? Is the read barrier here purely limiting re-ordering of normal
memory accesses by the CPU? If so, isn't there also scope for store_release
when updating, e.g. next_to_watch in the same driver?

We also need to understand how this plays out with
smp_mb__after_unlock_lock, which is currently *only* implemented by PowerPC.
If we end up having a similar mess to mmiowb, where PowerPC both implements
the barrier *and* plays tricks in its spin_unlock code, then everybody
loses because we'd end up with release doing the right thing anyway.

Peter and I spoke with Paul at LPC about strengthening
smp_load_acquire/smp_store_release so that release->acquire ordering is
maintained, which would allow us to drop smp_mb__after_unlock_lock
altogether. That's stronger than acquire/release in C11, but I think it's
an awful lot easier to use, particularly if device drivers are going to
start using these primitives.

Thoughts?

Will
