Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaDYFKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:10:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57725 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDYFKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:10:49 -0400
Message-ID: <5359EE50.2000007@hitachi.com>
Date: Fri, 25 Apr 2014 14:10:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ftrace/module: Hardcode ftrace_module_init() call
 into load_module()
References: <20140424105417.7407bb72@gandalf.local.home>
In-Reply-To: <20140424105417.7407bb72@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/24 23:54), Steven Rostedt wrote:
> [
>   Rusty, you can take this patch, or if you want, you can give me 
>   an Acked-by, and I'll push this through my tree.
> ]
> 
> 
>>From 3ad4487ccecb8eb799c8e96309f256a1c9296685 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Thu, 24 Apr 2014 10:40:12 -0400
> Subject: [PATCH] ftrace/module: Hardcode ftrace_module_init() call into
>  load_module()
> 
> A race exists between module loading and enabling of function tracer.
> 
> 	CPU 1				CPU 2
> 	-----				-----
>   load_module()
>    module->state = MODULE_STATE_COMING
> 
> 				register_ftrace_function()
> 				 mutex_lock(&ftrace_lock);
> 				 ftrace_startup()
> 				  update_ftrace_function();
> 				   ftrace_arch_code_modify_prepare()
> 				    set_all_module_text_rw();
> 				   <enables-ftrace>
> 				    ftrace_arch_code_modify_post_process()
> 				     set_all_module_text_ro();
> 
> 				[ here all module text is set to RO,
> 				  including the module that is
> 				  loading!! ]
> 
>    blocking_notifier_call_chain(MODULE_STATE_COMING);
>     ftrace_init_module()
> 
>      [ tries to modify code, but it's RO, and fails!
>        ftrace_bug() is called]
> 
> When this race happens, ftrace_bug() will produces a nasty warning and
> all of the function tracing features will be disabled until reboot.
> 
> The simple solution is to treate module load the same way the core
> kernel is treated at boot. To hardcode the ftrace function modification
> of converting calls to mcount into nops. This is done in init/main.c
> there's no reason it could not be done in load_module(). This gives
> a better control of the changes and doesn't tie the state of the
> module to its notifiers as much. Ftrace is special, it needs to be
> treated as such.
> 
> The reason this would work, is that the ftrace_module_init() would be
> called while the module is in MODULE_STATE_UNFORMED, which is ignored
> by the set_all_module_text_ro() call.
> 
> Link: http://lkml.kernel.org/r/1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com
> 
> Reported-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> Cc: stable@vger.kernel.org # 2.6.38+
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  include/linux/ftrace.h |  2 ++
>  kernel/module.c        |  3 +++
>  kernel/trace/ftrace.c  | 27 ++++-----------------------
>  3 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9212b01..ae9504b 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -535,6 +535,7 @@ static inline int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_a
>  extern int ftrace_arch_read_dyn_info(char *buf, int size);
>  
>  extern int skip_trace(unsigned long ip);
> +extern void ftrace_module_init(struct module *mod);
>  
>  extern void ftrace_disable_daemon(void);
>  extern void ftrace_enable_daemon(void);
> @@ -544,6 +545,7 @@ static inline int ftrace_force_update(void) { return 0; }
>  static inline void ftrace_disable_daemon(void) { }
>  static inline void ftrace_enable_daemon(void) { }
>  static inline void ftrace_release_mod(struct module *mod) {}
> +static inline void ftrace_module_init(struct module *mod) {}
>  static inline __init int register_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	return -EINVAL;
> diff --git a/kernel/module.c b/kernel/module.c
> index 1186940..5f14fec 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3271,6 +3271,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  
>  	dynamic_debug_setup(info->debug, info->num_debug);
>  
> +	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
> +	ftrace_module_init(mod);
> +
>  	/* Finally it's fully formed, ready to start executing. */
>  	err = complete_formation(mod, info);
>  	if (err)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 1fd4b94..4a54a25 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4330,16 +4330,11 @@ static void ftrace_init_module(struct module *mod,
>  	ftrace_process_locs(mod, start, end);
>  }
>  
> -static int ftrace_module_notify_enter(struct notifier_block *self,
> -				      unsigned long val, void *data)
> +void ftrace_module_init(struct module *mod)
>  {
> -	struct module *mod = data;
> -
> -	if (val == MODULE_STATE_COMING)
> -		ftrace_init_module(mod, mod->ftrace_callsites,
> -				   mod->ftrace_callsites +
> -				   mod->num_ftrace_callsites);
> -	return 0;
> +	ftrace_init_module(mod, mod->ftrace_callsites,
> +			   mod->ftrace_callsites +
> +			   mod->num_ftrace_callsites);
>  }
>  
>  static int ftrace_module_notify_exit(struct notifier_block *self,
> @@ -4353,11 +4348,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
>  	return 0;
>  }
>  #else
> -static int ftrace_module_notify_enter(struct notifier_block *self,
> -				      unsigned long val, void *data)
> -{
> -	return 0;
> -}
>  static int ftrace_module_notify_exit(struct notifier_block *self,
>  				     unsigned long val, void *data)
>  {
> @@ -4365,11 +4355,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
>  }
>  #endif /* CONFIG_MODULES */
>  
> -struct notifier_block ftrace_module_enter_nb = {
> -	.notifier_call = ftrace_module_notify_enter,
> -	.priority = INT_MAX,	/* Run before anything that can use kprobes */
> -};
> -
>  struct notifier_block ftrace_module_exit_nb = {
>  	.notifier_call = ftrace_module_notify_exit,
>  	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
> @@ -4403,10 +4388,6 @@ void __init ftrace_init(void)
>  				  __start_mcount_loc,
>  				  __stop_mcount_loc);
>  
> -	ret = register_module_notifier(&ftrace_module_enter_nb);
> -	if (ret)
> -		pr_warning("Failed to register trace ftrace module enter notifier\n");
> -
>  	ret = register_module_notifier(&ftrace_module_exit_nb);
>  	if (ret)
>  		pr_warning("Failed to register trace ftrace module exit notifier\n");
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


