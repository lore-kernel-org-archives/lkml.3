Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaJHPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:48:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:34148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:48:42 -0400
Date: Wed, 8 Oct 2014 17:48:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [trace events] WARNING: CPU: 0 PID: 91 at
 kernel/sched/core.c:7253 __might_sleep()
Message-ID: <20141008154838.GM10832@worktop.programming.kicks-ass.net>
References: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
 <20141008104120.GH10832@worktop.programming.kicks-ass.net>
 <20141008110825.58bdb51d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008110825.58bdb51d@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:08:25AM -0400, Steven Rostedt wrote:
> > Steve, wth is that thing supposed to do?
> > 
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	while (!kthread_should_stop())
> > 		schedule();
> > 
> > That looks broken alright. It'll revert to a yield() 'spin' loop if it
> > ever gets a wakeup for anything other than the kthread_stop().
> > 
> > Did you mean to write something like:
> > 
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	while (!kthread_should_stop()) {
> > 		schedule();
> > 		set_current_state(TASK_INTERRUPTIBLE);
> > 	}
> > 	__set_current_state(TASK_RUNNING);
> > 
> > ?
> 
> Wow, what a blast from the past. That code hasn't been touched since
> 2009!
> 
> Anyway, all that thread did was call test work on each cpu, and then
> waits to be killed. It should only get a single wake up and that should
> be from the kthread_stop() call. IOW, that loop should never be
> executed more than once.
> 
> What exactly is the bug here?

The bug is as explained, the loop is wrong and will revert to a yield
'spin' loop after a single wakeup.

The debugging that caught it is that you exit the loop without setting
TASK_RUNNING.
