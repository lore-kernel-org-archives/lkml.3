Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaDAVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:46:53 -0400
Received: from mail.efficios.com ([78.47.125.74]:49390 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaDAVqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:46:51 -0400
Date: Tue, 1 Apr 2014 21:46:47 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <2030038143.3774.1396388807744.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140401110241.0fad6935@gandalf.local.home>
References: <1396044598-9358-1-git-send-email-mathieu.desnoyers@efficios.com> <1396044598-9358-2-git-send-email-mathieu.desnoyers@efficios.com> <20140401110241.0fad6935@gandalf.local.home>
Subject: Re: [PATCH v8 1/1] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: jRb9F15iH/0YxmiDSdjT3OPNaLG8XA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Frank Ch. Eigler" <fche@redhat.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Tuesday, April 1, 2014 11:02:41 AM
> Subject: Re: [PATCH v8 1/1] Tracepoint: register/unregister struct tracepoint
> 
> On Fri, 28 Mar 2014 15:09:58 -0700
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>  
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Ingo Molnar <mingo@kernel.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Frank Ch. Eigler <fche@redhat.com>
> > CC: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  include/linux/ftrace_event.h        |   20 +-
> >  include/linux/tracepoint.h          |   41 +--
> >  include/trace/ftrace.h              |    9 +-
> >  kernel/trace/trace_events.c         |   51 ++--
> >  kernel/trace/trace_events_trigger.c |    2 +-
> >  kernel/trace/trace_export.c         |    2 +-
> >  kernel/trace/trace_kprobe.c         |   29 +-
> >  kernel/trace/trace_output.c         |    2 +-
> >  kernel/trace/trace_uprobe.c         |   28 +-
> >  kernel/tracepoint.c                 |  509
> >  +++++++++++++++--------------------
> >  10 files changed, 336 insertions(+), 357 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index cdc3011..766a14b 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/hardirq.h>
> >  #include <linux/perf_event.h>
> > +#include <linux/tracepoint.h>
> >  
> >  struct trace_array;
> >  struct trace_buffer;
> > @@ -232,6 +233,7 @@ enum {
> >  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
> >  	TRACE_EVENT_FL_WAS_ENABLED_BIT,
> >  	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
> > +	TRACE_EVENT_FL_TRACEPOINT_BIT,
> >  };
> >  
> >  /*
> > @@ -244,6 +246,7 @@ enum {
> >   *                    (used for module unloading, if a module event is
> >   enabled,
> >   *                     it is best to clear the buffers that used it).
> >   *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
> > + *  TRACEPOINT    - Event is a tracepoint
> >   */
> >  enum {
> >  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
> > @@ -252,12 +255,17 @@ enum {
> >  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
> >  	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
> >  	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 <<
> >  	TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
> > +	TRACE_EVENT_FL_TRACEPOINT	= (1 << TRACE_EVENT_FL_TRACEPOINT_BIT),
> >  };
> >  
> >  struct ftrace_event_call {
> >  	struct list_head	list;
> >  	struct ftrace_event_class *class;
> > -	char			*name;
> > +	union {
> > +		char			*name;
> > +		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
> > +		struct tracepoint	*tp;
> > +	} u;
> 
> Get rid of the "u". Unnamed unions are supported and encouraged.

OK, will do.

[...]

> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 83a4378..5bdc34f 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c

[...]

> > @@ -481,27 +482,29 @@ __ftrace_set_clr_event_nolock(struct trace_array *tr,
> > const char *match,
> >  {
> >  	struct ftrace_event_file *file;
> >  	struct ftrace_event_call *call;
> > +	const char *name;
> >  	int ret = -EINVAL;
> >  
> >  	list_for_each_entry(file, &tr->events, list) {
> >  
> >  		call = file->event_call;
> > +		name = ftrace_event_get_name(call);
> 
> If tp is null, then the above will crash. Move the above line to below.
> the continues. If it's a tracepoint call->name will still be not null.

Hrm, but then we'd be changing the code structure a lot, since we're
testing "name" for NULL as a condition for the continue you refer to.

I recommend that we modify ftrace_event_get_name() instead, and check
for NULL call->tp in there (and return NULL in that case).

> 
> >  
> > -		if (!call->name || !call->class || !call->class->reg)
> > +		if (!name || !call->class || !call->class->reg)
> >  			continue;
> >  
> >  		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
> >  			continue;
> 
> Place the "name = ftrace_event_get_name(call);" here.
> 

Will change ftrace_event_get_name() to test for NULL call->tp
instead (see above).

> >  
> >  		if (match &&
> > -		    strcmp(match, call->name) != 0 &&
> > +		    strcmp(match, name) != 0 &&
> >  		    strcmp(match, call->class->system) != 0)
> >  			continue;
> >  
> >  		if (sub && strcmp(sub, call->class->system) != 0)
> >  			continue;
> >  
> > -		if (event && strcmp(event, call->name) != 0)
> > +		if (event && strcmp(event, name) != 0)
> >  			continue;
> >  
> >  		ftrace_event_enable_disable(file, set);
> > @@ -699,7 +702,7 @@ static int t_show(struct seq_file *m, void *v)
> >  
> >  	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
> >  		seq_printf(m, "%s:", call->class->system);
> > -	seq_printf(m, "%s\n", call->name);
> > +	seq_printf(m, "%s\n", ftrace_event_get_name(call));
> >  
> >  	return 0;
> >  }
> > @@ -792,7 +795,7 @@ system_enable_read(struct file *filp, char __user
> > *ubuf, size_t cnt,
> >  	mutex_lock(&event_mutex);
> >  	list_for_each_entry(file, &tr->events, list) {
> >  		call = file->event_call;
> > -		if (!call->name || !call->class || !call->class->reg)
> > +		if (!ftrace_event_get_name(call) || !call->class || !call->class->reg)
> 
> Again, we need to test if tp is null. Remove the above change.

Ditto.

> 
> >  			continue;
> >  
> >  		if (system && strcmp(call->class->system, system->name) != 0)
> > @@ -907,7 +910,7 @@ static int f_show(struct seq_file *m, void *v)
> >  
> >  	switch ((unsigned long)v) {
> >  	case FORMAT_HEADER:
> > -		seq_printf(m, "name: %s\n", call->name);
> > +		seq_printf(m, "name: %s\n", ftrace_event_get_name(call));
> >  		seq_printf(m, "ID: %d\n", call->event.type);
> >  		seq_printf(m, "format:\n");
> >  		return 0;
> > @@ -1527,6 +1530,7 @@ event_create_dir(struct dentry *parent, struct
> > ftrace_event_file *file)
> >  	struct trace_array *tr = file->tr;
> >  	struct list_head *head;
> >  	struct dentry *d_events;
> > +	const char *name;
> >  	int ret;
> >  
> >  	/*
> > @@ -1540,10 +1544,11 @@ event_create_dir(struct dentry *parent, struct
> > ftrace_event_file *file)
> >  	} else
> >  		d_events = parent;
> >  
> > -	file->dir = debugfs_create_dir(call->name, d_events);
> > +	name = ftrace_event_get_name(call);
> > +	file->dir = debugfs_create_dir(name, d_events);
> >  	if (!file->dir) {
> >  		pr_warning("Could not create debugfs '%s' directory\n",
> > -			   call->name);
> > +			   name);
> >  		return -1;
> >  	}
> >  
> > @@ -1567,7 +1572,7 @@ event_create_dir(struct dentry *parent, struct
> > ftrace_event_file *file)
> >  		ret = call->class->define_fields(call);
> >  		if (ret < 0) {
> >  			pr_warning("Could not initialize trace point"
> > -				   " events/%s\n", call->name);
> > +				   " events/%s\n", name);
> >  			return -1;
> >  		}
> >  	}
> > @@ -1631,15 +1636,17 @@ static void event_remove(struct ftrace_event_call
> > *call)
> >  static int event_init(struct ftrace_event_call *call)
> >  {
> >  	int ret = 0;
> > +	const char *name;
> >  
> > -	if (WARN_ON(!call->name))
> > +	name = ftrace_event_get_name(call);
> > +	if (WARN_ON(!name))
> 
> Again, remove the above change. We care if call->name or call->tp is
> NULL.

Ditto.

> 
> You can add another check if it is a tp to make sure tp has a name as
> well.
> 
> >  		return -EINVAL;
> >  
> >  	if (call->class->raw_init) {
> >  		ret = call->class->raw_init(call);
> >  		if (ret < 0 && ret != -ENOSYS)
> >  			pr_warn("Could not initialize trace events/%s\n",
> > -				call->name);
> > +				name);
> >  	}
> >  
> >  	return ret;
> > @@ -1885,7 +1892,7 @@ __trace_add_event_dirs(struct trace_array *tr)
> >  		ret = __trace_add_new_event(call, tr);
> >  		if (ret < 0)
> >  			pr_warning("Could not create directory for event %s\n",
> > -				   call->name);
> > +				   ftrace_event_get_name(call));
> >  	}
> >  }
> >  
> > @@ -1894,18 +1901,20 @@ find_event_file(struct trace_array *tr, const char
> > *system,  const char *event)
> >  {
> >  	struct ftrace_event_file *file;
> >  	struct ftrace_event_call *call;
> > +	const char *name;
> >  
> >  	list_for_each_entry(file, &tr->events, list) {
> >  
> >  		call = file->event_call;
> > +		name = ftrace_event_get_name(call);
> >  
> > -		if (!call->name || !call->class || !call->class->reg)
> > +		if (!name || !call->class || !call->class->reg)
> >  			continue;
> 
> Same here. We should be still testing !call->name, and move the
> assignment of the name down, before the strcmp.

Ditto.

> 
> >  
> >  		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
> >  			continue;
> >  
> > -		if (strcmp(event, call->name) == 0 &&
> > +		if (strcmp(event, name) == 0 &&
> >  		    strcmp(system, call->class->system) == 0)
> >  			return file;
> >  	}
> > @@ -2193,7 +2202,7 @@ __trace_early_add_event_dirs(struct trace_array *tr)
> >  		ret = event_create_dir(tr->event_dir, file);
> >  		if (ret < 0)
> >  			pr_warning("Could not create directory for event %s\n",
> > -				   file->event_call->name);
> > +				   ftrace_event_get_name(file->event_call));
> >  	}
> >  }
> >  
> > @@ -2217,7 +2226,7 @@ __trace_early_add_events(struct trace_array *tr)
> >  		ret = __trace_early_add_new_event(call, tr);
> >  		if (ret < 0)
> >  			pr_warning("Could not create early event %s\n",
> > -				   call->name);
> > +				   ftrace_event_get_name(call));
> >  	}
> >  }
> >  
> > diff --git a/kernel/trace/trace_events_trigger.c
> > b/kernel/trace/trace_events_trigger.c
> > index 8efbb69..66876df 100644
> > --- a/kernel/trace/trace_events_trigger.c
> > +++ b/kernel/trace/trace_events_trigger.c
> > @@ -1095,7 +1095,7 @@ event_enable_trigger_print(struct seq_file *m, struct
> > event_trigger_ops *ops,
> >  	seq_printf(m, "%s:%s:%s",
> >  		   enable_data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
> >  		   enable_data->file->event_call->class->system,
> > -		   enable_data->file->event_call->name);
> > +		   ftrace_event_get_name(enable_data->file->event_call));
> >  
> >  	if (data->count == -1)
> >  		seq_puts(m, ":unlimited");

[...]

> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 50f8329..8c4f2f4 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> 
> I'll look at this file now. But might as well send a v9 of this patch,
> with the updates. Adding the '.u' is fine for finding all the locations
> you need to look at. But the final patch should strip it out, as it's
> just a distraction.

Allright. I'm preparing v9 now.

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
