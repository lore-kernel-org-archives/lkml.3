Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaCUUCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:02:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11112 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbaCUUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:02:21 -0400
Date: Fri, 21 Mar 2014 16:02:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v7 2/2] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140321160219.10b1db66@gandalf.local.home>
In-Reply-To: <1395379142-2118-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395379142-2118-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1395379142-2118-3-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 01:19:02 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4e4cc28..1592c1c 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -230,6 +230,7 @@ struct ftrace_event_call {
>  	struct list_head	list;
>  	struct ftrace_event_class *class;
>  	char			*name;
> +	struct tracepoint	*tp;

Already mentioned this should be one or the other.

>  	struct trace_event	event;
>  	const char		*print_fmt;
>  	struct event_filter	*filter;



> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 1a8b28d..415b986 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -625,6 +625,7 @@ static struct ftrace_event_class __used __refdata event_class_##call = { \
>  									\
>  static struct ftrace_event_call __used event_##call = {			\
>  	.name			= #call,				\
> +	.tp			= &__tracepoint_##call,			\
>  	.class			= &event_class_##template,		\
>  	.event.funcs		= &ftrace_event_type_funcs_##template,	\
>  	.print_fmt		= print_fmt_##template,			\
> @@ -639,6 +640,7 @@ static const char print_fmt_##call[] = print;				\
>  									\
>  static struct ftrace_event_call __used event_##call = {			\
>  	.name			= #call,				\
> +	.tp			= &__tracepoint_##call,			\
>  	.class			= &event_class_##template,		\

Same here.


>  	.event.funcs		= &ftrace_event_type_funcs_##call,	\
>  	.print_fmt		= print_fmt_##call,			\



> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index f27e5f0..85dc2f2 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (C) 2008 Mathieu Desnoyers
> + * Copyright (C) 2008-2014 Mathieu Desnoyers
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -33,38 +33,27 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
>  /* Set to 1 to enable tracepoint debug output */
>  static const int tracepoint_debug;
>  
> +#ifdef CONFIG_MODULES
>  /*
> - * Tracepoints mutex protects the builtin and module tracepoints and the hash
> - * table, as well as the local module list.
> + * Tracepoint module list mutex protects the local module list.
>   */
> -static DEFINE_MUTEX(tracepoints_mutex);
> +static DEFINE_MUTEX(tp_modlist_mutex);
>  
> -#ifdef CONFIG_MODULES
> -/* Local list of struct module */
> -static LIST_HEAD(tracepoint_module_list);
> +/* Local list of struct tp_module */
> +static LIST_HEAD(tp_modlist);
>  #endif /* CONFIG_MODULES */
>  
>  /*
> - * Tracepoint hash table, containing the active tracepoints.
> - * Protected by tracepoints_mutex.
> + * tracepoint_mutex protects the builtin and module tracepoints.
> + * tracepoint_mutex nests inside tp_modlist_mutex.
>   */
> -#define TRACEPOINT_HASH_BITS 6
> -#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
> -static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
> +static DEFINE_MUTEX(tracepoint_mutex);
>  
>  /*
>   * Note about RCU :
>   * It is used to delay the free of multiple probes array until a quiescent
>   * state is reached.
> - * Tracepoint entries modifications are protected by the tracepoints_mutex.
>   */
> -struct tracepoint_entry {
> -	struct hlist_node hlist;
> -	struct tracepoint_func *funcs;
> -	int refcount;	/* Number of times armed. 0 if disarmed. */
> -	char name[0];
> -};
> -
>  struct tp_probes {
>  	struct rcu_head rcu;
>  	struct tracepoint_func probes[0];
> @@ -91,34 +80,35 @@ static inline void release_probes(struct tracepoint_func *old)
>  	}
>  }
>  
> -static void debug_print_probes(struct tracepoint_entry *entry)
> +static
> +void debug_print_probes(struct tracepoint_func *funcs)

Why is the above on two lines?

