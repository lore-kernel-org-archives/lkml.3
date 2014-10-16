Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaJPXQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:16:11 -0400
Received: from ozlabs.org ([103.22.144.67]:38420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaJPXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:16:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: Re: [PATCH] kernel:module Fix coding style errors and warnings.
In-Reply-To: <1413455749-29357-1-git-send-email-ionut.m.alexa@gmail.com>
References: <1413455749-29357-1-git-send-email-ionut.m.alexa@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Oct 2014 09:36:20 +1030
Message-ID: <87tx33aa37.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ionut Alexa <ionut.m.alexa@gmail.com> writes:
> Fixed codin style errors and warnings. Changes printk with
> print_debug/warn. Changed seq_printf to seq_puts.
>
> Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>

Hi Ionut,

Please drop the following changes:
> @@ -110,7 +110,7 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
>  #ifdef CONFIG_MODULE_SIG_FORCE
>  static bool sig_enforce = true;
>  #else
> -static bool sig_enforce = false;
> +static bool sig_enforce; /* by default set to false */
>  
>  static int param_set_bool_enable_only(const char *val,
>  				      const struct kernel_param *kp)
> @@ -156,15 +156,15 @@ static BLOCKING_NOTIFIER_HEAD(module_notify_list);
>  
>  /* Bounds of module allocation, for speeding __module_address.
>   * Protected by module_mutex. */
> -static unsigned long module_addr_min = -1UL, module_addr_max = 0;
> +static unsigned long module_addr_min = -1UL, module_addr_max; /* addr_max=0 */

I think the explicit initializers are clearer.  Gcc realizes they're
zero and puts them in bss anyway, so there's no size cost.

> -int register_module_notifier(struct notifier_block * nb)
> +int register_module_notifier(struct notifier_block *nb)
>  {
>  	return blocking_notifier_chain_register(&module_notify_list, nb);
>  }
>  EXPORT_SYMBOL(register_module_notifier);
>  
> -int unregister_module_notifier(struct notifier_block * nb)
> +int unregister_module_notifier(struct notifier_block *nb)
>  {
>  	return blocking_notifier_chain_unregister(&module_notify_list, nb);
>  }
> @@ -740,8 +740,7 @@ static inline int try_force_unload(unsigned int flags)
>  }
>  #endif /* CONFIG_MODULE_FORCE_UNLOAD */
>  
> -struct stopref
> -{
> +struct stopref {
>  	struct module *mod;
>  	int flags;
>  	int *forced;

These are fine.

> @@ -878,7 +877,7 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
>  	seq_printf(m, " %lu ", module_refcount(mod));
>  
>  	/* Always include a trailing , so userspace can differentiate
> -           between this and the old multi-field proc format. */
> +	 * between this and the old multi-field proc format. */
>  	list_for_each_entry(use, &mod->source_list, source_list) {
>  		printed_something = 1;
>  		seq_printf(m, "%s,", use->source->name);

Actually, kernel style for multi-line comments, like it or not, is:

  	/*
         * Always include a trailing , so userspace can differentiate
	 * between this and the old multi-field proc format.
         */
        
> @@ -1953,7 +1951,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			/* We compiled with -fno-common.  These are not
>  			   supposed to happen.  */
>  			pr_debug("Common symbol: %s\n", name);
> -			printk("%s: please compile with -fno-common\n",
> +			pr_debug("%s: please compile with -fno-common\n",
>  			       mod->name);
>  			ret = -ENOEXEC;
>  			break;

Please change it to pr_warn rather than pr_debug!

> @@ -3022,7 +3020,7 @@ static int do_init_module(struct module *mod)
>  		ret = do_one_initcall(mod->init);
>  	if (ret < 0) {
>  		/* Init routine failed: abort.  Try to protect us from
> -                   buggy refcounters. */
> +		 * buggy refcounters. */
>  		mod->state = MODULE_STATE_GOING;
>  		synchronize_sched();
>  		module_put(mod);
> @@ -3174,7 +3172,7 @@ out:

Comment style here, too.

> @@ -3816,7 +3814,7 @@ void print_modules(void)
>  	struct module *mod;
>  	char buf[8];
>  
> -	printk(KERN_DEFAULT "Modules linked in:");
> +	pr_warn("Modules linked in:");

This is not the same as KERN_DEFAULT; is it correct?

Thanks,
Rusty.
