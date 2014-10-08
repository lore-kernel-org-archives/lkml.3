Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaJHQhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:37:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJHQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:37:07 -0400
Date: Wed, 8 Oct 2014 18:36:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [trace events] WARNING: CPU: 0 PID: 91 at
 kernel/sched/core.c:7253 __might_sleep()
Message-ID: <20141008163657.GN10832@worktop.programming.kicks-ass.net>
References: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
 <20141008104120.GH10832@worktop.programming.kicks-ass.net>
 <20141008110825.58bdb51d@gandalf.local.home>
 <20141008154838.GM10832@worktop.programming.kicks-ass.net>
 <20141008121718.0210c24e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008121718.0210c24e@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:17:18PM -0400, Steven Rostedt wrote:
> On Wed, 8 Oct 2014 17:48:38 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
>  
> > > Wow, what a blast from the past. That code hasn't been touched since
> > > 2009!
> > > 
> > > Anyway, all that thread did was call test work on each cpu, and then
> > > waits to be killed. It should only get a single wake up and that should
> > > be from the kthread_stop() call. IOW, that loop should never be
> > > executed more than once.
> > > 
> > > What exactly is the bug here?
> > 
> > The bug is as explained, the loop is wrong and will revert to a yield
> > 'spin' loop after a single wakeup.
> > 
> > The debugging that caught it is that you exit the loop without setting
> > TASK_RUNNING.
> 
> I understand that it becomes a yield if something sends a wakeup before
> killing it. I highly doubt that would ever happen since it doesn't call
> anything that should wake it up and it only runs at boot up.

Still we should always assume spurious wakeups, its fragile not to and
has so far made life sad a few times.

> Looking at the original email that has the trace, I'm betting it hit
> the race where kthread_stop() was called on the thread before it set
> its state to TASK_INTERRUPTIBLE and then the first call to
> kthread_should_stop() returned true and schedule() was never called and
> the task exited with the TASK_INTERRUPTIBLE state.

Sure.

> Really no harm here. If we had called set_task_state(TASK_RUNNING)
> before exiting this never would have been seen.
> 
> Anyway, as for a fix, if you want to do it fully with setting
> TASK_INTERRUPTBILE again in the loop, I'm fine with it. I still don't
> see any possible way it can be woken up before kthread_should_stop()
> being true, but hey, lets make it more robust. Then if we ever
> extend on the tests that are run, which could add a delayed wake up, it
> would not turn into a yield.

Right, I'll send the patch. While looking I found another issue,
trace_selftest.c:trace_wakeup_test_thread() has a schedule() without a
loop around. We should really not do that.
