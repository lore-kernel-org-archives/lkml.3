Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3FNQ0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:26:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3FNQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:26:50 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=29L_mT-OSEMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=J2HtaBBKEIUA:10 a=k56BXPXkxWB8x8zMZJQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371227208.9844.333.camel@gandalf.local.home>
Subject: Re: ftrace multibuffer && rcu (Was: tracing/uprobes: Support
 ftrace_event_file base multibuffer)
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Jun 2013 12:26:48 -0400
In-Reply-To: <20130614160456.GA14726@redhat.com>
References: <51BA7578.4080108@huawei.com> <20130614144442.GA1943@redhat.com>
	 <20130614160456.GA14726@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 18:04 +0200, Oleg Nesterov wrote:
> On 06/14, Oleg Nesterov wrote:
> >
> > > -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> > > +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> > > +		   filter_func_t filter)
> > >  {
> > > +	int enabled = 0;
> > >  	int ret = 0;
> > >
> > > +	mutex_lock(&uprobe_enable_lock);
> >
> > Do we really need this? Can't we really on mutex_event hold by the caller?
> 
> Looks like, kprobes do not need probe_enable_lock too.
> 
> Steven, Masami, I just looked at this new multibuffer code. Not sure
> I really understand it, but it seems that ftrace_event_file should
> help its users.
> 
> Lets look at enable_trace_probe(). Firstly, "ftrace_event_file **files"
> and the add/remove code doesn't look very nice, list_head looks more
> convenient.
> 
> But the main problem is, synchronize_sched() is slow and it is called
> under the global event_mutex.

But is that really an issue? event_mutex is used to add or remove
events, and this happens only when we load or unload a module, or add or
remove a probe. These are mostly user operations that take a relatively
long time to complete (but not relative to humans).


> 
> So perhaps something like below (untested) makes sense? With this patch
> we can trivially convert trace_kprobe.c to use list_add/del/each_rcu.
> 
> What do you think?
> 
> Oleg.
> 
> 
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -294,8 +294,32 @@ struct ftrace_event_file {
>  	 */
>  	unsigned long		flags;
>  	atomic_t		sm_ref;	/* soft-mode reference counter */
> +	atomic_t		refcnt;
> +	struct rcu_head		rcu;

I'd like to keep this struct as small as possible, as it is created for
every event we have. And there's already over 900 events and it is
constantly growing.

Of course one can argue that it's still a relatively small number.

>  };
>  
> +struct event_file_link {
> +	struct ftrace_event_file	*file;
> +	struct list_head		list;
> +	struct rcu_head			rcu;
> +};
> +
> +extern void rcu_free_event_file_link(struct rcu_head *rcu);
> +
> +static inline struct event_file_link *
> +alloc_event_file_link(struct ftrace_event_file *file)
> +{
> +	struct event_file_link *link = kmalloc(sizeof(*link), GFP_KERNEL);
> +	if (link)
> +		link->file = file;
> +	return link;
> +}

I don't see where this is used.

> +
> +static inline void free_event_file_link(struct event_file_link *link)
> +{
> +	call_rcu(&link->rcu, rcu_free_event_file_link);
> +}
> +
>  #define __TRACE_EVENT_FLAGS(name, value)				\
>  	static int __init trace_init_flags_##name(void)			\
>  	{								\
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1542,6 +1542,7 @@ trace_create_new_event(struct ftrace_event_call *call,
>  	file->event_call = call;
>  	file->tr = tr;
>  	atomic_set(&file->sm_ref, 0);
> +	atomic_set(&file->refcnt, 1);
>  	list_add(&file->list, &tr->events);
>  
>  	return file;
> @@ -2182,6 +2183,17 @@ __trace_early_add_events(struct trace_array *tr)
>  	}
>  }
>  
> +static void put_event_file(struct ftrace_event_file *file)
> +{
> +	if (atomic_dec_and_test(&file->refcnt))
> +		kmem_cache_free(file_cachep, file);
> +}
> +
> +static void delayed_put_event_file(struct rcu_head *rcu)
> +{
> +	put_event_file(container_of(rcu, struct ftrace_event_file, rcu));
> +}
> +
>  /* Remove the event directory structure for a trace directory. */
>  static void
>  __trace_remove_event_dirs(struct trace_array *tr)
> @@ -2192,10 +2204,18 @@ __trace_remove_event_dirs(struct trace_array *tr)
>  		list_del(&file->list);
>  		debugfs_remove_recursive(file->dir);
>  		remove_subsystem(file->system);
> -		kmem_cache_free(file_cachep, file);
> +		call_rcu(&file->rcu, delayed_put_event_file);

This would have to be used by module unloading as well.

Again, is it really a big deal if we do synchronize_sched() under the
event_mutex. It's not a critical lock.

-- Steve

>  	}
>  }
>  
> +void rcu_free_event_file_link(struct rcu_head *rcu)
> +{
> +	struct event_file_link *link =
> +			container_of(rcu, struct event_file_link, rcu);
> +	put_event_file(link->file);
> +	kfree(link);
> +}
> +
>  static void
>  __add_event_to_tracers(struct ftrace_event_call *call,
>  		       struct ftrace_module_file_ops *file_ops)


