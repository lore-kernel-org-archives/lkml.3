Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423536Ab3FUR7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:59:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:64974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423077Ab3FUR7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,914,1363158000"; 
   d="scan'208";a="353663523"
Message-ID: <1371837575.6453.23.camel@empanada>
Subject: Re: [PATCH 10/11] tracing: add and use generic set_trigger_filter()
 implementation
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 12:59:35 -0500
In-Reply-To: <51C3D3FD.2070408@hitachi.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <8fe2c1ceb63a6375b56f046de835742f18b955ce.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C3D3FD.2070408@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Fri, 2013-06-21 at 13:18 +0900, Masami Hiramatsu wrote:
> (2013/06/21 3:31), Tom Zanussi wrote:
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 88ac7da..7c5627f 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -522,14 +522,6 @@ ftrace_raw_event_##call(void *__data, proto)				\
> >  	int __data_size;						\
> >  	int pc;								\
> >  									\
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > -		     &ftrace_file->flags))				\
> > -		event_triggers_call(ftrace_file);			\
> > -									\
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> > -		     &ftrace_file->flags))				\
> > -		return;							\
> > -									\
> >  	local_save_flags(irq_flags);					\
> >  	pc = preempt_count();						\
> >  									\
> > @@ -547,8 +539,22 @@ ftrace_raw_event_##call(void *__data, proto)				\
> >  									\
> >  	{ assign; }							\
> >  									\
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> > +		     &ftrace_file->flags)) {				\
> > +		ring_buffer_discard_commit(buffer, event);		\
> > +									\
> > +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,		\
> > +			     &ftrace_file->flags))			\
> > +			event_triggers_call(ftrace_file, entry);	\
> > +		return;							\
> > +	}								\
> > +									\
> >  	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
> >  		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
> > +									\
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > +		     &ftrace_file->flags))				\
> > +		event_triggers_call(ftrace_file, entry);		\
> 
> Actually, since "entry" is a part of "event" which may be already discarded,
> I think we should not access it here. It may not cause real problem because
> even if it is discarded, that does NOT mean it is freed. However, it depends
> on the ring-buffer implementation.
> 
> I recommend you to call event triggers before commit the event. It will also
> make the code simpler :)
> 

That's what I originally did, and is what I was referring to when I
mentioned the bit of 'trickiness' here. ;-)

The problem is that the trace_recursive_lock() check in
ring_buffer_lock_reserve() prevents a trigger that itself logs to the
ring buffer from reserving a slot in the buffer, since it's being done
from the same context as the triggering event.  For example, the
stacktrace trigger, which calls trace_dump_stack().

So the code is a bit more convoluted than I'd like because of that -
since we can't really invoke the triggers before the current event is
committed, it waits until the current event is either discarded (because
we're soft disabled) or committed (logging a normally-enabled event).

But you do point out a real problem with this - it means having to look
at a discarded event in the soft-disabled case, and if for example some
interrupt actually reserves and logs an event between the time we do the
discard and invoke the filter, we could end up with a false filtering
outcome.  I'm not sure how to prevent that though at this point - will
have think about it some more...

Tom

> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index e287011..47fa712 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -319,14 +319,6 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
> >  	if (!sys_data)
> >  		return;
> >  
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > -		     &sys_data->enter_file->flags))
> > -		event_triggers_call(sys_data->enter_file);
> > -
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > -		     &sys_data->enter_file->flags))
> > -		return;
> > -
> >  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
> >  
> >  	buffer = tr->trace_buffer.buffer;
> > @@ -339,9 +331,23 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
> >  	entry->nr = syscall_nr;
> >  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> >  
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > +		     &sys_data->enter_file->flags)) {
> > +		ring_buffer_discard_commit(buffer, event);
> > +
> > +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > +			     &sys_data->enter_file->flags))
> > +			event_triggers_call(sys_data->enter_file, entry);
> > +		return;
> > +	}
> > +
> >  	if (!filter_current_check_discard(buffer, sys_data->enter_event,
> >  					  entry, event))
> >  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > +		     &sys_data->enter_file->flags))
> > +		event_triggers_call(sys_data->enter_file, entry);
> >  }
> >  
> >  static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> > @@ -363,14 +369,6 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> >  	if (!sys_data)
> >  		return;
> >  
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > -		     &sys_data->exit_file->flags))
> > -		event_triggers_call(sys_data->exit_file);
> > -
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > -		     &sys_data->exit_file->flags))
> > -		return;
> > -
> >  	buffer = tr->trace_buffer.buffer;
> >  	event = trace_buffer_lock_reserve(buffer,
> >  			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
> > @@ -381,9 +379,23 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> >  	entry->nr = syscall_nr;
> >  	entry->ret = syscall_get_return_value(current, regs);
> >  
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > +		     &sys_data->exit_file->flags)) {
> > +		ring_buffer_discard_commit(buffer, event);
> > +
> > +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > +			     &sys_data->exit_file->flags))
> > +			event_triggers_call(sys_data->exit_file, entry);
> > +		return;
> > +	}
> > +
> >  	if (!filter_current_check_discard(buffer, sys_data->exit_event,
> >  					  entry, event))
> >  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > +		     &sys_data->exit_file->flags))
> > +		event_triggers_call(sys_data->exit_file, entry);
> >  }
> >  
> >  static int reg_event_syscall_enter(struct ftrace_event_file *file,
> > 
> 
> Same changes are needed here.
> 
> Thank you,
> 


