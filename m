Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaDAPCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:02:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62320 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751095AbaDAPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:02:44 -0400
Date: Tue, 1 Apr 2014 11:02:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v8 1/1] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140401110241.0fad6935@gandalf.local.home>
In-Reply-To: <1396044598-9358-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1396044598-9358-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1396044598-9358-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014 15:09:58 -0700
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frank Ch. Eigler <fche@redhat.com>
> CC: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/ftrace_event.h        |   20 +-
>  include/linux/tracepoint.h          |   41 +--
>  include/trace/ftrace.h              |    9 +-
>  kernel/trace/trace_events.c         |   51 ++--
>  kernel/trace/trace_events_trigger.c |    2 +-
>  kernel/trace/trace_export.c         |    2 +-
>  kernel/trace/trace_kprobe.c         |   29 +-
>  kernel/trace/trace_output.c         |    2 +-
>  kernel/trace/trace_uprobe.c         |   28 +-
>  kernel/tracepoint.c                 |  509 +++++++++++++++--------------------
>  10 files changed, 336 insertions(+), 357 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index cdc3011..766a14b 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -7,6 +7,7 @@
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
>  #include <linux/perf_event.h>
> +#include <linux/tracepoint.h>
>  
>  struct trace_array;
>  struct trace_buffer;
> @@ -232,6 +233,7 @@ enum {
>  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
>  	TRACE_EVENT_FL_WAS_ENABLED_BIT,
>  	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
> +	TRACE_EVENT_FL_TRACEPOINT_BIT,
>  };
>  
>  /*
> @@ -244,6 +246,7 @@ enum {
>   *                    (used for module unloading, if a module event is enabled,
>   *                     it is best to clear the buffers that used it).
>   *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
> + *  TRACEPOINT    - Event is a tracepoint
>   */
>  enum {
>  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
> @@ -252,12 +255,17 @@ enum {
>  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
>  	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
>  	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 << TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
> +	TRACE_EVENT_FL_TRACEPOINT	= (1 << TRACE_EVENT_FL_TRACEPOINT_BIT),
>  };
>  
>  struct ftrace_event_call {
>  	struct list_head	list;
>  	struct ftrace_event_class *class;
> -	char			*name;
> +	union {
> +		char			*name;
> +		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
> +		struct tracepoint	*tp;
> +	} u;

Get rid of the "u". Unnamed unions are supported and encouraged.

>  	struct trace_event	event;
>  	const char		*print_fmt;
>  	struct event_filter	*filter;
> @@ -271,6 +279,7 @@ struct ftrace_event_call {
>  	 *   bit 3:		ftrace internal event (do not enable)
>  	 *   bit 4:		Event was enabled by module
>  	 *   bit 5:		use call filter rather than file filter
> +	 *   bit 6:		Event is a tracepoint
>  	 */
>  	int			flags; /* static flags of different events */
>  
> @@ -283,6 +292,15 @@ struct ftrace_event_call {
>  #endif
>  };
>  
> +static inline const char *
> +ftrace_event_get_name(struct ftrace_event_call *call)
> +{
> +	if (call->flags & TRACE_EVENT_FL_TRACEPOINT)
> +		return call->u.tp->name;

call->tp->name;

> +	else
> +		return call->u.name;

call->name;

> +}
> +
>  struct trace_array;
>  struct ftrace_subsystem_dir;
>  
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 812b255..08150e2 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -6,7 +6,7 @@
>   *
>   * See Documentation/trace/tracepoints.txt.
>   *
> - * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + * Copyright (C) 2008-2014 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>   *
>   * Heavily inspired from the Linux Kernel Markers.
>   *
> @@ -21,6 +21,7 @@
>  
>  struct module;
>  struct tracepoint;
> +struct notifier_block;
>  
>  struct tracepoint_func {
>  	void *func;
> @@ -35,18 +36,13 @@ struct tracepoint {
>  	struct tracepoint_func __rcu *funcs;
>  };
>  
> -/*
> - * Connect a probe to a tracepoint.
> - * Internal API, should not be used directly.
> - */
> -extern int tracepoint_probe_register(const char *name, void *probe, void *data);
> -
> -/*
> - * Disconnect a probe from a tracepoint.
> - * Internal API, should not be used directly.
> - */
>  extern int
> -tracepoint_probe_unregister(const char *name, void *probe, void *data);
> +tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data);
> +extern int
> +tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
> +extern void
> +for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
> +		void *priv);
>  
>  #ifdef CONFIG_MODULES
>  struct tp_module {
> @@ -54,12 +50,25 @@ struct tp_module {
>  	unsigned int num_tracepoints;
>  	struct tracepoint * const *tracepoints_ptrs;
>  };
> +
>  bool trace_module_has_bad_taint(struct module *mod);
> +extern int register_tracepoint_module_notifier(struct notifier_block *nb);
> +extern int unregister_tracepoint_module_notifier(struct notifier_block *nb);
>  #else
>  static inline bool trace_module_has_bad_taint(struct module *mod)
>  {
>  	return false;
>  }
> +static inline
> +int register_tracepoint_module_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +static inline
> +int unregister_tracepoint_module_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_MODULES */
>  
>  /*
> @@ -160,14 +169,14 @@ static inline void tracepoint_synchronize_unregister(void)
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
> -		return tracepoint_probe_register(#name, (void *)probe,	\
> -						 data);			\
> +		return tracepoint_probe_register(&__tracepoint_##name,	\
> +						(void *)probe, data);	\
>  	}								\
>  	static inline int						\
>  	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
> -		return tracepoint_probe_unregister(#name, (void *)probe, \
> -						   data);		\
> +		return tracepoint_probe_unregister(&__tracepoint_##name,\
> +						(void *)probe, data);	\
>  	}								\
>  	static inline void						\
>  	check_trace_callback_type_##name(void (*cb)(data_proto))	\
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 8765126..ef86df1 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -470,10 +470,11 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   * };
>   *
>   * static struct ftrace_event_call event_<call> = {
> - *	.name			= "<call>",
> + *	.u.tp			= &__tracepoint_<call>,

.tp

>   *	.class			= event_class_<template>,
>   *	.event			= &ftrace_event_type_<call>,
>   *	.print_fmt		= print_fmt_<call>,
> + *	.flags			= TRACE_EVENT_FL_TRACEPOINT,
>   * };
>   * // its only safe to use pointers when doing linker tricks to
>   * // create an array.
> @@ -605,10 +606,11 @@ static struct ftrace_event_class __used __refdata event_class_##call = { \
>  #define DEFINE_EVENT(template, call, proto, args)			\
>  									\
>  static struct ftrace_event_call __used event_##call = {			\
> -	.name			= #call,				\
> +	.u.tp			= &__tracepoint_##call,			\
>  	.class			= &event_class_##template,		\
>  	.event.funcs		= &ftrace_event_type_funcs_##template,	\
>  	.print_fmt		= print_fmt_##template,			\
> +	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
>  };									\
>  static struct ftrace_event_call __used					\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> @@ -619,10 +621,11 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
>  static const char print_fmt_##call[] = print;				\
>  									\
>  static struct ftrace_event_call __used event_##call = {			\
> -	.name			= #call,				\
> +	.u.tp			= &__tracepoint_##call,			\

.tp

>  	.class			= &event_class_##template,		\
>  	.event.funcs		= &ftrace_event_type_funcs_##call,	\
>  	.print_fmt		= print_fmt_##call,			\
> +	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
>  };									\
>  static struct ftrace_event_call __used					\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 83a4378..5bdc34f 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -223,24 +223,25 @@ int ftrace_event_reg(struct ftrace_event_call *call,
>  {
>  	struct ftrace_event_file *file = data;
>  
> +	WARN_ON(!(call->flags & TRACE_EVENT_FL_TRACEPOINT));
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return tracepoint_probe_register(call->name,
> +		return tracepoint_probe_register(call->u.tp,
>  						 call->class->probe,
>  						 file);
>  	case TRACE_REG_UNREGISTER:
> -		tracepoint_probe_unregister(call->name,
> +		tracepoint_probe_unregister(call->u.tp,
>  					    call->class->probe,
>  					    file);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	case TRACE_REG_PERF_REGISTER:
> -		return tracepoint_probe_register(call->name,
> +		return tracepoint_probe_register(call->u.tp,
>  						 call->class->perf_probe,
>  						 call);
>  	case TRACE_REG_PERF_UNREGISTER:
> -		tracepoint_probe_unregister(call->name,
> +		tracepoint_probe_unregister(call->u.tp,

all above, call->tp

>  					    call->class->perf_probe,
>  					    call);
>  		return 0;
> @@ -352,7 +353,7 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  			if (ret) {
>  				tracing_stop_cmdline_record();
>  				pr_info("event trace: Could not enable event "
> -					"%s\n", call->name);
> +					"%s\n", ftrace_event_get_name(call));
>  				break;
>  			}
>  			set_bit(FTRACE_EVENT_FL_ENABLED_BIT, &file->flags);
> @@ -481,27 +482,29 @@ __ftrace_set_clr_event_nolock(struct trace_array *tr, const char *match,
>  {
>  	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
> +	const char *name;
>  	int ret = -EINVAL;
>  
>  	list_for_each_entry(file, &tr->events, list) {
>  
>  		call = file->event_call;
> +		name = ftrace_event_get_name(call);

If tp is null, then the above will crash. Move the above line to below.
the continues. If it's a tracepoint call->name will still be not null.

>  
> -		if (!call->name || !call->class || !call->class->reg)
> +		if (!name || !call->class || !call->class->reg)
>  			continue;
>  
>  		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
>  			continue;

Place the "name = ftrace_event_get_name(call);" here.

>  
>  		if (match &&
> -		    strcmp(match, call->name) != 0 &&
> +		    strcmp(match, name) != 0 &&
>  		    strcmp(match, call->class->system) != 0)
>  			continue;
>  
>  		if (sub && strcmp(sub, call->class->system) != 0)
>  			continue;
>  
> -		if (event && strcmp(event, call->name) != 0)
> +		if (event && strcmp(event, name) != 0)
>  			continue;
>  
>  		ftrace_event_enable_disable(file, set);
> @@ -699,7 +702,7 @@ static int t_show(struct seq_file *m, void *v)
>  
>  	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
>  		seq_printf(m, "%s:", call->class->system);
> -	seq_printf(m, "%s\n", call->name);
> +	seq_printf(m, "%s\n", ftrace_event_get_name(call));
>  
>  	return 0;
>  }
> @@ -792,7 +795,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(file, &tr->events, list) {
>  		call = file->event_call;
> -		if (!call->name || !call->class || !call->class->reg)
> +		if (!ftrace_event_get_name(call) || !call->class || !call->class->reg)

Again, we need to test if tp is null. Remove the above change.

>  			continue;
>  
>  		if (system && strcmp(call->class->system, system->name) != 0)
> @@ -907,7 +910,7 @@ static int f_show(struct seq_file *m, void *v)
>  
>  	switch ((unsigned long)v) {
>  	case FORMAT_HEADER:
> -		seq_printf(m, "name: %s\n", call->name);
> +		seq_printf(m, "name: %s\n", ftrace_event_get_name(call));
>  		seq_printf(m, "ID: %d\n", call->event.type);
>  		seq_printf(m, "format:\n");
>  		return 0;
> @@ -1527,6 +1530,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
>  	struct trace_array *tr = file->tr;
>  	struct list_head *head;
>  	struct dentry *d_events;
> +	const char *name;
>  	int ret;
>  
>  	/*
> @@ -1540,10 +1544,11 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
>  	} else
>  		d_events = parent;
>  
> -	file->dir = debugfs_create_dir(call->name, d_events);
> +	name = ftrace_event_get_name(call);
> +	file->dir = debugfs_create_dir(name, d_events);
>  	if (!file->dir) {
>  		pr_warning("Could not create debugfs '%s' directory\n",
> -			   call->name);
> +			   name);
>  		return -1;
>  	}
>  
> @@ -1567,7 +1572,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
>  		ret = call->class->define_fields(call);
>  		if (ret < 0) {
>  			pr_warning("Could not initialize trace point"
> -				   " events/%s\n", call->name);
> +				   " events/%s\n", name);
>  			return -1;
>  		}
>  	}
> @@ -1631,15 +1636,17 @@ static void event_remove(struct ftrace_event_call *call)
>  static int event_init(struct ftrace_event_call *call)
>  {
>  	int ret = 0;
> +	const char *name;
>  
> -	if (WARN_ON(!call->name))
> +	name = ftrace_event_get_name(call);
> +	if (WARN_ON(!name))

Again, remove the above change. We care if call->name or call->tp is
NULL.

You can add another check if it is a tp to make sure tp has a name as
well.

>  		return -EINVAL;
>  
>  	if (call->class->raw_init) {
>  		ret = call->class->raw_init(call);
>  		if (ret < 0 && ret != -ENOSYS)
>  			pr_warn("Could not initialize trace events/%s\n",
> -				call->name);
> +				name);
>  	}
>  
>  	return ret;
> @@ -1885,7 +1892,7 @@ __trace_add_event_dirs(struct trace_array *tr)
>  		ret = __trace_add_new_event(call, tr);
>  		if (ret < 0)
>  			pr_warning("Could not create directory for event %s\n",
> -				   call->name);
> +				   ftrace_event_get_name(call));
>  	}
>  }
>  
> @@ -1894,18 +1901,20 @@ find_event_file(struct trace_array *tr, const char *system,  const char *event)
>  {
>  	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
> +	const char *name;
>  
>  	list_for_each_entry(file, &tr->events, list) {
>  
>  		call = file->event_call;
> +		name = ftrace_event_get_name(call);
>  
> -		if (!call->name || !call->class || !call->class->reg)
> +		if (!name || !call->class || !call->class->reg)
>  			continue;

Same here. We should be still testing !call->name, and move the
assignment of the name down, before the strcmp.

>  
>  		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
>  			continue;
>  
> -		if (strcmp(event, call->name) == 0 &&
> +		if (strcmp(event, name) == 0 &&
>  		    strcmp(system, call->class->system) == 0)
>  			return file;
>  	}
> @@ -2193,7 +2202,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
>  		ret = event_create_dir(tr->event_dir, file);
>  		if (ret < 0)
>  			pr_warning("Could not create directory for event %s\n",
> -				   file->event_call->name);
> +				   ftrace_event_get_name(file->event_call));
>  	}
>  }
>  
> @@ -2217,7 +2226,7 @@ __trace_early_add_events(struct trace_array *tr)
>  		ret = __trace_early_add_new_event(call, tr);
>  		if (ret < 0)
>  			pr_warning("Could not create early event %s\n",
> -				   call->name);
> +				   ftrace_event_get_name(call));
>  	}
>  }
>  
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 8efbb69..66876df 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -1095,7 +1095,7 @@ event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
>  	seq_printf(m, "%s:%s:%s",
>  		   enable_data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
>  		   enable_data->file->event_call->class->system,
> -		   enable_data->file->event_call->name);
> +		   ftrace_event_get_name(enable_data->file->event_call));
>  
>  	if (data->count == -1)
>  		seq_puts(m, ":unlimited");
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index ee0a509..554d33e 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -173,7 +173,7 @@ struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
>  };									\
>  									\
>  struct ftrace_event_call __used event_##call = {			\
> -	.name			= #call,				\
> +	.u.name			= #call,				\

No need for the .u, remove this change.

>  	.event.type		= etype,				\
>  	.class			= &event_class_ftrace_##call,		\
>  	.print_fmt		= print,				\
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index d021d21..e9b805a 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -299,8 +299,8 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
>  	}
>  
>  	tk->tp.call.class = &tk->tp.class;
> -	tk->tp.call.name = kstrdup(event, GFP_KERNEL);
> -	if (!tk->tp.call.name)
> +	tk->tp.call.u.name = kstrdup(event, GFP_KERNEL);
> +	if (!tk->tp.call.u.name)

Same here.

>  		goto error;
>  
>  	if (!group || !is_good_name(group)) {
> @@ -316,7 +316,7 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
>  	INIT_LIST_HEAD(&tk->tp.files);
>  	return tk;
>  error:
> -	kfree(tk->tp.call.name);
> +	kfree(tk->tp.call.u.name);
>  	kfree(tk->symbol);
>  	kfree(tk);
>  	return ERR_PTR(ret);
> @@ -330,7 +330,7 @@ static void free_trace_kprobe(struct trace_kprobe *tk)
>  		traceprobe_free_probe_arg(&tk->tp.args[i]);
>  
>  	kfree(tk->tp.call.class->system);
> -	kfree(tk->tp.call.name);
> +	kfree(tk->tp.call.u.name);

and these.

>  	kfree(tk->symbol);
>  	kfree(tk);
>  }
> @@ -341,7 +341,7 @@ static struct trace_kprobe *find_trace_kprobe(const char *event,
>  	struct trace_kprobe *tk;
>  
>  	list_for_each_entry(tk, &probe_list, list)
> -		if (strcmp(tk->tp.call.name, event) == 0 &&
> +		if (strcmp(ftrace_event_get_name(&tk->tp.call), event) == 0 &&
>  		    strcmp(tk->tp.call.class->system, group) == 0)
>  			return tk;
>  	return NULL;
> @@ -516,7 +516,8 @@ static int register_trace_kprobe(struct trace_kprobe *tk)
>  	mutex_lock(&probe_lock);
>  
>  	/* Delete old (same name) event if exist */
> -	old_tk = find_trace_kprobe(tk->tp.call.name, tk->tp.call.class->system);
> +	old_tk = find_trace_kprobe(ftrace_event_get_name(&tk->tp.call),
> +			tk->tp.call.class->system);
>  	if (old_tk) {
>  		ret = unregister_trace_kprobe(old_tk);
>  		if (ret < 0)
> @@ -564,7 +565,8 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
>  			if (ret)
>  				pr_warning("Failed to re-register probe %s on"
>  					   "%s: %d\n",
> -					   tk->tp.call.name, mod->name, ret);
> +					   ftrace_event_get_name(&tk->tp.call),
> +					   mod->name, ret);
>  		}
>  	}
>  	mutex_unlock(&probe_lock);
> @@ -818,7 +820,8 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  	int i;
>  
>  	seq_printf(m, "%c", trace_kprobe_is_return(tk) ? 'r' : 'p');
> -	seq_printf(m, ":%s/%s", tk->tp.call.class->system, tk->tp.call.name);
> +	seq_printf(m, ":%s/%s", tk->tp.call.class->system,
> +			ftrace_event_get_name(&tk->tp.call));
>  
>  	if (!tk->symbol)
>  		seq_printf(m, " 0x%p", tk->rp.kp.addr);
> @@ -876,7 +879,8 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
>  {
>  	struct trace_kprobe *tk = v;
>  
> -	seq_printf(m, "  %-44s %15lu %15lu\n", tk->tp.call.name, tk->nhit,
> +	seq_printf(m, "  %-44s %15lu %15lu\n",
> +		   ftrace_event_get_name(&tk->tp.call), tk->nhit,
>  		   tk->rp.kp.nmissed);
>  
>  	return 0;
> @@ -1011,7 +1015,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
>  	field = (struct kprobe_trace_entry_head *)iter->ent;
>  	tp = container_of(event, struct trace_probe, call.event);
>  
> -	if (!trace_seq_printf(s, "%s: (", tp->call.name))
> +	if (!trace_seq_printf(s, "%s: (", ftrace_event_get_name(&tp->call)))
>  		goto partial;
>  
>  	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
> @@ -1047,7 +1051,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
>  	field = (struct kretprobe_trace_entry_head *)iter->ent;
>  	tp = container_of(event, struct trace_probe, call.event);
>  
> -	if (!trace_seq_printf(s, "%s: (", tp->call.name))
> +	if (!trace_seq_printf(s, "%s: (", ftrace_event_get_name(&tp->call)))
>  		goto partial;
>  
>  	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
> @@ -1286,7 +1290,8 @@ static int register_kprobe_event(struct trace_kprobe *tk)
>  	call->data = tk;
>  	ret = trace_add_event_call(call);
>  	if (ret) {
> -		pr_info("Failed to register kprobe event: %s\n", call->name);
> +		pr_info("Failed to register kprobe event: %s\n",
> +			ftrace_event_get_name(call));
>  		kfree(call->print_fmt);
>  		unregister_ftrace_event(&call->event);
>  	}
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index ca0e79e2..79c5569 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -431,7 +431,7 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
>  	}
>  
>  	trace_seq_init(p);
> -	ret = trace_seq_printf(s, "%s: ", event->name);
> +	ret = trace_seq_printf(s, "%s: ", ftrace_event_get_name(event));
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index e447336..9fd4071 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -251,8 +251,8 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  		return ERR_PTR(-ENOMEM);
>  
>  	tu->tp.call.class = &tu->tp.class;
> -	tu->tp.call.name = kstrdup(event, GFP_KERNEL);
> -	if (!tu->tp.call.name)
> +	tu->tp.call.u.name = kstrdup(event, GFP_KERNEL);

Remove the .u.

> +	if (!tu->tp.call.u.name)
>  		goto error;
>  
>  	tu->tp.class.system = kstrdup(group, GFP_KERNEL);
> @@ -269,7 +269,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  	return tu;
>  
>  error:
> -	kfree(tu->tp.call.name);
> +	kfree(tu->tp.call.u.name);
>  	kfree(tu);
>  
>  	return ERR_PTR(-ENOMEM);
> @@ -284,7 +284,7 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
>  
>  	iput(tu->inode);
>  	kfree(tu->tp.call.class->system);
> -	kfree(tu->tp.call.name);
> +	kfree(tu->tp.call.u.name);

Here too.

>  	kfree(tu->filename);
>  	kfree(tu);
>  }
> @@ -294,7 +294,7 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
>  	struct trace_uprobe *tu;
>  
>  	list_for_each_entry(tu, &uprobe_list, list)
> -		if (strcmp(tu->tp.call.name, event) == 0 &&
> +		if (strcmp(ftrace_event_get_name(&tu->tp.call), event) == 0 &&
>  		    strcmp(tu->tp.call.class->system, group) == 0)
>  			return tu;
>  
> @@ -324,7 +324,8 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
>  	mutex_lock(&uprobe_lock);
>  
>  	/* register as an event */
> -	old_tu = find_probe_event(tu->tp.call.name, tu->tp.call.class->system);
> +	old_tu = find_probe_event(ftrace_event_get_name(&tu->tp.call),
> +			tu->tp.call.class->system);
>  	if (old_tu) {
>  		/* delete old event */
>  		ret = unregister_trace_uprobe(old_tu);
> @@ -599,7 +600,8 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  	char c = is_ret_probe(tu) ? 'r' : 'p';
>  	int i;
>  
> -	seq_printf(m, "%c:%s/%s", c, tu->tp.call.class->system, tu->tp.call.name);
> +	seq_printf(m, "%c:%s/%s", c, tu->tp.call.class->system,
> +			ftrace_event_get_name(&tu->tp.call));
>  	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
>  
>  	for (i = 0; i < tu->tp.nr_args; i++)
> @@ -649,7 +651,8 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
>  {
>  	struct trace_uprobe *tu = v;
>  
> -	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->tp.call.name, tu->nhit);
> +	seq_printf(m, "  %s %-44s %15lu\n", tu->filename,
> +			ftrace_event_get_name(&tu->tp.call), tu->nhit);
>  	return 0;
>  }
>  
> @@ -844,12 +847,14 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
>  	tu = container_of(event, struct trace_uprobe, tp.call.event);
>  
>  	if (is_ret_probe(tu)) {
> -		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->tp.call.name,
> +		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
> +					ftrace_event_get_name(&tu->tp.call),
>  					entry->vaddr[1], entry->vaddr[0]))
>  			goto partial;
>  		data = DATAOF_TRACE_ENTRY(entry, true);
>  	} else {
> -		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->tp.call.name,
> +		if (!trace_seq_printf(s, "%s: (0x%lx)",
> +					ftrace_event_get_name(&tu->tp.call),
>  					entry->vaddr[0]))
>  			goto partial;
>  		data = DATAOF_TRACE_ENTRY(entry, false);
> @@ -1275,7 +1280,8 @@ static int register_uprobe_event(struct trace_uprobe *tu)
>  	ret = trace_add_event_call(call);
>  
>  	if (ret) {
> -		pr_info("Failed to register uprobe event: %s\n", call->name);
> +		pr_info("Failed to register uprobe event: %s\n",
> +			ftrace_event_get_name(call));
>  		kfree(call->print_fmt);
>  		unregister_ftrace_event(&call->event);
>  	}
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 50f8329..8c4f2f4 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c

I'll look at this file now. But might as well send a v9 of this patch,
with the updates. Adding the '.u' is fine for finding all the locations
you need to look at. But the final patch should strip it out, as it's
just a distraction.

-- Steve

