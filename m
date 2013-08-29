Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3H2Cwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:52:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:3880 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3H2Cwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,980,1367996400"; 
   d="scan'208";a="288197075"
Message-ID: <1377744763.1643.78.camel@empanada>
Subject: Re: [PATCH v7 07/10] tracing: add and use generic
 set_trigger_filter() implementation
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Wed, 28 Aug 2013 21:52:43 -0500
In-Reply-To: <20130828123819.4dd50c1e@gandalf.local.home>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	 <354e6cfb2edbf9c78e01ec31374e5e599c9bcdd9.1377631572.git.tom.zanussi@linux.intel.com>
	 <20130828123819.4dd50c1e@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 12:38 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 14:40:19 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
>  
> >  enum {
> >  	FILTER_OTHER = 0,
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 326ba32..6c701c3 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -412,13 +412,15 @@ static inline notrace int ftrace_get_offsets_##call(			\
> >   *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
> >   *	struct ring_buffer_event *event;
> >   *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
> > + *	enum event_trigger_type __tt = ETT_NONE;
> >   *	struct ring_buffer *buffer;
> >   *	unsigned long irq_flags;
> >   *	int __data_size;
> >   *	int pc;
> >   *
> > - *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > - *		     &ftrace_file->flags))
> > + *	if ((ftrace_file->flags & (FTRACE_EVENT_FL_SOFT_DISABLED |
> > + *	     FTRACE_EVENT_FL_TRIGGER_MODE)) ==
> > + *	    FTRACE_EVENT_FL_SOFT_DISABLED)
> 
> Don't worry too much about 80 character limit here. Move the
> FL_SOFT_DISABLED up.
> 
> >   *		return;
> >   *
> >   *	local_save_flags(irq_flags);
> > @@ -437,9 +439,19 @@ static inline notrace int ftrace_get_offsets_##call(			\
> >   *	{ <assign>; }  <-- Here we assign the entries by the __field and
> >   *			   __array macros.
> >   *
> > - *	if (!filter_current_check_discard(buffer, event_call, entry, event))
> > - *		trace_nowake_buffer_unlock_commit(buffer,
> > - *						   event, irq_flags, pc);
> > + *	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> > + *		     &ftrace_file->flags))
> > + *		__tt = event_triggers_call(ftrace_file, entry);
> > + *
> > + *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> > + *		     &ftrace_file->flags))
> > + *		ring_buffer_discard_commit(buffer, event);
> > + *	else if (!filter_current_check_discard(buffer, event_call,
> > + *					       entry, event))
> > + *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
> > + *
> > + *	if (__tt)
> > + *		event_triggers_post_call(ftrace_file, __tt);
> >   * }
> >   *
> >   * static struct trace_event ftrace_event_type_<call> = {
> > @@ -521,17 +533,15 @@ ftrace_raw_event_##call(void *__data, proto)				\
> >  	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
> >  	struct ring_buffer_event *event;				\
> >  	struct ftrace_raw_##call *entry;				\
> > +	enum event_trigger_type __tt = ETT_NONE;			\
> >  	struct ring_buffer *buffer;					\
> >  	unsigned long irq_flags;					\
> >  	int __data_size;						\
> >  	int pc;								\
> >  									\
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > -		     &ftrace_file->flags))				\
> > -		event_triggers_call(ftrace_file);			\
> > -									\
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> > -		     &ftrace_file->flags))				\
> > +	if ((ftrace_file->flags & (FTRACE_EVENT_FL_SOFT_DISABLED |	\
> > +	     FTRACE_EVENT_FL_TRIGGER_MODE)) ==				\
> > +	    FTRACE_EVENT_FL_SOFT_DISABLED)				\
> 
> Ditto.
> 
> Also, I don't think we need to worry about the flags changing, so we
> should be able to just save it.
> 
> 	unsigned long eflags = ftrace_file_flags;
> 
> And then we can also only delay the event triggers if it has a
> condition. What about adding a FTRACE_EVENT_FL_TRIGGER_COND_BIT, and do:
> 
> 	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND))
> 		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
> 			event_triggers_call(ftrace_file, NULL);
> 
> 		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
> 			return;
> 	}
> 

