Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaJHQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:17:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:30707 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751656AbaJHQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:17:21 -0400
Date: Wed, 8 Oct 2014 12:17:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [trace events] WARNING: CPU: 0 PID: 91 at
 kernel/sched/core.c:7253 __might_sleep()
Message-ID: <20141008121718.0210c24e@gandalf.local.home>
In-Reply-To: <20141008154838.GM10832@worktop.programming.kicks-ass.net>
References: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
	<20141008104120.GH10832@worktop.programming.kicks-ass.net>
	<20141008110825.58bdb51d@gandalf.local.home>
	<20141008154838.GM10832@worktop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014 17:48:38 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

 
> > Wow, what a blast from the past. That code hasn't been touched since
> > 2009!
> > 
> > Anyway, all that thread did was call test work on each cpu, and then
> > waits to be killed. It should only get a single wake up and that should
> > be from the kthread_stop() call. IOW, that loop should never be
> > executed more than once.
> > 
> > What exactly is the bug here?
> 
> The bug is as explained, the loop is wrong and will revert to a yield
> 'spin' loop after a single wakeup.
> 
> The debugging that caught it is that you exit the loop without setting
> TASK_RUNNING.

I understand that it becomes a yield if something sends a wakeup before
killing it. I highly doubt that would ever happen since it doesn't call
anything that should wake it up and it only runs at boot up.

Looking at the original email that has the trace, I'm betting it hit
the race where kthread_stop() was called on the thread before it set
its state to TASK_INTERRUPTIBLE and then the first call to
kthread_should_stop() returned true and schedule() was never called and
the task exited with the TASK_INTERRUPTIBLE state.

Really no harm here. If we had called set_task_state(TASK_RUNNING)
before exiting this never would have been seen.

Anyway, as for a fix, if you want to do it fully with setting
TASK_INTERRUPTBILE again in the loop, I'm fine with it. I still don't
see any possible way it can be woken up before kthread_should_stop()
being true, but hey, lets make it more robust. Then if we ever
extend on the tests that are run, which could add a delayed wake up, it
would not turn into a yield.

-- Steve
