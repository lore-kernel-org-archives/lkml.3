Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3JBKED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:04:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3JBKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:03:59 -0400
Date: Wed, 2 Oct 2013 12:03:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: Re: PERF_EVENT_IOC_SET_OUTPUT
Message-ID: <20131002100350.GO3081@twins.programming.kicks-ass.net>
References: <524B1E7C.3070108@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B1E7C.3070108@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:11:56PM +0300, Adrian Hunter wrote:
> Hi
> 
> It does not seem possible to use set-output between
> task contexts of different types (e.g. a software event
> to a hardware event)
> 
> If you look at perf_event_set_output():
> 
>           /*
>            * If its not a per-cpu rb, it must be the same task.
>            */
>           if (output_event->cpu == -1 && output_event->ctx != event->ctx)
>                   goto out;
> 
> ctx (perf_event_context) won't be the same for events
> of different types.  Is this restriction necessary?

Hmm.. so last night I wrote me a big reply saying we couldn't do it;
then this morning I reconsidered and thing that something like:

  output_event->ctx->task != event->ctx->task

should actually work.

The reason it should be OK I think is because perf_mmap() will refuse to
create a buffer for inherited events that have ->cpu == -1.

My initial response was going to say that it wouldn't be possible
because __perf_event_task_sched_out() could 'break' one ctx while still
swapping the other, at which point the buffer would have to service two
different tasks, potentially from different CPUs and with the buffers
not actually being SMP safe that's a problem.

But like stated, perf_mmap() seems to avoid that issue entirely by not
allowing inherited events that aren't cpu bound.

Someone please double check this..  :-)
