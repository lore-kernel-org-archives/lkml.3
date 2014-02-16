Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaBPTXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:23:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBPTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:23:23 -0500
Date: Sun, 16 Feb 2014 20:23:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        Markus Metzger <markus.t.metzger@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, nmi: fix unknown NMI warning
Message-ID: <20140216192312.GM14089@laptop.programming.kicks-ass.net>
References: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
 <20140215095843.GJ14089@laptop.programming.kicks-ass.net>
 <20140216183850.GD32005@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140216183850.GD32005@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 07:38:50PM +0100, Andi Kleen wrote:
> > This reminds me of the late-ack stuff;
> > 
> > The way I understand interrupts to work is that when you raise the
> > interrupt it gets latched, when you ACK you drop the latch. Then when it
> > gets re-raised while its still in progress, it gets latched again and
> > the irq-enable at the end of the running handler will get it to trigger
> > again.
> > 
> > So by late-ACK-ing the PMI we can miss PMIs that happen between enabling
> > the PMU and ACKing the PMI.
> 
> My understanding is that all these things are different latches/states, like
> semaphores in a queue. pending-state, not-acked-state, interrupts disabled
> state. There's also some delay in propagating between the states, which
> was the reason we needed the late-ack in the first place.
> 
> Your argument relies on (1) and (2) being the same physical latch,
> right?

Indeed so; if they're separate states then things are fine. Are any of
these details documented someplace?

> The late-ack method was originally blessed by the hardware architects.
> 
> Also I don't think it would matter in any case because:
> 
> > 
> > We should either re-check the overflow mask after the ACK or do the ACK
> > while the PMU is disabled.
> 
> For PMU that would be just a back-to-back PMI. We filter those
> out anyways.

In this case the latter NMI will actually have an overflow state to
process so it's not a spurious NMI.

> And if we're in a state that PMIs get re-raised quickly, we should either
> regulate the period down or start throttling.

It could be a different counter; where both run at 'normal' periods but
just near miss each other by accident.

And sure; its all stats and over all it shouldn't matter that much, but
we should still try and do our best regardless.
