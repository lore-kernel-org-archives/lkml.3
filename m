Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3IQW7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:59:51 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56178 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3IQW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <87wqmh1l8b.fsf@rustcorp.com.au>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com>
 <87ioy536mu.fsf@rustcorp.com.au> <CAKi4VAJ5=zsJzyQNprchB2wnwh0+gg2oNP2PFsa4Lcw++3mSig@mail.gmail.com>
 <87wqmh1l8b.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 17 Sep 2013 19:59:29 -0300
Message-ID: <CAKi4VAJXq0Sqdacvrq7P81hRJkEUXo-u_HoNtAABN4QDk_nPnQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero
 procedure as async
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Chen <peter.chen@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:47 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> On Thu, Sep 12, 2013 at 9:30 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Peter Chen <peter.chen@freescale.com> writes:
>>>> Currently, if module's refcount is not zero during the unload,
>>>> it waits there until the user decreases that refcount.
>>>
>>> Hi Peter,
>>>
>>>         In practice userspace uses O_NONBLOCK.  In fact, I've been
>>> thinking of removing the blocking case altogether, since it's not really
>>> what people want.
>>>
>>> That would solve your problem and make the code simpler.  Thoughts?
>>
>> I'm all in favor of this. It's been almost 1 year it's deprecated in
>> kmod and if anyone tries to use we force a 10s delay on module
>> removal. So far nobody complained.
>>
>> Lucas De Marchi
>
> Here's what I've got in my pending-rebases tree.
>
> Cheers,
> Rusty.
>
> module: remove rmmod --wait option.
>
> The option to wait for a module reference count to reach zero was in
> the initial module implementation, but it was never supported in
> modprobe (you had to use rmmod --wait).  After discussion with Lucas,
> It has been deprecated (with a 10 second sleep) in kmod for the last
> year.
>
> This finally removes it: the flag will evoke a printk warning and a
> normal (non-blocking) remove attempt.
>
> Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 05f2447..15cd6b1 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -367,9 +367,6 @@ struct module
>         /* What modules do I depend on? */
>         struct list_head target_list;
>
> -       /* Who is waiting for us to be unloaded */
> -       struct task_struct *waiter;
> -
>         /* Destruction function. */
>         void (*exit)(void);
>
> diff --git a/kernel/module.c b/kernel/module.c
> index dc58274..947105f 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -644,8 +644,6 @@ static int module_unload_init(struct module *mod)
>
>         /* Hold reference count during initialization. */
>         __this_cpu_write(mod->refptr->incs, 1);
> -       /* Backwards compatibility macros put refcount during init. */
> -       mod->waiter = current;
>
>         return 0;
>  }
> @@ -771,16 +769,9 @@ static int __try_stop_module(void *_sref)
>
>  static int try_stop_module(struct module *mod, int flags, int *forced)
>  {
> -       if (flags & O_NONBLOCK) {
> -               struct stopref sref = { mod, flags, forced };
> +       struct stopref sref = { mod, flags, forced };
>
> -               return stop_machine(__try_stop_module, &sref, NULL);
> -       } else {
> -               /* We don't need to stop the machine for this. */
> -               mod->state = MODULE_STATE_GOING;
> -               synchronize_sched();
> -               return 0;
> -       }
> +       return stop_machine(__try_stop_module, &sref, NULL);
>  }
>
>  unsigned long module_refcount(struct module *mod)
> @@ -813,21 +804,6 @@ EXPORT_SYMBOL(module_refcount);
>  /* This exists whether we can unload or not */
>  static void free_module(struct module *mod);
>
> -static void wait_for_zero_refcount(struct module *mod)
> -{
> -       /* Since we might sleep for some time, release the mutex first */
> -       mutex_unlock(&module_mutex);
> -       for (;;) {
> -               pr_debug("Looking at refcount...\n");
> -               set_current_state(TASK_UNINTERRUPTIBLE);
> -               if (module_refcount(mod) == 0)
> -                       break;
> -               schedule();
> -       }
> -       current->state = TASK_RUNNING;
> -       mutex_lock(&module_mutex);
> -}
> -
>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>                 unsigned int, flags)
>  {
> @@ -842,6 +818,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>                 return -EFAULT;
>         name[MODULE_NAME_LEN-1] = '\0';
>
> +       if (!(flags & O_NONBLOCK)) {
> +               printk(KERN_WARNING
> +                      "waiting module removal not supported: please upgrade");
> +       }
> +
>         if (mutex_lock_interruptible(&module_mutex) != 0)
>                 return -EINTR;
>
> @@ -859,8 +840,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>
>         /* Doing init or already dying? */
>         if (mod->state != MODULE_STATE_LIVE) {
> -               /* FIXME: if (force), slam module count and wake up
> -                   waiter --RR */
> +               /* FIXME: if (force), slam module count damn the torpedoes */
>                 pr_debug("%s already dying\n", mod->name);
>                 ret = -EBUSY;
>                 goto out;
> @@ -876,18 +856,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>                 }
>         }
>
> -       /* Set this up before setting mod->state */
> -       mod->waiter = current;
> -
>         /* Stop the machine so refcounts can't move and disable module. */
>         ret = try_stop_module(mod, flags, &forced);
>         if (ret != 0)
>                 goto out;
>
> -       /* Never wait if forced. */
> -       if (!forced && module_refcount(mod) != 0)
> -               wait_for_zero_refcount(mod);
> -
>         mutex_unlock(&module_mutex);
>         /* Final destruction now no one is using it. */
>         if (mod->exit != NULL)
> @@ -1005,9 +978,6 @@ void module_put(struct module *module)
>                 __this_cpu_inc(module->refptr->decs);
>
>                 trace_module_put(module, _RET_IP_);
> -               /* Maybe they're waiting for us to drop reference? */
> -               if (unlikely(!module_is_live(module)))
> -                       wake_up_process(module->waiter);
>                 preempt_enable();
>         }
>  }

Acked-by: Lucas De Marchi <lucas.demarchi@intel.com>


Lucas De Marchi
