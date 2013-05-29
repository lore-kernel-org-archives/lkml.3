Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966200Ab3E2Nlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:41:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab3E2Nln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:41:43 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SF8-ipd7Fh4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=cu63OdLxYnwA:10 a=HaqBIRr2zVTZNHWTX94A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369834900.15552.62.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 29 May 2013 09:41:40 -0400
In-Reply-To: <20130529075249.GC12193@twins.programming.kicks-ass.net>
References: <1369785676.15552.55.camel@gandalf.local.home>
	 <20130529075249.GC12193@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:52 +0200, Peter Zijlstra wrote:

> Just to be clear, its the idle part that's a problem, right?

Actually, it's the userspace part that's triggered the bugs.


>  Being stuck
> in userspace isn't a problem since if that CPU is in userspace its
> certainly not got a reference to whatever list entry we're removing.

The issue is coming out of and going into userspace. For example, we
trace the function user_exit(), which is the function that tells RCU
it's coming back into the kernel. At this point, RCU doesn't keep track
of the preempt disable/enable that's done there.

> 
> Now when the CPU really is idle, its obviously not using tracing either;
> so only the gray area where RCU thinks we're idle but we're not actually
> idle is a problem?

Right. It's going into and coming out of idle or userspace that's the
issue. There's a very small window where RCU is blind to this.

> 
> Is there something a little smarter we can do? Could we use
> on_each_cpu_cond() with a function that checks if the CPU really is
> fully idle?

One thing I thought about doing was both a synchronize_sched() and then
a msleep(5). As a single function trace should never last 5
milliseconds. But to me, that's just hacky, and this is the real
solution.

> 
> > To implement the RCU synchronization, instead of using
> > synchronize_sched() the use of schedule_on_each_cpu() is performed. This
> > means that when a dynamically allocated ftrace_ops, or a control ops is
> > being unregistered, all CPUs must be touched and execute a ftrace_sync()
> > stub function via the work queues. This will rip CPUs out from idle or
> > in dynamic tick mode. This only happens when a user disables perf
> > function tracing or other dynamically allocated function tracers, but it
> > allows us to continue to debug RCU and context tracking with function
> > tracing.
> 
> I don't suppose there's anything perf can do to about this right? Since
> its all on user demand we're kinda stuck with dynamic memory.

Right, and perf isn't the only one. SystemTap, lttng, and even other
parts of ftrace can have this problem. Anyone that does a dynamic
allocation needs a full synchronization.

-- Steve


