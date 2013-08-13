Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab3HMXNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:13:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27443 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3HMXNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:13:52 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lRvUdbBmi18A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bpXn7r4kvEgA:10 a=pGLkceISAAAA:8 a=jvMiHq2FoQJIE2o-JhUA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=J9adBV2d1j4r5IAJ:21 a=7VDIzOl8FMjTnopH:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 19:13:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] module: Allow parameters without arguments
Message-ID: <20130813191350.077bf133@gandalf.local.home>
In-Reply-To: <20130813210228.989279359@goodmis.org>
References: <20130813210228.989279359@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 17:02:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Rusty,
> 
> I'm looking at porting my "enable tracepoints in module load" patches
> and one of the comments you gave me (long ago) was to not have:
> 
>  trace_foo=1
> 
> but to just have:
> 
>  trace_foo
> 
> as a parameter name. I went and implemented this but discovered that the
> functions that allow no arguments are hard coded in the params.c file.
> 
> I changed this to allow other "set" functions to be given no arguments,
> and even noticed that a few already exist in the kernel. So I'm sending
> you this patch set that implements a modification to the parameter
> parsing to allow other kernel_param_ops to not bother with arguments
> passed in.
> 
> What do you think?
> 
> -- Steve
> 
> Steven Rostedt (1):
>       tracing: Enable tracepoints via module parameters
> 

OK, this is what I get for using my scripts along with manually sending
out patches via quilt. I only wanted to send out the three patches
below, but then used my scripts to make this header. The above patch
commit (along with the complete change set below) was not what I
intended on sending :-p

-- Steve