>  {
>  	int i;
>  
> -	if (!tracepoint_debug || !entry->funcs)
> +	if (!tracepoint_debug || !funcs)
>  		return;
>  
> -	for (i = 0; entry->funcs[i].func; i++)
> -		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i].func);
> +	for (i = 0; funcs[i].func; i++)
> +		printk(KERN_DEBUG "Probe %d : %p\n", i, funcs[i].func);
>  }
>  
> -static struct tracepoint_func *
> -tracepoint_entry_add_probe(struct tracepoint_entry *entry,
> -			   void *probe, void *data)
> +static
> +struct tracepoint_func *func_add(struct tracepoint_func **funcs,

Again, static should never be on a separate line. If the function name
is too big, you move the name down:

static struct tracepoint_func *
func_add(...)

> +		struct tracepoint_func *tp_func)
>  {
>  	int nr_probes = 0;
>  	struct tracepoint_func *old, *new;
>  
> -	if (WARN_ON(!probe))
> +	if (WARN_ON(!tp_func->func))
>  		return ERR_PTR(-EINVAL);
>  
> -	debug_print_probes(entry);
> -	old = entry->funcs;
> +	debug_print_probes(*funcs);
> +	old = *funcs;
>  	if (old) {
>  		/* (N -> N+1), (N != 0, 1) probes */
>  		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
> -			if (old[nr_probes].func == probe &&
> -			    old[nr_probes].data == data)
> +			if (old[nr_probes].func == tp_func->func &&
> +			    old[nr_probes].data == tp_func->data)
>  				return ERR_PTR(-EEXIST);
>  	}
>  	/* + 2 : one for new probe, one for NULL func */
> @@ -127,33 +117,31 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
>  		return ERR_PTR(-ENOMEM);
>  	if (old)
>  		memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
> -	new[nr_probes].func = probe;
> -	new[nr_probes].data = data;
> +	new[nr_probes] = *tp_func;
>  	new[nr_probes + 1].func = NULL;
> -	entry->refcount = nr_probes + 1;
> -	entry->funcs = new;
> -	debug_print_probes(entry);
> +	*funcs = new;
> +	debug_print_probes(*funcs);
>  	return old;
>  }
>  
> -static void *
> -tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
> -			      void *probe, void *data)
> +static
> +void *func_remove(struct tracepoint_func **funcs,

Again, fix this.

> +		struct tracepoint_func *tp_func)
>  {
>  	int nr_probes = 0, nr_del = 0, i;
>  	struct tracepoint_func *old, *new;
>  
> -	old = entry->funcs;
> +	old = *funcs;
>  
>  	if (!old)
>  		return ERR_PTR(-ENOENT);
>  
> -	debug_print_probes(entry);
> +	debug_print_probes(*funcs);
>  	/* (N -> M), (N > 1, M >= 0) probes */
> -	if (probe) {
> +	if (tp_func->func) {
>  		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -			if (old[nr_probes].func == probe &&
> -			     old[nr_probes].data == data)
> +			if (old[nr_probes].func == tp_func->func &&
> +			     old[nr_probes].data == tp_func->data)
>  				nr_del++;
>  		}
>  	}
> @@ -164,9 +152,8 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  	 */
>  	if (nr_probes - nr_del == 0) {
>  		/* N -> 0, (N > 1) */
> -		entry->funcs = NULL;
> -		entry->refcount = 0;
> -		debug_print_probes(entry);
> +		*funcs = NULL;
> +		debug_print_probes(*funcs);
>  		return old;
>  	} else {
>  		int j = 0;
> @@ -176,90 +163,35 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  		if (new == NULL)
>  			return ERR_PTR(-ENOMEM);
>  		for (i = 0; old[i].func; i++)
> -			if (old[i].func != probe || old[i].data != data)
> +			if (old[i].func != tp_func->func
> +					|| old[i].data != tp_func->data)
>  				new[j++] = old[i];
>  		new[nr_probes - nr_del].func = NULL;
> -		entry->refcount = nr_probes - nr_del;
> -		entry->funcs = new;
> +		*funcs = new;
>  	}
> -	debug_print_probes(entry);
> +	debug_print_probes(*funcs);
>  	return old;
>  }
>  
>  /*
> - * Get tracepoint if the tracepoint is present in the tracepoint hash table.
> - * Must be called with tracepoints_mutex held.
> - * Returns NULL if not present.
> - */
> -static struct tracepoint_entry *get_tracepoint(const char *name)
> -{
> -	struct hlist_head *head;
> -	struct tracepoint_entry *e;
> -	u32 hash = jhash(name, strlen(name), 0);
> -
> -	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
> -	hlist_for_each_entry(e, head, hlist) {
> -		if (!strcmp(name, e->name))
> -			return e;
> -	}
> -	return NULL;
> -}
> -
> -/*
> - * Add the tracepoint to the tracepoint hash table. Must be called with
> - * tracepoints_mutex held.
> - */
> -static struct tracepoint_entry *add_tracepoint(const char *name)
> -{
> -	struct hlist_head *head;
> -	struct tracepoint_entry *e;
> -	size_t name_len = strlen(name) + 1;
> -	u32 hash = jhash(name, name_len-1, 0);
> -
> -	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
> -	hlist_for_each_entry(e, head, hlist) {
> -		if (!strcmp(name, e->name)) {
> -			printk(KERN_NOTICE
> -				"tracepoint %s busy\n", name);
> -			return ERR_PTR(-EEXIST);	/* Already there */
> -		}
> -	}
> -	/*
> -	 * Using kmalloc here to allocate a variable length element. Could
> -	 * cause some memory fragmentation if overused.
> -	 */
> -	e = kmalloc(sizeof(struct tracepoint_entry) + name_len, GFP_KERNEL);
> -	if (!e)
> -		return ERR_PTR(-ENOMEM);
> -	memcpy(&e->name[0], name, name_len);
> -	e->funcs = NULL;
> -	e->refcount = 0;
> -	hlist_add_head(&e->hlist, head);
> -	return e;
> -}
> -
> -/*
> - * Remove the tracepoint from the tracepoint hash table. Must be called with
> - * mutex_lock held.
> + * Add the probe function to a tracepoint.
>   */
> -static inline void remove_tracepoint(struct tracepoint_entry *e)
> +static
> +int tracepoint_add_func(struct tracepoint *tp,

Again fix.

> +		struct tracepoint_func *func)
>  {
> -	hlist_del(&e->hlist);
> -	kfree(e);
> -}
> +	struct tracepoint_func *old, *tp_funcs;
>  
> -/*
> - * Sets the probe callback corresponding to one tracepoint.
> - */
> -static void set_tracepoint(struct tracepoint_entry **entry,
> -	struct tracepoint *elem, int active)
> -{
> -	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
> +	if (tp->regfunc && !static_key_enabled(&tp->key))
> +		tp->regfunc();
>  
> -	if (elem->regfunc && !static_key_enabled(&elem->key) && active)
> -		elem->regfunc();
> -	else if (elem->unregfunc && static_key_enabled(&elem->key) && !active)
> -		elem->unregfunc();
> +	tp_funcs = tp->funcs;
> +	old = func_add(&tp_funcs, func);
> +	if (IS_ERR(old)) {
> +		WARN_ON_ONCE(1);
> +		return PTR_ERR(old);
> +	}
> +	release_probes(old);
>  
>  	/*
>  	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
> @@ -268,192 +200,180 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>  	 * include/linux/tracepoints.h. A matching smp_read_barrier_depends()
>  	 * is used.
>  	 */
> -	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
> -	if (active && !static_key_enabled(&elem->key))
> -		static_key_slow_inc(&elem->key);
> -	else if (!active && static_key_enabled(&elem->key))
> -		static_key_slow_dec(&elem->key);
> +	rcu_assign_pointer(tp->funcs, tp_funcs);
> +	if (!static_key_enabled(&tp->key))
> +		static_key_slow_inc(&tp->key);
> +	return 0;
>  }
>  
>  /*
> - * Disable a tracepoint and its probe callback.
> + * Remove a probe function from a tracepoint.
>   * Note: only waiting an RCU period after setting elem->call to the empty
>   * function insures that the original callback is not used anymore. This insured
>   * by preempt_disable around the call site.
>   */
> -static void disable_tracepoint(struct tracepoint *elem)
> +static
> +int tracepoint_remove_func(struct tracepoint *tp,

Again fix.

> +		struct tracepoint_func *func)
>  {
> -	if (elem->unregfunc && static_key_enabled(&elem->key))
> -		elem->unregfunc();
> -
> -	if (static_key_enabled(&elem->key))
> -		static_key_slow_dec(&elem->key);
> -	rcu_assign_pointer(elem->funcs, NULL);
> -}
> +	struct tracepoint_func *old, *tp_funcs;
>  
> -/**
> - * tracepoint_update_probe_range - Update a probe range
> - * @begin: beginning of the range
> - * @end: end of the range
> - *
> - * Updates the probe callback corresponding to a range of tracepoints.
> - * Called with tracepoints_mutex held.
> - */
> -static void tracepoint_update_probe_range(struct tracepoint * const *begin,
> -					  struct tracepoint * const *end)
> -{
> -	struct tracepoint * const *iter;
> -	struct tracepoint_entry *mark_entry;
> +	tp_funcs = tp->funcs;
> +	old = func_remove(&tp_funcs, func);
> +	if (IS_ERR(old)) {
> +		WARN_ON_ONCE(1);
> +		return PTR_ERR(old);
> +	}
> +	release_probes(old);
>  
> -	if (!begin)
> -		return;
> +	if (!tp_funcs) {
> +		/* Removed last function */
> +		if (tp->unregfunc && static_key_enabled(&tp->key))
> +			tp->unregfunc();
>  
> -	for (iter = begin; iter < end; iter++) {
> -		mark_entry = get_tracepoint((*iter)->name);
> -		if (mark_entry) {
> -			set_tracepoint(&mark_entry, *iter,
> -					!!mark_entry->refcount);
> -		} else {
> -			disable_tracepoint(*iter);
> -		}
> +		if (static_key_enabled(&tp->key))
> +			static_key_slow_dec(&tp->key);
>  	}
> +	rcu_assign_pointer(tp->funcs, tp_funcs);
> +	return 0;
>  }
>  
> -#ifdef CONFIG_MODULES
> -void module_update_tracepoints(void)
> -{
> -	struct tp_module *tp_mod;
> -
> -	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
> -		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
> -			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
> -}
> -#else /* CONFIG_MODULES */
> -void module_update_tracepoints(void)
> +/**
> + * tracepoint_probe_register -  Connect a probe to a tracepoint
> + * @tp: tracepoint
> + * @probe: probe handler
> + *
> + * Returns 0 if ok, error value on error.
> + * Note: if @tp is within a module, the caller is responsible for
> + * unregistering the probe before the module is gone. This can be
> + * performed either with a tracepoint module going notifier, or from
> + * within module exit functions.
> + */
> +int tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data)
>  {
> +	struct tracepoint_func tp_func;
> +	int ret;
> +
> +	mutex_lock(&tracepoint_mutex);
> +	tp_func.func = probe;
> +	tp_func.data = data;
> +	ret = tracepoint_add_func(tp, &tp_func);
> +	mutex_unlock(&tracepoint_mutex);
> +	return ret;
>  }
> -#endif /* CONFIG_MODULES */
> -
> +EXPORT_SYMBOL_GPL(tracepoint_probe_register);
>  
> -/*
> - * Update probes, removing the faulty probes.
> - * Called with tracepoints_mutex held.
> +/**
> + * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
> + * @tp: tracepoint
> + * @probe: probe function pointer
> + *
> + * Returns 0 if ok, error value on error.
>   */
> -static void tracepoint_update_probes(void)
> +int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
>  {
> -	/* Core kernel tracepoints */
> -	tracepoint_update_probe_range(__start___tracepoints_ptrs,
> -		__stop___tracepoints_ptrs);
> -	/* tracepoints in modules. */
> -	module_update_tracepoints();
> +	struct tracepoint_func tp_func;
> +	int ret;
> +
> +	mutex_lock(&tracepoint_mutex);
> +	tp_func.func = probe;
> +	tp_func.data = data;
> +	ret = tracepoint_remove_func(tp, &tp_func);
> +	mutex_unlock(&tracepoint_mutex);
> +	return ret;
>  }
> +EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
>  
> -static struct tracepoint_func *
> -tracepoint_add_probe(const char *name, void *probe, void *data)
> +#ifdef CONFIG_MODULES
> +bool trace_module_has_bad_taint(struct module *mod)
>  {
> -	struct tracepoint_entry *entry;
> -	struct tracepoint_func *old;
> -
> -	entry = get_tracepoint(name);
> -	if (!entry) {
> -		entry = add_tracepoint(name);
> -		if (IS_ERR(entry))
> -			return (struct tracepoint_func *)entry;
> -	}
> -	old = tracepoint_entry_add_probe(entry, probe, data);
> -	if (IS_ERR(old) && !entry->refcount)
> -		remove_tracepoint(entry);
> -	return old;
> +	return mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP));
>  }
>  
> +static BLOCKING_NOTIFIER_HEAD(tracepoint_notify_list);
> +
>  /**
> - * tracepoint_probe_register -  Connect a probe to a tracepoint
> - * @name: tracepoint name
> - * @probe: probe handler
> + * register_tracepoint_notifier - register tracepoint coming/going notifier
> + * @nb: notifier block
>   *
> - * Returns 0 if ok, error value on error.
> - * The probe address must at least be aligned on the architecture pointer size.
> + * Notifiers registered with this function are called on module
> + * coming/going with the tp_modlist_mutex held.
> + * The notifier block callback should expect a "struct tp_module" data
> + * pointer.
>   */
> -int tracepoint_probe_register(const char *name, void *probe, void *data)
> -{
> -	struct tracepoint_func *old;
> -
> -	mutex_lock(&tracepoints_mutex);
> -	old = tracepoint_add_probe(name, probe, data);
> -	if (IS_ERR(old)) {
> -		mutex_unlock(&tracepoints_mutex);
> -		return PTR_ERR(old);
> -	}
> -	tracepoint_update_probes();		/* may update entry */
> -	mutex_unlock(&tracepoints_mutex);
> -	release_probes(old);
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(tracepoint_probe_register);
> -
> -static struct tracepoint_func *
> -tracepoint_remove_probe(const char *name, void *probe, void *data)
> +int register_tracepoint_module_notifier(struct notifier_block *nb)

WTF is this?

You created a notifier for a notifier? No! keep track yourself what
tracepoints you enabled for a module and just add a module notifier for
yourself and when a module exits, remove your tracepoints. This is dead
code. There's no users in the kernel of this notifier. It's not needed.
Get rid of it.

The ftrace event system can handle events that are being removed when a
module is unloaded. So can your code.

-- Steve


>  {
> -	struct tracepoint_entry *entry;
> -	struct tracepoint_func *old;
> +	struct tp_module *tp_mod;
> +	int ret;
>  
> -	entry = get_tracepoint(name);
> -	if (!entry)
> -		return ERR_PTR(-ENOENT);
> -	old = tracepoint_entry_remove_probe(entry, probe, data);
> -	if (IS_ERR(old))
> -		return old;
> -	if (!entry->refcount)
> -		remove_tracepoint(entry);
> -	return old;
> +	mutex_lock(&tp_modlist_mutex);
> +	ret = blocking_notifier_chain_register(&tracepoint_notify_list, nb);
> +	if (ret)
> +		goto end;
> +	list_for_each_entry(tp_mod, &tp_modlist, list)
> +		(void) nb->notifier_call(nb, MODULE_STATE_COMING, tp_mod);
> +end:
> +	mutex_unlock(&tp_modlist_mutex);
> +	return ret;
>  }
> +EXPORT_SYMBOL_GPL(register_tracepoint_module_notifier);
>  
>  /**
> - * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
> - * @name: tracepoint name
> - * @probe: probe function pointer
> + * unregister_tracepoint_notifier - unregister tracepoint coming/going notifier
> + * @nb: notifier block
>   *
> - * We do not need to call a synchronize_sched to make sure the probes have
> - * finished running before doing a module unload, because the module unload
> - * itself uses stop_machine(), which insures that every preempt disabled section
> - * have finished.
> + * The notifier block callback should expect a "struct tp_module" data
> + * pointer.
>   */
> -int tracepoint_probe_unregister(const char *name, void *probe, void *data)
> +int unregister_tracepoint_module_notifier(struct notifier_block *nb)
>  {
> -	struct tracepoint_func *old;
> +	struct tp_module *tp_mod;
> +	int ret;
> +
> +	mutex_lock(&tp_modlist_mutex);
> +	ret = blocking_notifier_chain_unregister(&tracepoint_notify_list, nb);
> +	if (ret)
> +		goto end;
> +	list_for_each_entry(tp_mod, &tp_modlist, list)
> +		(void) nb->notifier_call(nb, MODULE_STATE_GOING, tp_mod);
> +end:
> +	mutex_unlock(&tp_modlist_mutex);
> +	return ret;
>  
> -	mutex_lock(&tracepoints_mutex);
> -	old = tracepoint_remove_probe(name, probe, data);
> -	if (IS_ERR(old)) {
> -		mutex_unlock(&tracepoints_mutex);
> -		return PTR_ERR(old);
> -	}
> -	tracepoint_update_probes();		/* may update entry */
> -	mutex_unlock(&tracepoints_mutex);
> -	release_probes(old);
> -	return 0;
>  }
> -EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
> +EXPORT_SYMBOL_GPL(unregister_tracepoint_module_notifier);
>  
> -#ifdef CONFIG_MODULES
> -bool trace_module_has_bad_taint(struct module *mod)
> +/*
> + * Ensure the tracer unregistered the module's probes before the module
> + * teardown is performed. Prevents leaks of probe and data pointers.
> + */
> +static
> +void tp_module_going_check_quiescent(struct tracepoint * const *begin,
> +		struct tracepoint * const *end)
>  {
> -	return mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP));
> +	struct tracepoint * const *iter;
> +
> +	if (!begin)
> +		return;
> +	for (iter = begin; iter < end; iter++)
> +		WARN_ON_ONCE((*iter)->funcs);
>  }
>  
> -static int tracepoint_module_coming(struct module *mod)
> +static
> +int tracepoint_module_coming(struct module *mod)
>  {
>  	struct tp_module *tp_mod;
>  	int ret = 0;
>  
>  	/*
> -	 * We skip modules that taint the kernel, especially those with different
> -	 * module headers (for forced load), to make sure we don't cause a crash.
> -	 * Staging and out-of-tree GPL modules are fine.
> +	 * We skip modules that taint the kernel, especially those with
> +	 * different module headers (for forced load), to make sure we
> +	 * don't cause a crash. Staging and out-of-tree GPL modules are
> +	 * fine.
>  	 */
>  	if (trace_module_has_bad_taint(mod))
>  		return 0;
> -	mutex_lock(&tracepoints_mutex);
> +	mutex_lock(&tp_modlist_mutex);
>  	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
>  	if (!tp_mod) {
>  		ret = -ENOMEM;
> @@ -461,25 +381,32 @@ static int tracepoint_module_coming(struct module *mod)
>  	}
>  	tp_mod->num_tracepoints = mod->num_tracepoints;
>  	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
> -	list_add_tail(&tp_mod->list, &tracepoint_module_list);
> -	tracepoint_update_probe_range(mod->tracepoints_ptrs,
> -		mod->tracepoints_ptrs + mod->num_tracepoints);
> +	list_add_tail(&tp_mod->list, &tp_modlist);
> +	blocking_notifier_call_chain(&tracepoint_notify_list,
> +			MODULE_STATE_COMING, tp_mod);
>  end:
> -	mutex_unlock(&tracepoints_mutex);
> +	mutex_unlock(&tp_modlist_mutex);
>  	return ret;
>  }
>  
> -static int tracepoint_module_going(struct module *mod)
> +static
> +void tracepoint_module_going(struct module *mod)
>  {
> -	struct tp_module *pos;
> -
> -	mutex_lock(&tracepoints_mutex);
> -	tracepoint_update_probe_range(mod->tracepoints_ptrs,
> -		mod->tracepoints_ptrs + mod->num_tracepoints);
> -	list_for_each_entry(pos, &tracepoint_module_list, list) {
> -		if (pos->tracepoints_ptrs == mod->tracepoints_ptrs) {
> -			list_del(&pos->list);
> -			kfree(pos);
> +	struct tp_module *tp_mod;
> +
> +	mutex_lock(&tp_modlist_mutex);
> +	list_for_each_entry(tp_mod, &tp_modlist, list) {
> +		if (tp_mod->tracepoints_ptrs == mod->tracepoints_ptrs) {
> +			blocking_notifier_call_chain(&tracepoint_notify_list,
> +					MODULE_STATE_GOING, tp_mod);
> +			list_del(&tp_mod->list);
> +			kfree(tp_mod);
> +			/*
> +			 * Called the going notifier before checking for
> +			 * quiescence.
> +			 */
> +			tp_module_going_check_quiescent(mod->tracepoints_ptrs,
> +				mod->tracepoints_ptrs + mod->num_tracepoints);
>  			break;
>  		}
>  	}
> @@ -489,12 +416,12 @@ static int tracepoint_module_going(struct module *mod)
>  	 * flag on "going", in case a module taints the kernel only after being
>  	 * loaded.
>  	 */
> -	mutex_unlock(&tracepoints_mutex);
> -	return 0;
> +	mutex_unlock(&tp_modlist_mutex);
>  }
>  
> +static
>  int tracepoint_module_notify(struct notifier_block *self,
> -			     unsigned long val, void *data)
> +		unsigned long val, void *data)
>  {
>  	struct module *mod = data;
>  	int ret = 0;
> @@ -503,30 +430,65 @@ int tracepoint_module_notify(struct notifier_block *self,
>  	case MODULE_STATE_COMING:
>  		ret = tracepoint_module_coming(mod);
>  		break;
> -	case MODULE_STATE_LIVE:
> -		break;
>  	case MODULE_STATE_GOING:
> -		ret = tracepoint_module_going(mod);
> +		tracepoint_module_going(mod);
> +		break;
> +	default:
>  		break;
>  	}
>  	return ret;
>  }
>  
> +static
>  struct notifier_block tracepoint_module_nb = {
>  	.notifier_call = tracepoint_module_notify,
>  	.priority = 0,
>  };
>  
> -static int init_tracepoints(void)
> +static __init
> +int init_tracepoints(void)
>  {
> -	return register_module_notifier(&tracepoint_module_nb);
> +	int ret;
> +
> +	ret = register_module_notifier(&tracepoint_module_nb);
> +	if (ret) {
> +		pr_warning("Failed to register tracepoint module enter notifier\n");
> +	}
> +	return ret;
>  }
>  __initcall(init_tracepoints);
>  #endif /* CONFIG_MODULES */
>  
> +static
> +void for_each_tracepoint_range(struct tracepoint * const *begin,
> +		struct tracepoint * const *end,
> +		void (*fct)(struct tracepoint *tp, void *priv),
> +		void *priv)
> +{
> +	struct tracepoint * const *iter;
> +
> +	if (!begin)
> +		return;
> +	for (iter = begin; iter < end; iter++)
> +		fct(*iter, priv);
> +}
> +
> +/**
> + * for_each_kernel_tracepoint - iteration on all kernel tracepoints
> + * @fct: callback
> + * @priv: private data
> + */
> +void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
> +		void *priv)
> +{
> +	for_each_tracepoint_range(__start___tracepoints_ptrs,
> +		__stop___tracepoints_ptrs, fct, priv);
> +}
> +EXPORT_SYMBOL_GPL(for_each_kernel_tracepoint);
> +
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>  
> -/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
> +/* NB: reg/unreg are called while guarded with the tracepoint_mutex */
>  static int sys_tracepoint_refcount;
>  
>  void syscall_regfunc(void)

