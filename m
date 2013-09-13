Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3IMAlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:41:01 -0400
Received: from ozlabs.org ([203.10.76.45]:42961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab3IMAkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:40:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Chen <peter.chen@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero procedure as async
In-Reply-To: <1378955676-12708-1-git-send-email-peter.chen@freescale.com>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 13 Sep 2013 10:00:33 +0930
Message-ID: <87ioy536mu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Chen <peter.chen@freescale.com> writes:
> Currently, if module's refcount is not zero during the unload,
> it waits there until the user decreases that refcount.

Hi Peter,

        In practice userspace uses O_NONBLOCK.  In fact, I've been
thinking of removing the blocking case altogether, since it's not really
what people want.

That would solve your problem and make the code simpler.  Thoughts?

Cheers,
Rusty.

> Assume
> we have two modules (A & B), there are no symbol relationship
> between each other. module B is module A's user, if the end
> user tries to unload module A first wrongly, it will stop there
> until there is another user process to unload B, and this
> process can't be killed.
> One use case is: the QA engineers do error test, they unload
> module wrongly on purpose, after that, they find the console
> is stopped there, and they can't do any thing go on.
>
> Signed-off-by: Peter Chen <peter.chen@freescale.com>
> ---
>  include/linux/module.h |    4 +-
>  kernel/module.c        |   61 ++++++++++++++++++++++++++---------------------
>  2 files changed, 36 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 05f2447..12edf07 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -367,8 +367,8 @@ struct module
>  	/* What modules do I depend on? */
>  	struct list_head target_list;
>  
> -	/* Who is waiting for us to be unloaded */
> -	struct task_struct *waiter;
> +	/* The work for waiting refcount to zero */
> +	struct work_struct wait_refcount_work;
>  
>  	/* Destruction function. */
>  	void (*exit)(void);
> diff --git a/kernel/module.c b/kernel/module.c
> index dc58274..94abc7e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -61,6 +61,7 @@
>  #include <linux/pfn.h>
>  #include <linux/bsearch.h>
>  #include <linux/fips.h>
> +#include <linux/delay.h>
>  #include <uapi/linux/module.h>
>  #include "module-internal.h"
>  
> @@ -644,8 +645,6 @@ static int module_unload_init(struct module *mod)
>  
>  	/* Hold reference count during initialization. */
>  	__this_cpu_write(mod->refptr->incs, 1);
> -	/* Backwards compatibility macros put refcount during init. */
> -	mod->waiter = current;
>  
>  	return 0;
>  }
> @@ -813,19 +812,38 @@ EXPORT_SYMBOL(module_refcount);
>  /* This exists whether we can unload or not */
>  static void free_module(struct module *mod);
>  
> +/* Final destruction now no one is using it. */
> +static void module_final_free(struct module *mod)
> +{
> +	if (mod->exit != NULL)
> +		mod->exit();
> +	blocking_notifier_call_chain(&module_notify_list,
> +				     MODULE_STATE_GOING, mod);
> +	async_synchronize_full();
> +
> +	/* Store the name of the last unloaded module for diagnostic purposes */
> +	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> +
> +	free_module(mod);
> +}
> +
>  static void wait_for_zero_refcount(struct module *mod)
>  {
> -	/* Since we might sleep for some time, release the mutex first */
> -	mutex_unlock(&module_mutex);
>  	for (;;) {
>  		pr_debug("Looking at refcount...\n");
> -		set_current_state(TASK_UNINTERRUPTIBLE);
>  		if (module_refcount(mod) == 0)
>  			break;
> -		schedule();
> +		msleep(1000);
>  	}
> -	current->state = TASK_RUNNING;
> -	mutex_lock(&module_mutex);
> +	module_final_free(mod);
> +}
> +
> +static void wait_module_refcount(struct work_struct *work)
> +{
> +	struct module *mod = container_of(work,
> +		struct module, wait_refcount_work);
> +
> +	wait_for_zero_refcount(mod);
>  }
>  
>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> @@ -859,8 +877,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  
>  	/* Doing init or already dying? */
>  	if (mod->state != MODULE_STATE_LIVE) {
> -		/* FIXME: if (force), slam module count and wake up
> -                   waiter --RR */
> +		/* FIXME: if (force), slam module count */
>  		pr_debug("%s already dying\n", mod->name);
>  		ret = -EBUSY;
>  		goto out;
> @@ -876,30 +893,23 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		}
>  	}
>  
> -	/* Set this up before setting mod->state */
> -	mod->waiter = current;
> -
>  	/* Stop the machine so refcounts can't move and disable module. */
>  	ret = try_stop_module(mod, flags, &forced);
>  	if (ret != 0)
>  		goto out;
>  
>  	/* Never wait if forced. */
> -	if (!forced && module_refcount(mod) != 0)
> -		wait_for_zero_refcount(mod);
> +	if (!forced && module_refcount(mod) != 0) {
> +		INIT_WORK(&mod->wait_refcount_work, wait_module_refcount);
> +		schedule_work(&mod->wait_refcount_work);
> +		ret = -EBUSY;
> +		goto out;
> +	}
>  
>  	mutex_unlock(&module_mutex);
> -	/* Final destruction now no one is using it. */
> -	if (mod->exit != NULL)
> -		mod->exit();
> -	blocking_notifier_call_chain(&module_notify_list,
> -				     MODULE_STATE_GOING, mod);
> -	async_synchronize_full();
>  
> -	/* Store the name of the last unloaded module for diagnostic purposes */
> -	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> +	module_final_free(mod);
>  
> -	free_module(mod);
>  	return 0;
>  out:
>  	mutex_unlock(&module_mutex);
> @@ -1005,9 +1015,6 @@ void module_put(struct module *module)
>  		__this_cpu_inc(module->refptr->decs);
>  
>  		trace_module_put(module, _RET_IP_);
> -		/* Maybe they're waiting for us to drop reference? */
> -		if (unlikely(!module_is_live(module)))
> -			wake_up_process(module->waiter);
>  		preempt_enable();
>  	}
>  }
> -- 
> 1.7.1