I like the additional TRIGGER_COND flag, but as written I think the
above leads to different output in the non-SOFT_DISABLED trigger cases
depending on whether it's set or or not.  For instance, stacktrace
triggers invoked when TRIGGER_COND is cleared will print
trace_dump_stack() before the triggering event (above, which falls
through to print the triggering event following the stacktrace if not
SOFT_DISABLED), but if called for the same triggers with TRIGGER_COND
set, the stacktrace will end up following the triggering event
(event_triggers_call()/event_triggers_post_call() not called above, but
following the triggering event print.)

So above I think we want to call the triggers and then return only if
there are no filters on the triggers and the triggering event is soft
disabled e.g.:

	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND))
 		if ((eflags & FTRACE_EVENT_FL_TRIGGER_MODE) &&
		 (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)) {
 			event_triggers_call(ftrace_file, NULL);
 			return;
 	}
 
Otherwise, fall through and call the triggers after the current event is
logged.  Of course, none of this matters for the non-stacktrace
(non-logging) triggers - they can be called anytime without loss of
consistency in the output.

Tom

> >  		return;							\
> >  									\
> >  	local_save_flags(irq_flags);					\
> > @@ -551,8 +561,19 @@ ftrace_raw_event_##call(void *__data, proto)				\
> >  									\
> >  	{ assign; }							\
> >  									\
> > -	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > +		     &ftrace_file->flags))				\
> > +		__tt = event_triggers_call(ftrace_file, entry);		\
> 
> Then here we test just the TRIGGER_COND bit.
> 

