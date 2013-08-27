Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3H0XcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:32:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:38881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3H0XcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:32:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,971,1367996400"; 
   d="scan'208";a="369429413"
Message-ID: <1377646336.15688.55.camel@empanada>
Subject: Re: [PATCH v7 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 18:32:16 -0500
In-Reply-To: <20130827160827.1661a056@gandalf.local.home>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	 <a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
	 <20130827160827.1661a056@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 16:08 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 14:40:13 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> > @@ -415,9 +429,14 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
> >  		return;
> >  	mutex_lock(&syscall_trace_lock);
> >  	tr->sys_refcount_enter--;
> > -	clear_bit(num, tr->enabled_enter_syscalls);
> > +	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
> >  	if (!tr->sys_refcount_enter)
> >  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
> > +	/*
> > +	 * Callers expect the event to be completely disabled on
> > +	 * return, so wait for current handlers to finish.
> > +	 */
> > +	synchronize_sched();
> >  	mutex_unlock(&syscall_trace_lock);
> >  }
> >  
> > @@ -435,7 +454,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
> >  	if (!tr->sys_refcount_exit)
> >  		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
> >  	if (!ret) {
> > -		set_bit(num, tr->enabled_exit_syscalls);
> > +		rcu_assign_pointer(tr->exit_syscall_files[num], file);
> >  		tr->sys_refcount_exit++;
> >  	}
> >  	mutex_unlock(&syscall_trace_lock);
> > @@ -453,9 +472,14 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
> >  		return;
> >  	mutex_lock(&syscall_trace_lock);
> >  	tr->sys_refcount_exit--;
> > -	clear_bit(num, tr->enabled_exit_syscalls);
> > +	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
> >  	if (!tr->sys_refcount_exit)
> >  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
> > +	/*
> > +	 * Callers expect the event to be completely disabled on
> > +	 * return, so wait for current handlers to finish.
> > +	 */
> > +	synchronize_sched();
> >  	mutex_unlock(&syscall_trace_lock);
> 
> Can we do the synchronize_sched() after the mutex unlock in these two
> places?
> 

Yeah, I think that should be ok and there should be no need to delay
waiters for that mutex - I'll look at moving it out for the next
revision.

Thanks,

Tom

> -- Steve
> 
> 
> >  }
> >  
> 


