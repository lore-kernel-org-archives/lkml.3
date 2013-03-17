Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CQTeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:34:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3CQTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:34:17 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nJI44pA0MDYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z3CilEaj6XsA:10 a=g8xvENqsS2lW9qcYY0gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363548855.25967.135.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing: syscall_*regfunc() can race with
 copy_process()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 17 Mar 2013 15:34:15 -0400
In-Reply-To: <20130317190023.GA24023@redhat.com>
References: <20130317182831.GA22986@redhat.com>
	 <1363546123.25967.125.camel@gandalf.local.home>
	 <20130317190023.GA24023@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 20:00 +0100, Oleg Nesterov wrote:
> On 03/17, Steven Rostedt wrote:
> >
> > On Sun, 2013-03-17 at 19:28 +0100, Oleg Nesterov wrote:
> > > syscall_regfunc() and syscall_unregfunc() should set/clear
> > > TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> > > with copy_process() and miss the new child which was not added to
> > > init_task.tasks list yet.
> > >
> > > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > > under tasklist.
> >
> > Is this because "p = dup_task_struct(current);" is outside the lock?
> > Probably should state this in the change log.
> 
> Not only, syscall_regfunc/syscall_unregfunc can miss the new child.
> 
> Just suppose that syscall_regfunc() takes tasklist right before the
> forking task tries to take it for writing and and the child to the
> list.

I'm a bit confused by the above. Maybe it's the typo with the "and and"
that's confusing me.

> 
> > > +#ifdef CONFIG_TRACEPOINTS
> > > +	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> > > +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > > +	else
> > > +		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > > +#endif
> >
> > I hate seeing #ifdef code like this in C files. Can you add a function
> > to set this in include/trace/syscalls.h:
> 
> It seems that everyone hates them, except me ;)
> 
> > #ifdef CONFIG_TRACEPOINTS
> > static inline void syscall_tracepoint_update(struct task_struct *p)
> > {
> > 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> > 		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > 	else
> > 		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > }
> > #else
> > static inline void syscall_tracepoint_update(struct task_struct *p) {}
> > #endif
> 
> OK, thanks, will do. But perhaps tracepoint_fork() would be better?

tracepoint_fork() is similar to being called trace_fork() which would be
considered a tracepoint. Seeing tracepoint_fork() would make me think it
has something to do with the fork tracepoint.

Do we plan on doing anything other than updating the syscall tracepoint
flag here? I find the "syscall_tracepoint_update()" very descriptive to
what is actually happening. While reading the fork code, seeing
'syscall_tracepoint_update()' would tell me that this has something to
do with syscall tracepoints, which it does. But tracepoint_fork() would
have me think something completely different.

-- Steve


