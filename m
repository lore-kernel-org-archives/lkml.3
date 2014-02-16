Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaBPSix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:38:53 -0500
Received: from one.firstfloor.org ([193.170.194.197]:47817 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaBPSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:38:52 -0500
Date: Sun, 16 Feb 2014 19:38:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org,
        Markus Metzger <markus.t.metzger@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, nmi: fix unknown NMI warning
Message-ID: <20140216183850.GD32005@two.firstfloor.org>
References: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
 <20140215095843.GJ14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215095843.GJ14089@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This reminds me of the late-ack stuff;
> 
> The way I understand interrupts to work is that when you raise the
> interrupt it gets latched, when you ACK you drop the latch. Then when it
> gets re-raised while its still in progress, it gets latched again and
> the irq-enable at the end of the running handler will get it to trigger
> again.
> 
> So by late-ACK-ing the PMI we can miss PMIs that happen between enabling
> the PMU and ACKing the PMI.

My understanding is that all these things are different latches/states, like
semaphores in a queue. pending-state, not-acked-state, interrupts disabled
state. There's also some delay in propagating between the states, which
was the reason we needed the late-ack in the first place.

Your argument relies on (1) and (2) being the same physical latch,
right?

The late-ack method was originally blessed by the hardware architects.

Also I don't think it would matter in any case because:

> 
> We should either re-check the overflow mask after the ACK or do the ACK
> while the PMU is disabled.

For PMU that would be just a back-to-back PMI. We filter those
out anyways.

And if we're in a state that PMIs get re-raised quickly, we should either
regulate the period down or start throttling.

Plus also if we even get it wrong occassionally sampling is just
statistics and the law of the large numbers wins in the end.

BTW low period sampling is really a perf oddity, most other
profilers don't do that for hw sampling, as it just causes a lot of overhead
and doesn't give better sampling results.

Currently the adaptive period algorithm unfortunately has a tendency
to go very low occasionally before recovery, but I always considered that
a bug. 

I suspect the only case where low period makes sense is s/w tracepoints.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
