Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3LDMrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:47:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab3LDMrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:47:13 -0500
Subject: Re: [BUG] ftrace: support for SOFT_DISABLE to syscall events
 caused huge slowdown of ftrace startup test
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20131203124120.427b9661@gandalf.local.home>
References: <1386090969.1603.72.camel@pathway.suse.cz>
	 <20131203124120.427b9661@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Dec 2013 13:47:10 +0100
Message-ID: <1386161230.1603.74.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt píše v Út 03. 12. 2013 v 12:41 -0500:
> On Tue, 03 Dec 2013 18:16:09 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > Hi,
> > 
> > I tested my ftrace-related patches and enabled also the startup test:
> > 
> >   CONFIG_FTRACE_SELFTEST=y
> >   CONFIG_FTRACE_STARTUP_TEST=y
> > 
> > On today's kernel/git/tip/tip.git, the boot "freezed" for 1 minute when
> > doing "Testing event system syscalls".
> > 
> > A bisect pointed finger to the commit d562aff93bfb530b099 (tracing: Add
> > support for SOFT_DISABLE to syscall events).
> > 
> > It seems that the culprit are the "synchronize_sched" calls added to
> > "unreg_event_syscall_enter" and "unreg_event_syscall_exit" functions.
> > They are called 2312 times during the boot here and are responsible for
> > the delay.
> > 
> > I wonder if it might cause slowdown also at runtime.
> > 
> > I am going to look deeper into the code and eventually come up with a
> > solution. But it might take some time. I am still newbie in the kernel
> > development. Any hints or tips are welcome ;-)
> > 
> 
> Yeah, the synchronize_sched() at all disabling of syscall events seems
> rather extreme. Perhaps this is good enough.
> 
> Dose this work for you?

I could confirm that it removes the delay and looks fine to me.

Acked-by: Petr Mladek <pmladek@suse.cz>

> Tom, do you see anything wrong with this. I'm assuming that the
> synchronize_sched() within the event unregistering, was there for
> deleting of trace instances. By placing the synchronize_sched() only
> within the deletion code, this should be good enough.
> 
> -- Steve
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index f919a2e..a11800a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2314,6 +2314,9 @@ int event_trace_del_tracer(struct trace_array *tr)
>  	/* Disable any running events */
>  	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
>  
> +	/* Access to events are within rcu_read_lock_sched() */
> +	synchronize_sched();
> +
>  	down_write(&trace_event_sem);
>  	__trace_remove_event_dirs(tr);
>  	debugfs_remove_recursive(tr->event_dir);
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index e4b6d11..ea90eb5 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -431,11 +431,6 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>  	if (!tr->sys_refcount_enter)
>  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
>  	mutex_unlock(&syscall_trace_lock);
> -	/*
> -	 * Callers expect the event to be completely disabled on
> -	 * return, so wait for current handlers to finish.
> -	 */
> -	synchronize_sched();
>  }
>  
>  static int reg_event_syscall_exit(struct ftrace_event_file *file,
> @@ -474,11 +469,6 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
>  	if (!tr->sys_refcount_exit)
>  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
>  	mutex_unlock(&syscall_trace_lock);
> -	/*
> -	 * Callers expect the event to be completely disabled on
> -	 * return, so wait for current handlers to finish.
> -	 */
> -	synchronize_sched();
>  }
>  
>  static int __init init_syscall_trace(struct ftrace_event_call *call)


