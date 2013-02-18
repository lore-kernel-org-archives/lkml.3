Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3BRQY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:24:28 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52159 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3BRQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:23:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130218123920.26245.56709.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
	<20130218123920.26245.56709.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 19 Feb 2013 00:23:56 +0800
Message-ID: <CANN689HhVxDv+3Bn9UAxOMzj0egTvVp_c7oAmQ2nnQ8Xjn_aMA@mail.gmail.com>
Subject: Re: [PATCH v6 08/46] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
From: Michel Lespinasse <walken@google.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 8:39 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Some important design requirements and considerations:
> -----------------------------------------------------
>
> 1. Scalable synchronization at the reader-side, especially in the fast-path
>
>    Any synchronization at the atomic hotplug readers side must be highly
>    scalable - avoid global single-holder locks/counters etc. Because, these
>    paths currently use the extremely fast preempt_disable(); our replacement
>    to preempt_disable() should not become ridiculously costly and also should
>    not serialize the readers among themselves needlessly.
>
>    At a minimum, the new APIs must be extremely fast at the reader side
>    atleast in the fast-path, when no CPU offline writers are active.
>
> 2. preempt_disable() was recursive. The replacement should also be recursive.
>
> 3. No (new) lock-ordering restrictions
>
>    preempt_disable() was super-flexible. It didn't impose any ordering
>    restrictions or rules for nesting. Our replacement should also be equally
>    flexible and usable.
>
> 4. No deadlock possibilities
>
>    Regular per-cpu locking is not the way to go if we want to have relaxed
>    rules for lock-ordering. Because, we can end up in circular-locking
>    dependencies as explained in https://lkml.org/lkml/2012/12/6/290
>
>    So, avoid the usual per-cpu locking schemes (per-cpu locks/per-cpu atomic
>    counters with spin-on-contention etc) as much as possible, to avoid
>    numerous deadlock possibilities from creeping in.
>
>
> Implementation of the design:
> ----------------------------
>
> We use per-CPU reader-writer locks for synchronization because:
>
>   a. They are quite fast and scalable in the fast-path (when no writers are
>      active), since they use fast per-cpu counters in those paths.
>
>   b. They are recursive at the reader side.
>
>   c. They provide a good amount of safety against deadlocks; they don't
>      spring new deadlock possibilities on us from out of nowhere. As a
>      result, they have relaxed locking rules and are quite flexible, and
>      thus are best suited for replacing usages of preempt_disable() or
>      local_irq_disable() at the reader side.
>
> Together, these satisfy all the requirements mentioned above.

Thanks for this detailed design explanation.

> +/*
> + * Invoked by atomic hotplug reader (a task which wants to prevent
> + * CPU offline, but which can't afford to sleep), to prevent CPUs from
> + * going offline. So, you can call this function from atomic contexts
> + * (including interrupt handlers).
> + *
> + * Note: This does NOT prevent CPUs from coming online! It only prevents
> + * CPUs from going offline.
> + *
> + * You can call this function recursively.
> + *
> + * Returns with preemption disabled (but interrupts remain as they are;
> + * they are not disabled).
> + */
> +void get_online_cpus_atomic(void)
> +{
> +       percpu_read_lock_irqsafe(&hotplug_pcpu_rwlock);
> +}
> +EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
> +
> +void put_online_cpus_atomic(void)
> +{
> +       percpu_read_unlock_irqsafe(&hotplug_pcpu_rwlock);
> +}
> +EXPORT_SYMBOL_GPL(put_online_cpus_atomic);

So, you made it clear why you want a recursive read side here.

I am wondering though, if you could take care of recursive uses in
get/put_online_cpus_atomic() instead of doing it as a property of your
rwlock:

get_online_cpus_atomic()
{
    unsigned long flags;
    local_irq_save(flags);
    if (this_cpu_inc_return(hotplug_recusion_count) == 1)
        percpu_read_lock_irqsafe(&hotplug_pcpu_rwlock);
    local_irq_restore(flags);
}

Once again, the idea there is to avoid baking the reader side
recursive properties into your rwlock itself, so that it won't be
impossible to implement reader/writer fairness into your rwlock in the
future (which may be not be very important for the hotplug use, but
could be when other uses get introduced).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
