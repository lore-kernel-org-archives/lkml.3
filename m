Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbbAYP5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 10:57:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42673 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbAYP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 10:57:03 -0500
Date: Sun, 25 Jan 2015 15:56:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Message-ID: <20150125155633.GA22257@leverpostej>
References: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 04:34:28AM +0000, Fengguang Wu wrote:
> Greetings,

Hi Fengguang,

Thanks very much for the report.

> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core
> 
> commit d26bb7f73a2881f2412c340a27438b185f0cc3dc
> Author:     Mark Rutland <mark.rutland@arm.com>
> AuthorDate: Wed Jan 7 15:01:54 2015 +0000
> Commit:     Peter Zijlstra <peterz@infradead.org>
> CommitDate: Fri Jan 23 15:17:56 2015 +0100
> 
>     perf: decouple unthrottling and rotating

[...]

What seems to be happening is:

* An event is created in the context of task A on CPU0. As the task's hw
  context is empty of events, we call perf_pmu_ctx_activate. This adds
  the cpuctx of the relevant HW PMU to the active_ctx_list. Note that we
  checked the task's ctx for emptiness, then added the PMU's hw context.

* An event is created (as a result of a clone()) in the context of task
  B on CPU0, and we do the same thing, finding the ctx empty of events
  we add the HW PMU's cpuctx to the active_ctx_list. As it's already in
  there, the WARN_ON(!list_empty(&cpuctx->active_ctx_list)) explodes.

So I guess what we actually want to do is to turn the active_ctx list
into a list of perf_event_contexts rather than perf_event_cpu_contexts,
and add/remove from the list when a context is scheduled in/out (or
updated empty<->nonempty). That way we remove chances for erroneous
add/remove, and we don't need to treat task and CPU contexts separately
in perf_event_task_tick.

I managed to get the reproducer running on a box at home, so I'll spin a
potential fix against that for a while, and send that out if I don't see
explosions.

Peter, I guess you'll drop this patch for now?

Thanks,
Mark.
