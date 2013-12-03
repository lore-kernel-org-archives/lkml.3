Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3LCWdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:33:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:51312 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab3LCWc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:32:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,820,1378882800"; 
   d="scan'208";a="444088945"
Message-ID: <1386109974.3048.262.camel@empanada>
Subject: Re: [BUG] ftrace: support for SOFT_DISABLE to syscall events caused
 huge slowdown of ftrace startup test
From: Tom Zanussi <tom.zanussi@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 16:32:54 -0600
In-Reply-To: <1386103614.3048.247.camel@empanada>
References: <1386090969.1603.72.camel@pathway.suse.cz>
	 <20131203124120.427b9661@gandalf.local.home>
	 <1386103614.3048.247.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 14:46 -0600, Tom Zanussi wrote:
> On Tue, 2013-12-03 at 12:41 -0500, Steven Rostedt wrote:
> > On Tue, 03 Dec 2013 18:16:09 +0100
> > Petr Mladek <pmladek@suse.cz> wrote:
> > 
> > > Hi,
> > > 
> > > I tested my ftrace-related patches and enabled also the startup test:
> > > 
> > >   CONFIG_FTRACE_SELFTEST=y
> > >   CONFIG_FTRACE_STARTUP_TEST=y
> > > 
> > > On today's kernel/git/tip/tip.git, the boot "freezed" for 1 minute when
> > > doing "Testing event system syscalls".
> > > 
> > > A bisect pointed finger to the commit d562aff93bfb530b099 (tracing: Add
> > > support for SOFT_DISABLE to syscall events).
> > > 
> > > It seems that the culprit are the "synchronize_sched" calls added to
> > > "unreg_event_syscall_enter" and "unreg_event_syscall_exit" functions.
> > > They are called 2312 times during the boot here and are responsible for
> > > the delay.
> > > 
> > > I wonder if it might cause slowdown also at runtime.
> > > 
> > > I am going to look deeper into the code and eventually come up with a
> > > solution. But it might take some time. I am still newbie in the kernel
> > > development. Any hints or tips are welcome ;-)
> > > 
> > 
> > Yeah, the synchronize_sched() at all disabling of syscall events seems
> > rather extreme. Perhaps this is good enough.
> > 
> > Dose this work for you?
> > 
> 
> I'm also seeing a very long (~ 1 min or so) startup with
> CONFIG_FTRACE_STARTUP_TEST, but that seems to be the case with or
> without your patch, or even with the SOFT_DISABLE syscall patch
> reverted.
> 
> I haven't done a comparison between any of these cases, just noting that
> unless it's expected for the ftrace startup test to take a full minute
> or so, there might be a problem somewhere else as well.  Or I may be not
> testing correctly - if it was bisected to the SOFT_DISABLE commit, I'm
> guessing there's a more pronounced difference than what I'm seeing
> here...
> 

OK, so the ftrace startup test does apparently take a long time in the
normal case, about 1 min on my machine, but that goes to 3 minutes with
the SOFT_DISABLE and the selftest output shows the time is in the
syscall tests.

Your patch brings that down to 1 minute again, so it does fix the
problem here, and moving the synchronize_sched() out to the tracer
deletion code instead makes more sense - I didn't realize it was so
expensive; the other case where an event handler could go away would be
in kprobes, but that's covered too via disable_trace_probe().

Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>

> Tom
> 
> > Tom, do you see anything wrong with this. I'm assuming that the
> > synchronize_sched() within the event unregistering, was there for
> > deleting of trace instances. By placing the synchronize_sched() only
> > within the deletion code, this should be good enough.
> > 
> > -- Steve
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index f919a2e..a11800a 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -2314,6 +2314,9 @@ int event_trace_del_tracer(struct trace_array *tr)
> >  	/* Disable any running events */
> >  	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
> >  
> > +	/* Access to events are within rcu_read_lock_sched() */
> > +	synchronize_sched();
> > +
> >  	down_write(&trace_event_sem);
> >  	__trace_remove_event_dirs(tr);
> >  	debugfs_remove_recursive(tr->event_dir);
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index e4b6d11..ea90eb5 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -431,11 +431,6 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
> >  	if (!tr->sys_refcount_enter)
> >  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
> >  	mutex_unlock(&syscall_trace_lock);
> > -	/*
> > -	 * Callers expect the event to be completely disabled on
> > -	 * return, so wait for current handlers to finish.
> > -	 */
> > -	synchronize_sched();
> >  }
> >  
> >  static int reg_event_syscall_exit(struct ftrace_event_file *file,
> > @@ -474,11 +469,6 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
> >  	if (!tr->sys_refcount_exit)
> >  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
> >  	mutex_unlock(&syscall_trace_lock);
> > -	/*
> > -	 * Callers expect the event to be completely disabled on
> > -	 * return, so wait for current handlers to finish.
> > -	 */
> > -	synchronize_sched();
> >  }
> >  
> >  static int __init init_syscall_trace(struct ftrace_event_call *call)
> 


