Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaEPEVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:21:41 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39082 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaEPEVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:21:40 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 16 May 2014 00:25:28 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
In-Reply-To: <20140515182136.GI11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405160017120.1351@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu> <20140515182136.GI11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Peter Zijlstra wrote:

> > So, not sure how to fix this without a total re-write, unless we want to 
> > cheat and just say sample_period is capped at 62-bits or something.
> 
> 63 bits should do I think, but yes, we hit a very similar but a few days
> ago in the sched_deadline code.
> 
> I'm fine with capping it, allowing the full 64bit would mean we need 65
> bits (effectively 96 or 128 bit of course) math to make it all work
> which would be tedious and give no real gain.

Yes, it looks like 63 bits will be fine although I had to think about some 
of the logic there to make sure there's no signed overflow.

> We'll then not make progress for a while, print the msg, get throttled,
> goto 1. This is possible if we're allowed 100+ interrupts per jiffy, so
> if you adjust /proc/sys/kernel/perf_event_max_sample_rate to below that
> and it doesn't trigger anymore we know the throttle works.

The odd thing is that even when I try to write a small reproducer I can 
easily get the overflow of period to 2 to happen, but it doesn't trigger 
the message.  It will on occasion give a throttle message but that is all.

The fuzzer can reliably reproduce the actual IRQ warning, but a replay of 
a gathered trace will not.

Even weirder, the even that triggers it is attached to CPU0 but only 
triggers if the fuzzer itself is running on a different CPU.  Also the 
trigger event has all of exclude_kernel, exclude_user, and exclude_hv set
so I'm not sure how it even counts up to the 2 retired instructions to 
trigger an overflow anyway.  It doesn't help that there are 100+ other 
active events at the time, although suspiciously a few of them are 
apic_irq tracepoints (though attached to CPUs other than the trouble one).

anyway I'm not sure if it's worth tracking this more if it's possible to 
mostly fix the case by fixing the sample_period bounds.

Vince