> 
> > +									\
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,                 \
> > +		     &ftrace_file->flags))                              \
> > +		ring_buffer_discard_commit(buffer, event);              \
> > +	else if (!filter_current_check_discard(buffer, event_call,      \
> > +					       entry, event))		\
> >  		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
> > +									\
> > +	if (__tt)							\
> > +		event_triggers_post_call(ftrace_file, __tt);		\
> 
> This part is fine.
> 
> >  }
> >  /*
> >   * The ftrace_test_probe is compiled out, it is only here as a build time check
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 3cb846e..af5f3b6 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -994,6 +994,10 @@ extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
> >  extern void print_subsystem_event_filter(struct event_subsystem *system,
> >  					 struct trace_seq *s);
> >  extern int filter_assign_type(const char *type);
> > +extern int create_event_filter(struct ftrace_event_call *call,
> > +			       char *filter_str, bool set_str,
> > +			       struct event_filter **filterp);
> > +extern void free_event_filter(struct event_filter *filter);
> >  
> >  struct ftrace_event_field *
> >  trace_find_event_field(struct ftrace_event_call *call, char *name);
> > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > index 97daa8c..0c45aa1 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -781,6 +781,11 @@ static void __free_filter(struct event_filter *filter)
> >  	kfree(filter);
> >  }
> >  
> > +void free_event_filter(struct event_filter *filter)
> > +{
> > +	__free_filter(filter);
> > +}
> > +
> >  /*
> >   * Called when destroying the ftrace_event_call.
> >   * The call is being freed, so we do not need to worry about
> > @@ -1806,6 +1811,14 @@ static int create_filter(struct ftrace_event_call *call,
> >  	return err;
> >  }
> >  
> > +int create_event_filter(struct ftrace_event_call *call,
> > +			char *filter_str, bool set_str,
> > +			struct event_filter **filterp)
> > +{
> > +	return create_filter(call, filter_str, set_str, filterp);
> > +}
> > +
> > +
> >  /**
> >   * create_system_filter - create a filter for an event_subsystem
> >   * @system: event_subsystem to create a filter for
> > diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> > index 54678e2..b5e7ca7 100644
> > --- a/kernel/trace/trace_events_trigger.c
> > +++ b/kernel/trace/trace_events_trigger.c
> > @@ -43,24 +43,53 @@ struct event_trigger_data {
> >  static void
> >  trigger_data_free(struct event_trigger_data *data)
> >  {
> > +	if (data->cmd_ops->set_filter)
> > +		data->cmd_ops->set_filter(NULL, data, NULL);
> > +
> >  	synchronize_sched(); /* make sure current triggers exit before free */
> >  	kfree(data);
> >  }
> >  
> > -void event_triggers_call(struct ftrace_event_file *file)
> > +enum event_trigger_type
> > +event_triggers_call(struct ftrace_event_file *file, void *rec)
> >  {
> >  	struct event_trigger_data *data;
> > +	enum event_trigger_type tt = ETT_NONE;
> >  
> >  	if (list_empty(&file->triggers))
> > -		return;
> > +		return tt;
> >  
> >  	preempt_disable_notrace();
> > -	list_for_each_entry_rcu(data, &file->triggers, list)
> > +	list_for_each_entry_rcu(data, &file->triggers, list) {
> > +		if (data->filter && !filter_match_preds(data->filter, rec))
> 
> We would need a check for !rec, just to be safe (with the mods I talked
> about).
> 
> > +			continue;
> > +		if (data->cmd_ops->post_trigger) {
> > +			tt |= data->cmd_ops->trigger_type;
> > +			continue;
> > +		}
> >  		data->ops->func((void **)&data);
> > +	}
> >  	preempt_enable_notrace();
> > +
> > +	return tt;
> >  }
> >  EXPORT_SYMBOL_GPL(event_triggers_call);
> >  
> > +void
> > +event_triggers_post_call(struct ftrace_event_file *file,
> > +			 enum event_trigger_type tt)
> > +{
> > +	struct event_trigger_data *data;
> > +
> > +	preempt_disable_notrace();
> > +	list_for_each_entry_rcu(data, &file->triggers, list) {
> > +		if (data->cmd_ops->trigger_type & tt)
> > +			data->ops->func((void **)&data);
> > +	}
> > +	preempt_enable_notrace();
> > +}
> > +EXPORT_SYMBOL_GPL(event_triggers_post_call);
> > +
> >  static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
> >  {
> >  	struct ftrace_event_file *event_file = event_file_data(m->private);
> > @@ -561,6 +590,66 @@ event_trigger_callback(struct event_command *cmd_ops,
> >  	goto out;
> >  }
> >  
> > +/**
> > + * set_trigger_filter - generic event_command @set_filter
> > + * implementation
> > + *
> > + * Common implementation for event command filter parsing and filter
> > + * instantiation.
> > + *
> > + * Usually used directly as the @set_filter method in event command
> > + * implementations.
> > + *
> > + * Also used to remove a filter (if filter_str = NULL).
> > + */
> > +static int set_trigger_filter(char *filter_str, void *trigger_data,
> > +			      struct ftrace_event_file *file)
> > +{
> > +	struct event_trigger_data *data = trigger_data;
> > +	struct event_filter *filter = NULL, *tmp;
> > +	int ret = -EINVAL;
> > +	char *s;
> > +
> > +	if (!filter_str) /* clear the current filter */
> > +		goto assign;
> > +
> > +	s = strsep(&filter_str, " \t");
> > +
> > +	if (!strlen(s) || strcmp(s, "if") != 0)
> > +		goto out;
> > +
> > +	if (!filter_str)
> > +		goto out;
> > +
> > +	/* The filter is for the 'trigger' event, not the triggered event */
> > +	ret = create_event_filter(file->event_call, filter_str, false, &filter);
> > +	if (ret)
> > +		goto out;
> > + assign:
> > +	tmp = data->filter;
> > +
> > +	rcu_assign_pointer(data->filter, filter);
> > +
> > +	if (tmp) {
> > +		/* Make sure the call is done with the filter */
> > +		synchronize_sched();
> > +		free_event_filter(tmp);
> > +	}
> > +
> > +	kfree(data->filter_str);
> > +
> > +	if (filter_str) {
> > +		data->filter_str = kstrdup(filter_str, GFP_KERNEL);
> > +		if (!data->filter_str) {
> > +			free_event_filter(data->filter);
> > +			data->filter = NULL;
> > +			ret = -ENOMEM;
> > +		}
> > +	}
> > + out:
> > +	return ret;
> > +}
> > +
> >  static void
> >  traceon_trigger(void **_data)
> >  {
> > @@ -698,6 +787,7 @@ static struct event_command trigger_traceon_cmd = {
> >  	.reg			= register_trigger,
> >  	.unreg			= unregister_trigger,
> >  	.get_trigger_ops	= onoff_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  static struct event_command trigger_traceoff_cmd = {
> > @@ -707,6 +797,7 @@ static struct event_command trigger_traceoff_cmd = {
> >  	.reg			= register_trigger,
> >  	.unreg			= unregister_trigger,
> >  	.get_trigger_ops	= onoff_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  static void
> > @@ -788,6 +879,7 @@ static struct event_command trigger_snapshot_cmd = {
> >  	.reg			= register_snapshot_trigger,
> >  	.unreg			= unregister_trigger,
> >  	.get_trigger_ops	= snapshot_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  /*
> > @@ -867,6 +959,7 @@ static struct event_command trigger_stacktrace_cmd = {
> >  	.reg			= register_trigger,
> >  	.unreg			= unregister_trigger,
> >  	.get_trigger_ops	= stacktrace_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  static __init void unregister_trigger_traceon_traceoff_cmds(void)
> > @@ -1194,6 +1287,7 @@ static struct event_command trigger_enable_cmd = {
> >  	.reg			= event_enable_register_trigger,
> >  	.unreg			= event_enable_unregister_trigger,
> >  	.get_trigger_ops	= event_enable_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  static struct event_command trigger_disable_cmd = {
> > @@ -1203,6 +1297,7 @@ static struct event_command trigger_disable_cmd = {
> >  	.reg			= event_enable_register_trigger,
> >  	.unreg			= event_enable_unregister_trigger,
> >  	.get_trigger_ops	= event_enable_get_trigger_ops,
> > +	.set_filter		= set_trigger_filter,
> >  };
> >  
> >  static __init void unregister_trigger_enable_disable_cmds(void)
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index 4f56d54..84cdbce 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -306,6 +306,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
> >  	struct syscall_trace_enter *entry;
> >  	struct syscall_metadata *sys_data;
> >  	struct ring_buffer_event *event;
> > +	enum event_trigger_type __tt = ETT_NONE;
> >  	struct ring_buffer *buffer;
> >  	unsigned long irq_flags;
> >  	int pc;
> > @@ -321,9 +322,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
> >  	if (!ftrace_file)
> >  		return;
> >  
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> > -		event_triggers_call(ftrace_file);
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> > +	if ((ftrace_file->flags &
> > +	     (FTRACE_EVENT_FL_SOFT_DISABLED | FTRACE_EVENT_FL_TRIGGER_MODE)) ==
> > +	    FTRACE_EVENT_FL_SOFT_DISABLED)
> 
> We would need the same changes here too.
> 
> -- Steve
> 
> >  		return;
> >  
> >  	sys_data = syscall_nr_to_meta(syscall_nr);
> > @@ -345,10 +346,17 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
> >  	entry->nr = syscall_nr;
> >  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> >  
> > -	if (!filter_current_check_discard(buffer, sys_data->enter_event,
> > -					  entry, event))
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> > +		__tt = event_triggers_call(ftrace_file, entry);
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> > +		ring_buffer_discard_commit(buffer, event);
> > +	else if (!filter_current_check_discard(buffer, sys_data->enter_event,
> > +					       entry, event))
> >  		trace_current_buffer_unlock_commit(buffer, event,
> >  						   irq_flags, pc);
> > +	if (__tt)
> > +		event_triggers_post_call(ftrace_file, __tt);
> >  }
> >  
> >  static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> > @@ -358,6 +366,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> >  	struct syscall_trace_exit *entry;
> >  	struct syscall_metadata *sys_data;
> >  	struct ring_buffer_event *event;
> > +	enum event_trigger_type __tt = ETT_NONE;
> >  	struct ring_buffer *buffer;
> >  	unsigned long irq_flags;
> >  	int pc;
> > @@ -372,9 +381,9 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> >  	if (!ftrace_file)
> >  		return;
> >  
> > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> > -		event_triggers_call(ftrace_file);
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> > +	if ((ftrace_file->flags &
> > +	     (FTRACE_EVENT_FL_SOFT_DISABLED | FTRACE_EVENT_FL_TRIGGER_MODE)) ==
> > +	    FTRACE_EVENT_FL_SOFT_DISABLED)
> >  		return;
> >  
> >  	sys_data = syscall_nr_to_meta(syscall_nr);
> > @@ -395,10 +404,17 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> >  	entry->nr = syscall_nr;
> >  	entry->ret = syscall_get_return_value(current, regs);
> >  
> > -	if (!filter_current_check_discard(buffer, sys_data->exit_event,
> > -					  entry, event))
> > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> > +		__tt = event_triggers_call(ftrace_file, entry);
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> > +		ring_buffer_discard_commit(buffer, event);
> > +	else if (!filter_current_check_discard(buffer, sys_data->exit_event,
> > +					       entry, event))
> >  		trace_current_buffer_unlock_commit(buffer, event,
> >  						   irq_flags, pc);
> > +	if (__tt)
> > +		event_triggers_post_call(ftrace_file, __tt);
> >  }
> >  
> >  static int reg_event_syscall_enter(struct ftrace_event_file *file,
> 


