Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3IERV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:21:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IERV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:21:56 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=R0t97Tp8muEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=65ulK5L86BMA:10 a=QyXUC8HyAAAA:8 a=uqkJdm9wD-h6vkodfZ4A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 5 Sep 2013 13:21:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 02/10] tracing: Add basic event trigger framework
Message-ID: <20130905132153.550819bf@gandalf.local.home>
In-Reply-To: <1197d661c123b9c5d084de2b7817aef6a9779e8c.1378176577.git.tom.zanussi@linux.intel.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
	<1197d661c123b9c5d084de2b7817aef6a9779e8c.1378176577.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Sep 2013 22:52:18 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:


>  include/linux/ftrace_event.h        |  11 ++
>  include/trace/ftrace.h              |   4 +
>  kernel/trace/Makefile               |   1 +
>  kernel/trace/trace.h                | 182 ++++++++++++++++++++++++
>  kernel/trace/trace_events.c         |  21 ++-
>  kernel/trace/trace_events_trigger.c | 268 ++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_syscalls.c       |   4 +
>  7 files changed, 486 insertions(+), 5 deletions(-)
>  create mode 100644 kernel/trace/trace_events_trigger.c
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5eaa746..34ae1d4 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -255,6 +255,7 @@ enum {
>  	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
>  	FTRACE_EVENT_FL_SOFT_MODE_BIT,
>  	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> +	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
>  };
>  
>  /*
> @@ -264,12 +265,14 @@ enum {
>   *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
>   *  SOFT_DISABLED - When set, do not trace the event (even though its
>   *                   tracepoint may be enabled)
> + *  TRIGGER_MODE  - When set, invoke the triggers associated with the event
>   */
>  enum {
>  	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
>  	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
>  	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
>  	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
> +	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
>  };
>  
>  struct ftrace_event_file {
> @@ -278,6 +281,7 @@ struct ftrace_event_file {
>  	struct dentry			*dir;
>  	struct trace_array		*tr;
>  	struct ftrace_subsystem_dir	*system;
> +	struct list_head		triggers;
>  
>  	/*
>  	 * 32 bit flags:
> @@ -285,6 +289,7 @@ struct ftrace_event_file {
>  	 *   bit 1:		enabled cmd record
>  	 *   bit 2:		enable/disable with the soft disable bit
>  	 *   bit 3:		soft disabled
> +	 *   bit 4:		trigger enabled
>  	 *
>  	 * Note: The bits must be set atomically to prevent races
>  	 * from other writers. Reads of flags do not need to be in
> @@ -296,6 +301,7 @@ struct ftrace_event_file {
>  	 */
>  	unsigned long		flags;
>  	atomic_t		sm_ref;	/* soft-mode reference counter */
> +	atomic_t		tm_ref;	/* trigger-mode reference counter */
>  };
>  
>  #define __TRACE_EVENT_FLAGS(name, value)				\
> @@ -310,12 +316,17 @@ struct ftrace_event_file {
>  
>  #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
>  
> +enum event_trigger_type {
> +	ETT_NONE		= (0),
> +};
> +
>  extern void destroy_preds(struct ftrace_event_call *call);
>  extern int filter_match_preds(struct event_filter *filter, void *rec);
>  extern int filter_current_check_discard(struct ring_buffer *buffer,
>  					struct ftrace_event_call *call,
>  					void *rec,
>  					struct ring_buffer_event *event);
> +extern void event_triggers_call(struct ftrace_event_file *file);
>  
>  enum {
>  	FILTER_OTHER = 0,
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 41a6643..326ba32 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -526,6 +526,10 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  	int __data_size;						\
>  	int pc;								\
>  									\
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> +		     &ftrace_file->flags))				\
> +		event_triggers_call(ftrace_file);			\
> +									\
>  	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
>  		     &ftrace_file->flags))				\
>  		return;							\
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index d7e2068..1378e84 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -50,6 +50,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
>  obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
>  endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
>  ifeq ($(CONFIG_PM_RUNTIME),y)
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b1227b9..37b8ecf 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1016,9 +1016,191 @@ extern void trace_event_enable_cmd_record(bool enable);
>  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
>  extern int event_trace_del_tracer(struct trace_array *tr);
>  
> +static inline void *event_file_data(struct file *filp)
> +{
> +	return ACCESS_ONCE(file_inode(filp)->i_private);
> +}
> +
>  extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
>  
> +extern const struct file_operations event_trigger_fops;
> +
> +extern int register_trigger_cmds(void);
> +extern void clear_event_triggers(struct trace_array *tr);
> +
> +struct event_trigger_data {
> +	unsigned long			count;
> +	int				ref;
> +	struct event_trigger_ops	*ops;
> +	struct event_command *		cmd_ops;

	struct event_command		*cmd_ops;


> +	struct event_filter		*filter;
> +	char				*filter_str;
> +	void				*private_data;
> +	struct list_head		list;
> +};
> +
> +/**
> + * struct event_trigger_ops - callbacks for trace event triggers
> + *
> + * The methods in this structure provide per-event trigger hooks for
> + * various trigger operations.
> + *
> + * All the methods below, except for @init() and @free(), must be
> + * implemented.
> + *
> + * @func: The trigger 'probe' function called when the triggering
> + *	event occurs.  The data passed into this callback is the data
> + *	that was supplied to the event_command @reg() function that
> + *	registered the trigger (see struct event_command).
> + *
> + * @init: An optional initialization function called for the trigger
> + *	when the trigger is registered (via the event_command reg()
> + *	function).  This can be used to perform per-trigger
> + *	initialization such as incrementing a per-trigger reference
> + *	count, for instance.  This is usually implemented by the
> + *	generic utility function @event_trigger_init() (see
> + *	trace_event_triggers.c).
> + *
> + * @free: An optional de-initialization function called for the
> + *	trigger when the trigger is unregistered (via the
> + *	event_command @reg() function).  This can be used to perform
> + *	per-trigger de-initialization such as decrementing a
> + *	per-trigger reference count and freeing corresponding trigger
> + *	data, for instance.  This is usually implemented by the
> + *	generic utility function @event_trigger_free() (see
> + *	trace_event_triggers.c).
> + *
> + * @print: The callback function invoked to have the trigger print
> + *	itself.  This is usually implemented by a wrapper function
> + *	that calls the generic utility function @event_trigger_print()
> + *	(see trace_event_triggers.c).
> + */
> +struct event_trigger_ops {
> +	void			(*func)(struct event_trigger_data *data);
> +	int			(*init)(struct event_trigger_ops *ops,
> +					struct event_trigger_data *data);
> +	void			(*free)(struct event_trigger_ops *ops,
> +					struct event_trigger_data *data);
> +	int			(*print)(struct seq_file *m,
> +					 struct event_trigger_ops *ops,
> +					 struct event_trigger_data *data);
> +};
> +
> +/**
> + * struct event_command - callbacks and data members for event commands
> + *
> + * Event commands are invoked by users by writing the command name
> + * into the 'trigger' file associated with a trace event.  The
> + * parameters associated with a specific invocation of an event
> + * command are used to create an event trigger instance, which is
> + * added to the list of trigger instances associated with that trace
> + * event.  When the event is hit, the set of triggers associated with
> + * that event is invoked.
> + *
> + * The data members in this structure provide per-event command data
> + * for various event commands.
> + *
> + * All the data members below, except for @post_trigger, must be set
> + * for each event command.
> + *
> + * @name: The unique name that identifies the event command.  This is
> + *	the name used when setting triggers via trigger files.
> + *
> + * @trigger_type: A unique id that identifies the event command
> + *	'type'.  This value has two purposes, the first to ensure that
> + *	only one trigger of the same type can be set at a given time
> + *	for a particular event e.g. it doesn't make sense to have both
> + *	a traceon and traceoff trigger attached to a single event at
> + *	the same time, so traceon and traceoff have the same type
> + *	though they have different names.  The @trigger_type value is
> + *	also used as a bit value for deferring the actual trigger
> + *	action until after the current event is finished.  Some
> + *	commands need to do this if they themselves log to the trace
> + *	buffer (see the @post_trigger() member below).  @trigger_type
> + *	values are defined by adding new values to the trigger_type
> + *	enum in include/linux/ftrace_event.h.
> + *
> + * @post_trigger: A flag that says whether or not this command needs
> + *	to have its action delayed until after the current event has
> + *	been closed.  Some triggers need to avoid being invoked while
> + *	an event is currently in the process of being logged, since
> + *	the trigger may itself log data into the trace buffer.  Thus
> + *	we make sure the current event is committed before invoking
> + *	those triggers.  To do that, the trigger invocation is split
> + *	in two - the first part checks the filter using the current
> + *	trace record; if a command has the @post_trigger flag set, it
> + *	sets a bit for itself in the return value, otherwise it
> + *	directly invokes the trigger.  Once all commands have been
> + *	either invoked or set their return flag, the current record is
> + *	either committed or discarded.  At that point, if any commands
> + *	have deferred their triggers, those commands are finally
> + *	invoked following the close of the current event.  In other
> + *	words, if the event_trigger_ops @func() probe implementation
> + *	itself logs to the trace buffer, this flag should be set,
> + *	otherwise it can be left unspecified.
> + *
> + * All the methods below, except for @set_filter(), must be
> + * implemented.
> + *
> + * @func: The callback function responsible for parsing and
> + *	registering the trigger written to the 'trigger' file by the
> + *	user.  It allocates the trigger instance and registers it with
> + *	the appropriate trace event.  It makes use of the other
> + *	event_command callback functions to orchestrate this, and is
> + *	usually implemented by the generic utility function
> + *	@event_trigger_callback() (see trace_event_triggers.c).
> + *
> + * @reg: Adds the trigger to the list of triggers associated with the
> + *	event, and enables the event trigger itself, after
> + *	initializing it (via the event_trigger_ops @init() function).
> + *	This is also where commands can use the @trigger_type value to
> + *	make the decision as to whether or not multiple instances of
> + *	the trigger should be allowed.  This is usually implemented by
> + *	the generic utility function @register_trigger() (see
> + *	trace_event_triggers.c).
> + *
> + * @unreg: Removes the trigger from the list of triggers associated
> + *	with the event, and disables the event trigger itself, after
> + *	initializing it (via the event_trigger_ops @free() function).
> + *	This is usually implemented by the generic utility function
> + *	@unregister_trigger() (see trace_event_triggers.c).
> + *
> + * @set_filter: An optional function called to parse and set a filter
> + *	for the trigger.  If no @set_filter() method is set for the
> + *	event command, filters set by the user for the command will be
> + *	ignored.  This is usually implemented by the generic utility
> + *	function @set_trigger_filter() (see trace_event_triggers.c).
> + *
> + * @get_trigger_ops: The callback function invoked to retrieve the
> + *	event_trigger_ops implementation associated with the command.
> + */
> +struct event_command {
> +	struct list_head	list;
> +	char			*name;
> +	enum event_trigger_type	trigger_type;
> +	bool			post_trigger;
> +	int			(*func)(struct event_command *cmd_ops,
> +					struct ftrace_event_file *file,
> +					char *glob, char *cmd,
> +					char *params, int enable);
> +	int			(*reg)(char *glob,
> +				       struct event_trigger_ops *ops,
> +				       struct event_trigger_data *data,
> +				       struct ftrace_event_file *file);
> +	void			(*unreg)(char *glob,
> +					 struct event_trigger_ops *ops,
> +					 struct event_trigger_data *data,
> +					 struct ftrace_event_file *file);
> +	int			(*set_filter)(char *filter_str,
> +					      struct event_trigger_data *data,
> +					      struct ftrace_event_file *file);
> +	struct event_trigger_ops *(*get_trigger_ops)(char *cmd, char *param);
> +};
> +
> +extern int trace_event_enable_disable(struct ftrace_event_file *file,
> +				      int enable, int soft_disable);
> +
>  extern const char *__start___trace_bprintk_fmt[];
>  extern const char *__stop___trace_bprintk_fmt[];
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..7d8eb8a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -342,6 +342,12 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  	return ret;
>  }
>  
> +int trace_event_enable_disable(struct ftrace_event_file *file,
> +			       int enable, int soft_disable)
> +{
> +	return __ftrace_event_enable_disable(file, enable, soft_disable);
> +}
> +
>  static int ftrace_event_enable_disable(struct ftrace_event_file *file,
>  				       int enable)
>  {
> @@ -421,11 +427,6 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
>  	}
>  }
>  
> -static void *event_file_data(struct file *filp)
> -{
> -	return ACCESS_ONCE(file_inode(filp)->i_private);
> -}
> -
>  static void remove_event_file_dir(struct ftrace_event_file *file)
>  {
>  	struct dentry *dir = file->dir;
> @@ -1542,6 +1543,9 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
>  	trace_create_file("filter", 0644, file->dir, call,
>  			  &ftrace_event_filter_fops);
>  
> +	trace_create_file("trigger", 0644, file->dir, file,
> +			  &event_trigger_fops);
> +
>  	trace_create_file("format", 0444, file->dir, call,
>  			  &ftrace_event_format_fops);
>  
> @@ -1637,6 +1641,8 @@ trace_create_new_event(struct ftrace_event_call *call,
>  	file->event_call = call;
>  	file->tr = tr;
>  	atomic_set(&file->sm_ref, 0);
> +	atomic_set(&file->tm_ref, 0);
> +	INIT_LIST_HEAD(&file->triggers);
>  	list_add(&file->list, &tr->events);
>  
>  	return file;
> @@ -2303,6 +2309,9 @@ int event_trace_del_tracer(struct trace_array *tr)
>  {
>  	mutex_lock(&event_mutex);
>  
> +	/* Disable any event triggers and associated soft-disabled events */
> +	clear_event_triggers(tr);
> +
>  	/* Disable any running events */
>  	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
>  
> @@ -2366,6 +2375,8 @@ static __init int event_trace_enable(void)
>  
>  	register_event_cmds();
>  
> +	register_trigger_cmds();
> +
>  	return 0;
>  }
>  
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> new file mode 100644
> index 0000000..85319cf
> --- /dev/null
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -0,0 +1,268 @@
> +/*
> + * trace_events_trigger - trace event triggers
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) 2013 Tom Zanussi <tom.zanussi@linux.intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/ctype.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +#include "trace.h"
> +
> +static LIST_HEAD(trigger_commands);
> +static DEFINE_MUTEX(trigger_cmd_mutex);
> +
> +void event_triggers_call(struct ftrace_event_file *file)

Requires kernel-doc comment above.

/**
 * event_triggers_call - <one-line-description>
 * @file: <describe file parameter>
 *
 * <longer description>
 */

> +{
> +	struct event_trigger_data *data;
> +
> +	if (list_empty(&file->triggers))
> +		return;
> +
> +	preempt_disable_notrace();

What's the reason for preempt_disable()? This should be called with
rcu_read_lock held, right?

> +	list_for_each_entry_rcu(data, &file->triggers, list)
> +		data->ops->func(data);
> +	preempt_enable_notrace();
> +}
> +EXPORT_SYMBOL_GPL(event_triggers_call);
> +
> +static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
> +{
> +	struct ftrace_event_file *event_file = event_file_data(m->private);
> +
> +	return seq_list_next(t, &event_file->triggers, pos);
> +}
> +
> +static void *trigger_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct ftrace_event_file *event_file;
> +
> +	/* ->stop() is called even if ->start() fails */
> +	mutex_lock(&event_mutex);
> +	event_file = event_file_data(m->private);
> +	if (unlikely(!event_file))
> +		return ERR_PTR(-ENODEV);
> +
> +	return seq_list_start(&event_file->triggers, *pos);
> +}
> +
> +static void trigger_stop(struct seq_file *m, void *t)
> +{
> +	mutex_unlock(&event_mutex);
> +}
> +
> +static int trigger_show(struct seq_file *m, void *v)
> +{
> +	struct event_trigger_data *data;
> +
> +	data = list_entry(v, struct event_trigger_data, list);
> +	data->ops->print(m, data->ops, data);
> +
> +	return 0;
> +}
> +
> +static const struct seq_operations event_triggers_seq_ops = {
> +	.start = trigger_start,
> +	.next = trigger_next,
> +	.stop = trigger_stop,
> +	.show = trigger_show,
> +};
> +
> +static int event_trigger_regex_open(struct inode *inode, struct file *file)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&event_mutex);
> +
> +	if (unlikely(!event_file_data(file))) {
> +		mutex_unlock(&event_mutex);
> +		return -ENODEV;
> +	}
> +
> +	if (file->f_mode & FMODE_READ) {
> +		ret = seq_open(file, &event_triggers_seq_ops);
> +		if (!ret) {
> +			struct seq_file *m = file->private_data;
> +			m->private = file;
> +		}
> +	}
> +
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +static int trigger_process_regex(struct ftrace_event_file *file,
> +				 char *buff, int enable)
> +{
> +	char *command, *next = buff;
> +	struct event_command *p;
> +	int ret = -EINVAL;
> +
> +	command = strsep(&next, ": \t");
> +	command = (command[0] != '!') ? command : command + 1;
> +
> +	mutex_lock(&trigger_cmd_mutex);

What exactly is trigger_cmd_mutex protecting? It is only called here,
and the event_mutex() is already held by its only caller, so this mutex
is basically doing nothing.

> +	list_for_each_entry(p, &trigger_commands, list) {
> +		if (strcmp(p->name, command) == 0) {
> +			ret = p->func(p, file, buff, command, next, enable);
> +			goto out_unlock;
> +		}
> +	}
> + out_unlock:
> +	mutex_unlock(&trigger_cmd_mutex);
> +
> +	return ret;
> +}
> +
> +static ssize_t event_trigger_regex_write(struct file *file,
> +					 const char __user *ubuf,
> +					 size_t cnt, loff_t *ppos, int enable)
> +{
> +	struct ftrace_event_file *event_file;
> +	ssize_t ret;
> +	char *buf;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (cnt >= PAGE_SIZE)
> +		return -EINVAL;
> +
> +	buf = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(buf, ubuf, cnt)) {
> +		free_page((unsigned long)buf);
> +		return -EFAULT;
> +	}
> +	buf[cnt] = '\0';
> +	strim(buf);
> +
> +	mutex_lock(&event_mutex);
> +	event_file = event_file_data(file);
> +	if (unlikely(!event_file)) {
> +		mutex_unlock(&event_mutex);
> +		free_page((unsigned long)buf);
> +		return -ENODEV;
> +	}
> +	ret = trigger_process_regex(event_file, buf, enable);
> +	mutex_unlock(&event_mutex);
> +
> +	free_page((unsigned long)buf);
> +	if (ret < 0)
> +		goto out;
> +
> +	*ppos += cnt;
> +	ret = cnt;
> + out:
> +	return ret;
> +}
> +
> +static int event_trigger_regex_release(struct inode *inode, struct file *file)
> +{
> +	mutex_lock(&event_mutex);
> +
> +	if (file->f_mode & FMODE_READ)
> +		seq_release(inode, file);
> +
> +	mutex_unlock(&event_mutex);
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +event_trigger_write(struct file *filp, const char __user *ubuf,
> +		    size_t cnt, loff_t *ppos)
> +{
> +	return event_trigger_regex_write(filp, ubuf, cnt, ppos, 1);
> +}
> +
> +static int
> +event_trigger_open(struct inode *inode, struct file *filp)
> +{
> +	return event_trigger_regex_open(inode, filp);
> +}
> +
> +static int
> +event_trigger_release(struct inode *inode, struct file *file)
> +{
> +	return event_trigger_regex_release(inode, file);
> +}
> +
> +const struct file_operations event_trigger_fops = {
> +	.open = event_trigger_open,
> +	.read = seq_read,
> +	.write = event_trigger_write,
> +	.llseek = ftrace_filter_lseek,
> +	.release = event_trigger_release,
> +};
> +
> +static int trace_event_trigger_enable_disable(struct ftrace_event_file *file,
> +					      int trigger_enable)
> +{
> +	int ret = 0;
> +
> +	if (trigger_enable) {
> +		if (atomic_inc_return(&file->tm_ref) > 1)
> +			return ret;
> +		set_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
> +		ret = trace_event_enable_disable(file, 1, 1);
> +	} else {
> +		if (atomic_dec_return(&file->tm_ref) > 0)
> +			return ret;
> +		clear_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
> +		ret = trace_event_enable_disable(file, 0, 1);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * clear_event_triggers - clear all triggers associated with a trace array.

You forgot:

 * @tr: Trace array to work on

-- Steve

> + *
> + * For each trigger, the triggering event has its tm_ref decremented
> + * via trace_event_trigger_enable_disable(), and any associated event
> + * (in the case of enable/disable_event triggers) will have its sm_ref
> + * decremented via free()->trace_event_enable_disable().  That
> + * combination effectively reverses the soft-mode/trigger state added
> + * by trigger registration.
> + *
> + * Must be called with event_mutex held.
> + */
> +void
> +clear_event_triggers(struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
> +
> +	list_for_each_entry(file, &tr->events, list) {
> +		struct event_trigger_data *data;
> +		list_for_each_entry_rcu(data, &file->triggers, list) {
> +			trace_event_trigger_enable_disable(file, 0);
> +			if (data->ops->free)
> +				data->ops->free(data->ops, data);
> +		}
> +	}
> +}
> +
> +__init int register_trigger_cmds(void)
> +{
> +	return 0;
> +}
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index af4b71c..bb228e0 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -321,6 +321,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	if (!ftrace_file)
>  		return;
>  
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> +		event_triggers_call(ftrace_file);
>  	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  
> @@ -370,6 +372,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	if (!ftrace_file)
>  		return;
>  
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &ftrace_file->flags))
> +		event_triggers_call(ftrace_file);
>  	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  

