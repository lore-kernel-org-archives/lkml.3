Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbATGJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:09:17 -0500
Received: from ozlabs.org ([103.22.144.67]:50117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbATGJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:09:15 -0500
In-Reply-To: <20150119102647.23035.13380.stgit@preeti.in.ibm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, tglx@linutronix.de
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        anton@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: tick/broadcast: Make movement of broadcast hrtimer robust against hotplug
Message-Id: <20150120060913.A5EF31402DE@ozlabs.org>
Date: Tue, 20 Jan 2015 17:09:13 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-19-01 at 10:26:48 UTC, Preeti U Murthy wrote:
> Today if a cpu handling broadcasting of wakeups goes offline, it hands over

It's *the* cpu handling broadcasting of wakeups right? ie. there's only ever
one at a time.

> the job of broadcasting to another cpu in the CPU_DEAD phase. 

I think that would be clearer as "to another cpu, when the cpu going offline
reaches the CPU_DEAD state."

Otherwise it can read as "another cpu (which is) in the CPU_DEAD phase", which
is not what you mean - I think.

> The CPU_DEAD notifiers are run only after the offline cpu sets its state as
> CPU_DEAD. Meanwhile, the kthread doing the offline is scheduled out while

The kthread which is running on a different cpu from either of the first two
cpus you've mentioned.

> waiting for this transition by queuing a timer. This is fatal because if the
> cpu on which this kthread was running has no other work queued on it, it can
> re-enter deep idle state, since it sees that a broadcast cpu still exists.
> However the broadcast wakeup will never come since the cpu which was handling
> it is offline, and this cpu never wakes up to see this because its in deep
> idle state.

Which cpu is "this cpu"? I think you mean the one running the kthread which is
doing the offline, but it's not 100% clear.

> Fix this by setting the broadcast timer to a max value so as to force the cpus
> entering deep idle states henceforth to freshly nominate the broadcast cpu. More
> importantly this has to be done in the CPU_DYING phase so that it is visible to
> all cpus right after exiting stop_machine, which is when they can re-enter idle.
> This ensures that handover of the broadcast duty falls in place on offline, without
> having to do it explicitly.

OK, I don't know the code well enough to say if that's the right fix.

You say:

+	/* This allows fresh nomination of broadcast cpu */
+	bc->next_event.tv64 = KTIME_MAX;

Is that all it does? I see that check in several places in the code.


I assume we're expecting Thomas to merge this?

If so it's probably worth mentioning that it fixes a bug we are seeing on
machines in the wild. So it'd be nice if it went into 3.19 and/or gets sent to
stable.

cheers
