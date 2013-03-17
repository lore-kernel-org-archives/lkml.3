Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3CQTCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab3CQTC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:02:28 -0400
Date: Sun, 17 Mar 2013 20:00:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20130317190023.GA24023@redhat.com>
References: <20130317182831.GA22986@redhat.com> <1363546123.25967.125.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363546123.25967.125.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Steven Rostedt wrote:
>
> On Sun, 2013-03-17 at 19:28 +0100, Oleg Nesterov wrote:
> > syscall_regfunc() and syscall_unregfunc() should set/clear
> > TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> > with copy_process() and miss the new child which was not added to
> > init_task.tasks list yet.
> >
> > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > under tasklist.
>
> Is this because "p = dup_task_struct(current);" is outside the lock?
> Probably should state this in the change log.

Not only, syscall_regfunc/syscall_unregfunc can miss the new child.

Just suppose that syscall_regfunc() takes tasklist right before the
forking task tries to take it for writing and and the child to the
list.

> > +#ifdef CONFIG_TRACEPOINTS
> > +	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> > +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > +	else
> > +		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> > +#endif
>
> I hate seeing #ifdef code like this in C files. Can you add a function
> to set this in include/trace/syscalls.h:

It seems that everyone hates them, except me ;)

> #ifdef CONFIG_TRACEPOINTS
> static inline void syscall_tracepoint_update(struct task_struct *p)
> {
> 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> 		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> 	else
> 		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> }
> #else
> static inline void syscall_tracepoint_update(struct task_struct *p) {}
> #endif

OK, thanks, will do. But perhaps tracepoint_fork() would be better?

Oleg.

