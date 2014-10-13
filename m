Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJMFQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:16:17 -0400
Received: from ozlabs.org ([103.22.144.67]:60521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaJMFQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:16:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 5/5] module: Remove stop_machine from module unloading
In-Reply-To: <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal> <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 15:10:27 +1030
Message-ID: <87ppdweg5g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> Remove stop_machine from module unloading by replacing module_ref
> with atomic_t. Note that this can cause a performance regression
> on big-SMP machine by direct memory access. For those machines,
> you can lockdwon all modules. Since the lockdown skips reference
> counting, it'll be more scalable than per-cpu module_ref counters.

Sorry for the delay; I didn't get to this before I left, and then
I was away for 3 weeks vacation.

First, I agree you should drop the MODULE_STATE_LOCKUP patch.  While I
can't audit every try_module_get() call, I did put an mdelay(100) in
there and did a quick boot for any obvious slowdown.

Second, this patch should be split into two parts.  The first would
simply replace module_ref with atomic_t (a significant simplification),
the second would get rid of stop machine.

> +/*
> + * MODULE_REF_BASE must be 1, since we use atomic_inc_not_zero() for
> + * recovering refcnt (see try_release_module_ref() ).
> + */
> +#define MODULE_REF_BASE	1

True, but we could use atomic_add_unless() instead, and make this
completely generic, right?

> +
>  /* Init the unload section of the module. */
>  static int module_unload_init(struct module *mod)
>  {
> -	mod->refptr = alloc_percpu(struct module_ref);
> -	if (!mod->refptr)
> -		return -ENOMEM;
> +	/*
> +	 * Initialize reference counter to MODULE_REF_BASE.
> +	 * refcnt == 0 means module is going.
> +	 */
> +	atomic_set(&mod->refcnt, MODULE_REF_BASE);
>  
>  	INIT_LIST_HEAD(&mod->source_list);
>  	INIT_LIST_HEAD(&mod->target_list);
>  
>  	/* Hold reference count during initialization. */
> -	raw_cpu_write(mod->refptr->incs, 1);
> +	atomic_inc(&mod->refcnt);
>  
>  	return 0;
>  }
> @@ -721,8 +728,6 @@ static void module_unload_free(struct module *mod)
>  		kfree(use);
>  	}
>  	mutex_unlock(&module_mutex);
> -
> -	free_percpu(mod->refptr);
>  }
>  
>  #ifdef CONFIG_MODULE_FORCE_UNLOAD
> @@ -740,60 +745,38 @@ static inline int try_force_unload(unsigned int flags)
>  }
>  #endif /* CONFIG_MODULE_FORCE_UNLOAD */
>  
> -struct stopref
> +/* Try to release refcount of module, 0 means success. */
> +static int try_release_module_ref(struct module *mod)
>  {
> -	struct module *mod;
> -	int flags;
> -	int *forced;
> -};
> +	int ret;
>  
> -/* Whole machine is stopped with interrupts off when this runs. */
> -static int __try_stop_module(void *_sref)
> -{
> -	struct stopref *sref = _sref;
> +	/* Try to decrement refcnt which we set at loading */
> +	ret = atomic_sub_return(MODULE_REF_BASE, &mod->refcnt);
> +	if (ret)
> +		/* Someone can put this right now, recover with checking */
> +		ret = atomic_inc_not_zero(&mod->refcnt);
> +
> +	return ret;
> +}

This is very clever!  I really like it.

Thanks,
Rusty.
