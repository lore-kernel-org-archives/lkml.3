Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3EJAve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3EJAvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:51:33 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=p2Mg_QFlwKQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=QQEAQuFRF4kA:10 a=Ar5GvMpv0uhZ1o_x-GAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368147092.7373.148.camel@gandalf.local.home>
Subject: Re: [PATCH] x86/sched/dynamic-ticks: Call new
 schedule_irq_disable() for scheduling in entry_64.S
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 09 May 2013 20:51:32 -0400
In-Reply-To: <1368146829.7373.146.camel@gandalf.local.home>
References: <1368062480.7373.95.camel@gandalf.local.home>
	 <20130510002203.GA2394@somewhere>
	 <1368146829.7373.146.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 20:47 -0400, Steven Rostedt wrote:

> > 
> > > +
> > > +	local_irq_enable();
> > > +	__schedule();
> > 
> > Are you sure it's fine to call __schedule() instead of schedule()?
> > I don't know much about the blk work to handle there but it may be
> > worth considering.
> 
> Note, this isn't a call to schedule that was made by normal kernel
> space. This is very much like a preemption. In fact, it is a preemption
> and my first patch used preempt_schedule_irq() instead, but as that's
> made for CONFIG_PREEMPT enabled, it seemed a bit hacky to take that out
> of that context.
> 
> This is only called when the task is being preempted. But because its
> going to user land, its OK. The blk code there is more worried about
> something that did some work, set itself to TASK_UNINTERRUPTIBLE and
> then called schedule() (think completions). That is, the blk code that
> needs to be submitted will be the code that wakes up this task.
> 
> We should never be in anything but TASK_RUNNING when going into user
> space.

Maybe I should rename this function to schedule_user() to explicitly
show that this is for scheduling when we came from or going to user
space.

-- Steve