> Steven Rostedt (Red Hat) (3):
>       module: Add flag to allow mod params to have no arguments
>       module: Add NOARG flag for ops with param_set_bool_enable_only() set function
>       module/lsm: Have apparmor module parameters work with no args
> 
> ----
>  include/linux/ftrace_event.h |    4 +++
>  include/linux/moduleparam.h  |   13 +++++++-
>  include/trace/ftrace.h       |   23 ++++++++++++--
>  kernel/module.c              |    1 +
>  kernel/params.c              |    6 ++--
>  kernel/trace/trace_events.c  |   71 ++++++++++++++++++++++++++++++++++++++++++
>  security/apparmor/lsm.c      |    2 ++
>  7 files changed, 115 insertions(+), 5 deletions(-)
> ---------------------------
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 120d57a..0395182 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -164,6 +164,8 @@ void tracing_record_cmdline(struct task_struct *tsk);
>  
>  struct event_filter;
>  
> +extern struct kernel_param_ops ftrace_mod_ops;
> +
>  enum trace_reg {
>  	TRACE_REG_REGISTER,
>  	TRACE_REG_UNREGISTER,
> @@ -202,6 +204,7 @@ enum {
>  	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
>  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
>  	TRACE_EVENT_FL_WAS_ENABLED_BIT,
> +	TRACE_EVENT_FL_MOD_ENABLE_BIT,
>  };
>  
>  /*
> @@ -220,6 +223,7 @@ enum {
>  	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
>  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
>  	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
> +	TRACE_EVENT_FL_MOD_ENABLE	= (1 << TRACE_EVENT_FL_MOD_ENABLE_BIT),
>  };
>  
>  struct ftrace_event_call {
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 27d9da3..c3eb102 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -36,7 +36,18 @@ static const char __UNIQUE_ID(name)[]					  \
>  
>  struct kernel_param;
>  
> +/*
> + * Flags available for kernel_param_ops
> + *
> + * NOARG - the parameter allows for no argument (foo instead of foo=1)
> + */
> +enum {
> +	KERNEL_PARAM_FL_NOARG = (1 << 0)
> +};
> +
>  struct kernel_param_ops {
> +	/* How the ops should behave */
> +	unsigned int flags;
>  	/* Returns 0, or -errno.  arg is in kp->arg. */
>  	int (*set)(const char *val, const struct kernel_param *kp);
>  	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
> @@ -187,7 +198,7 @@ struct kparam_array
>  /* Obsolete - use module_param_cb() */
>  #define module_param_call(name, set, get, arg, perm)			\
>  	static struct kernel_param_ops __param_ops_##name =		\
> -		 { (void *)set, (void *)get };				\
> +		{ 0, (void *)set, (void *)get };			\
>  	__module_param_call(MODULE_PARAM_PREFIX,			\
>  			    name, &__param_ops_##name, arg,		\
>  			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 41a6643..d6029ed 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <linux/ftrace_event.h>
> +#include <linux/module.h>
>  
>  /*
>   * DECLARE_EVENT_CLASS can be used to add a generic function
> @@ -577,6 +578,22 @@ static inline void ftrace_test_probe_##call(void)			\
>  #undef __get_dynamic_array
>  #undef __get_str
>  
> +/*
> + * Add ftrace trace points in modules to be set by module
> + * parameters. This adds "trace_##call" as a module parameter.
> + * The user could enable trace points on module load with:
> + *  trace_##call=1 as a module parameter.
> + */
> +#undef ftrace_mod_params
> +#ifdef MODULE
> +#define ftrace_mod_params(call)				\
> +	module_param_cb(trace_##call, &ftrace_mod_ops,	\
> +			&event_##call, 0644);		\
> +	MODULE_INFO(tracepoint, #call)
> +#else
> +#define ftrace_mod_params(call)
> +#endif
> +
>  #undef TP_printk
>  #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
>  
> @@ -604,7 +621,8 @@ static struct ftrace_event_call __used event_##call = {			\
>  	.print_fmt		= print_fmt_##template,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;\
> +ftrace_mod_params(call)
>  
>  #undef DEFINE_EVENT_PRINT
>  #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
> @@ -618,7 +636,8 @@ static struct ftrace_event_call __used event_##call = {			\
>  	.print_fmt		= print_fmt_##call,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call; \
> +ftrace_mod_params(call)
>  
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..4eb26b6 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -136,6 +136,7 @@ static int param_set_bool_enable_only(const char *val,
>  }
>  
>  static const struct kernel_param_ops param_ops_bool_enable_only = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_bool_enable_only,
>  	.get = param_get_bool,
>  };
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..27a0af9 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -103,8 +103,8 @@ static int parse_one(char *param,
>  			    || params[i].level > max_level)
>  				return 0;
>  			/* No one handled NULL, so do it here. */
> -			if (!val && params[i].ops->set != param_set_bool
> -			    && params[i].ops->set != param_set_bint)
> +			if (!val &&
> +			    !(params[i].ops->flags & KERNEL_PARAM_FL_NOARG))
>  				return -EINVAL;
>  			pr_debug("handling %s with %p\n", param,
>  				params[i].ops->set);
> @@ -320,6 +320,7 @@ int param_get_bool(char *buffer, const struct kernel_param *kp)
>  EXPORT_SYMBOL(param_get_bool);
>  
>  struct kernel_param_ops param_ops_bool = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_bool,
>  	.get = param_get_bool,
>  };
> @@ -370,6 +371,7 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
>  EXPORT_SYMBOL(param_set_bint);
>  
>  struct kernel_param_ops param_ops_bint = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_bint,
>  	.get = param_get_int,
>  };
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 29a7ebc..5bd3f51 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1839,10 +1839,32 @@ trace_create_file_ops(struct module *mod)
>  	return file_ops;
>  }
>  
> +static void
> +enable_event_on_trace_array(struct trace_array *tr,
> +			    struct ftrace_event_call *call)
> +{
> +	struct ftrace_event_file *file;
> +	int ret;
> +
> +	call->flags &= ~TRACE_EVENT_FL_MOD_ENABLE;
> +
> +	/* find event on top trace array */
> +	list_for_each_entry(file, &tr->events, list) {
> +		if (file->event_call == call) {
> +			ret = ftrace_event_enable_disable(file, 1);
> +			if (ret < 0)
> +				pr_warning("unable to enable tracepoint %s",
> +					   call->name);
> +			return;
> +		}
> +	}
> +}
> +
>  static void trace_module_add_events(struct module *mod)
>  {
>  	struct ftrace_module_file_ops *file_ops = NULL;
>  	struct ftrace_event_call **call, **start, **end;
> +	struct trace_array *tr = NULL;
>  
>  	start = mod->trace_events;
>  	end = mod->trace_events + mod->num_trace_events;
> @@ -1857,6 +1879,12 @@ static void trace_module_add_events(struct module *mod)
>  	for_each_event(call, start, end) {
>  		__register_event(*call, mod);
>  		__add_event_to_tracers(*call, file_ops);
> +		/* If the module tracepoint parameter was set */
> +		if ((*call)->flags & TRACE_EVENT_FL_MOD_ENABLE) {
> +			if (!tr)
> +				tr = top_trace_array();
> +			enable_event_on_trace_array(tr, *call);
> +		}
>  	}
>  }
>  
> @@ -2569,6 +2597,49 @@ early_initcall(event_trace_memsetup);
>  core_initcall(event_trace_enable);
>  fs_initcall(event_trace_init);
>  
> +/* Allow modules to load with enabled trace points */
> +int ftrace_mod_param_set(const char *val, const struct kernel_param *kp)
> +{
> +	struct ftrace_event_call *call = kp->arg;
> +
> +	/* This is set like param_set_bool() */
> +
> +	/* No equals means "set"... */
> +	if (!val)
> +		val = "1";
> +
> +	/* One of =[yYnN01] */
> +	switch (val[0]) {
> +	case 'y': case 'Y': case '1':
> +		break;
> +	case 'n': case 'N': case '0':
> +		/* Do nothing */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Set flag to tell ftrace to enable this event on init */
> +	call->flags = TRACE_EVENT_FL_MOD_ENABLE;
> +
> +	return 0;
> +}
> +
> +int ftrace_mod_param_get(char *buffer, const struct kernel_param *kp)
> +{
> +	struct ftrace_event_call *call = kp->arg;
> +
> +	return sprintf(buffer, "%d",
> +		       !!(call->flags & TRACE_EVENT_FL_MOD_ENABLE));
> +}
> +
> +struct kernel_param_ops ftrace_mod_ops = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
> +	.set = ftrace_mod_param_set,
> +	.get = ftrace_mod_param_get,
> +};
> +EXPORT_SYMBOL(ftrace_mod_ops);
> +
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>  
>  static DEFINE_SPINLOCK(test_spinlock);
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 2e2a0dd..e3a704c 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -666,6 +666,7 @@ static int param_set_aabool(const char *val, const struct kernel_param *kp);
>  static int param_get_aabool(char *buffer, const struct kernel_param *kp);
>  #define param_check_aabool param_check_bool
>  static struct kernel_param_ops param_ops_aabool = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_aabool,
>  	.get = param_get_aabool
>  };
> @@ -682,6 +683,7 @@ static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp
>  static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
>  #define param_check_aalockpolicy param_check_bool
>  static struct kernel_param_ops param_ops_aalockpolicy = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_aalockpolicy,
>  	.get = param_get_aalockpolicy
>  };

