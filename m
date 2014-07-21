Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbaGURJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:09:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaGURJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:09:22 -0400
Date: Mon, 21 Jul 2014 19:09:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Davies <jonathan.davies@citrix.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC] sched/core: Make idle_cpu return 0 if doing softirq
 work
Message-ID: <20140721170913.GQ3935@laptop>
References: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com>
 <20140718140821.GD20603@laptop.programming.kicks-ass.net>
 <53CD4644.4010907@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD4644.4010907@citrix.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 05:56:36PM +0100, Jonathan Davies wrote:
> >If your softirq takes _that_ long its broken anyhow.
> 
> Modern NICs can sustain 40 Gb/s of traffic. For network device drivers that
> use NAPI, polling is done in softirq context. At this data-rate, the
> per-packet processing overhead means means that a lot of CPU time is spent
> in softirq.
> 
> (CCing Dave and Eric for their thoughts about long-running softirq due to
> NAPI. The example I gave above was of xen-netback sending data to another
> virtual interface at a high rate.)

So thing more or less assume that softirq handling (as ran off the tail
of hardirqs) does not take longer than a tick. Otherwise things start to
pile up and you get all kinds of nasty. Not to mention you get into
horrid latencies etc..

How hard would you scream if people ran multi tick hard interrupts? Why
do you then think its OK so do the effective same thing?

> >>Instead, the following patch is a partial solution, only handling the case when
> >>the currently-executing CPU is in softirq context. This was sufficient to solve
> >>the problem I observed.
> >
> >NAK, IRQ and SoftIRQ are outside of what the scheduler can control, so
> >for its purpose the CPU is indeed idle.
> 
> The scheduler can't control those things, but surely it wants to make the
> best possible placement for the things it can control? So it seems odd to me
> that it would ignore relevant information about the resources it can use. As
> I observed, it leads to pathological behaviour, and is easily fixed.

We already lower the compute capacity due to irq/softirq overhead, if we
don't correctly handle that then we need to fix that. But as far as the
scheduler is concerned that cpu is _IDLE_. We didn't put anything on,
and therefore there's not anything on, end of story.


