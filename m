Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3AaVst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:48:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:59116 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3AaVsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:48:47 -0500
Date: Thu, 31 Jan 2013 22:48:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
In-Reply-To: <20130131122342.31b28664.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1301312233480.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Andrew Morton wrote:

> On Thu, 31 Jan 2013 15:44:10 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > At the end hotplug should run through an array of callbacks on both
> > sides with explicit core synchronization points. The ordering should
> > look like this:
> > 
> > CPUHP_OFFLINE                   // Start state.
> > CPUHP_PREP_<hardware>           // Kick CPU into life / let it die
> > CPUHP_PREP_<datastructures>     // Get datastructures set up / freed.
> > CPUHP_PREP_<threads>            // Create threads for cpu
> > CPUHP_SYNC			// Synchronization point
> > CPUHP_INIT_<hardware>		// Startup/teardown on the CPU (interrupts, timers ...)
> > CPUHP_SCHED_<stuff on CPU>      // Unpark/park per cpu local threads on the CPU.
> > CPUHP_ENABLE_<stuff_on_CPU>	// Enable/disable facilities 
> > CPUHP_SYNC			// Synchronization point
> > CPUHP_SCHED                     // Expose/remove CPU from general scheduler.
> > CPUHP_ONLINE                    // Final state
> 
> What does CPUHP_SYNC do?

This is a future step which makes sure that the cpu which controls the
bringup and the teardown of the hotplugged cpu are synchronizing at
some point. Right now, we have this synchronization burried somewhere
in the architecture code and of course every arch does it different
versus the generic bringup/teardown mechanisms.
 
> Methinks Tejun needed a cc on this lot ;)

Not really. The workqueue hotplug scheme is today one of the sanest in
that area. Earlier versions have been a prime example of hotplug hell!

TJ has converted it via the notifier priorities to a symetric
startup/teardown scheme already. So the conversion is a no brainer and
no real change.

Sure, I should have spent the cycles to add every file owner to the cc
list, but due to brain damage caused by decoding the current hotplug
maze I skipped that painful exercise relying on you to fix it up for
me :)

Thanks,

	tglx



