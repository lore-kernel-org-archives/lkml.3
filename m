Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaAQCkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:40:33 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:53792 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaAQCk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:40:29 -0500
Date: Thu, 16 Jan 2014 21:40:26 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, linaro-kernel@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        Michael wang <wangyun@linux.vnet.ibm.com>, fengguang.wu@intel.com
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
In-Reply-To: <52D7CD8C.3010506@linaro.org>
Message-ID: <alpine.LFD.2.10.1401162114051.28907@knanqh.ubzr>
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <20140115073533.GU31570@twins.programming.kicks-ass.net> <52D69D44.4090504@linaro.org> <52D7BC71.9010908@linaro.org> <20140116113801.GN31570@twins.programming.kicks-ass.net>
 <52D7CD8C.3010506@linaro.org>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Daniel Lezcano wrote:

> The question raised when I looked closely how to fully integrate cpuidle with
> the scheduler; in particular, the idle time.
> The scheduler idle time is not the same than the cpuidle idle time.
> A cpu can be idle for the scheduler 1s but it could be interrupted several
> times by an interrupt thus the idle time for cpuidle is different. But anyway
> ...

The idle task would run each time an interrupt has been serviced, either 
to yield to a newly awaken task or to put the CPU back to sleep.  In the 
later case the idle task may simply do extra idleness accounting 
locally.  If the former case happens most of the time then the scheduler 
idle time would be most representative already.

And if threaded IRQs are used then the the scheduler idle time would be 
the same as cpuidle's.

> > We need the idle task, since we need to DO something to go idle, the
> > scheduler needs to pick a task to go do that something. This is the idle
> > task.
> > 
> > You cannot get rid of that.
> > 
> > In fact, the 'doing' of that task is running much of the cpuidle code,
> > so by getting rid of it, there's nobody left to execute that code.
> > 
> > Also, since its already running that cpuidle stuff, integrating it more
> > closely with the scheduler will not in fact change much, it will still
> > run it.
> > 
> > Could of course be I'm not reading what you meant to write, if so, do
> > try again ;-)
> 
> Well, I wanted to have a clarification of what was your feeling about how to
> integrate cpuidle in the scheduler. If removing the idle task (in the future)
> does not make sense for you, I will not insist. Let's see how the code evolves
> by integrating cpuidle and we will figure out what will be the impact on the
> idle task.

I think we should be able to get rid of architecture specific idle 
loops.  The idle loop could be moved close to the scheduler and 
architectures would only need to provide a default CPU halt method for 
when there is nothing else registered with the cpuidle subsystem.


Nicolas
