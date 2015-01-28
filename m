Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbbA1VNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:13:37 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35335 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbA1Uwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:51 -0500
Date: Wed, 28 Jan 2015 14:59:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 2/4] sched: Use traced preempt count operations to
 toggle PREEMPT_ACTIVE
Message-ID: <20150128135941.GA29870@lerouge>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
 <1422404652-29067-3-git-send-email-fweisbec@gmail.com>
 <20150127204239.3d3bc2e4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127204239.3d3bc2e4@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 08:42:39PM -0500, Steven Rostedt wrote:
> On Wed, 28 Jan 2015 01:24:10 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > d1f74e20b5b064a130cd0743a256c2d3cfe84010 turned PREEMPT_ACTIVE modifiers
> > to use raw untraced preempt count operations. Meanwhile this prevents
> > from debugging and tracing preemption disabled if we pull that
> > responsibility to schedule() callers (see following patches).
> > 
> > Is there anything we can do about that?
> > 
> 
> I'm trying to understand how you solved the recursion issue with
> preempt_schedule()?

I don't solve it, I rather outline the issue to make sure it's still
a problem today. I can keep the non-traced API but we'll loose debuggability
and latency measurement in preempt_schedule(). But I think this was already
the case before my patchset.

> 
> Here's what happens:
> 
> preempt_schedule()
>   preempt_count_add() -> gets traced by function tracer
>      function_trace_call()
>          preempt_disable_notrace()
>          [...]
>          preempt_enable_notrace() -> sees NEED_RESCHED set
>              preempt_schedule()
>                 preempt_count_add() -> gets traced
>                    function_trace_call()
>                        preempt_disable_notrace()
>                        preempt_enable_notrace() -> sees NEED_RESCHED set
> 
>                           [etc etc until BOOM!]
> 
> Perhaps if you can find a way to clear NEED_RECHED before disabling
> preemption, then it would work. But I don't see that in the patch
> series.

Something like this in function tracing?

prev_resched = need_resched();
do_function_tracing()
    preempt_disable()
    .....
    preempt_enable_no_resched()

if (!prev_resched && need_resched())
    preempt_schedule()

Sounds like a good idea. More overhead but maybe more stability.

> 
> -- Steve
> 
