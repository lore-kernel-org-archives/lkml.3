Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3H3V3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:29:52 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60119 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3H3V3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:29:50 -0400
Message-ID: <1377898155.4629.11.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: IRQ affinity notifiers vs RT
From: Ben Hutchings <bhutchings@solarflare.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1374708683.1732.38.camel@bwh-desktop.uk.level5networks.com>
References: <1374708683.1732.38.camel@bwh-desktop.uk.level5networks.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Aug 2013 22:29:15 +0100
MIME-Version: 1.0
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20114.005
X-TM-AS-Result: No--29.598300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, I saw you came up with a fix for this but apparently without
seeing my earlier message:

On Thu, 2013-07-25 at 00:31 +0100, Ben Hutchings wrote:
> Alexandra Kossovsky reported the following lockdep splat when testing an
> out-of-tree version of sfc on 3.6-rt.  The problem is specific to RT,
> and we haven't tested anything later but I think it's still unfixed.
> 
> > ======================================================
> > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > 3.6.11.2-rt33.39.el6rt.x86_64.debug #1 Tainted: G           O
> > ------------------------------------------------------
> > insmod/3076 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> >  (&(&(&gcwq->lock)->lock)->wait_lock){+.+...}, at: [<ffffffff81589a78>] rt_spin_lock_slowlock+0x48/0x2f0
> > 
> > and this task is already holding:
> >  (&irq_desc_lock_class){-.....}, at: [<ffffffff810ec226>] irq_set_affinity+0x46/0x80
> 
> irq_set_affinity() holds the irq_desc lock, and then schedules a work
> item to call the IRQ affinity notifier.
> 
> > which would create a new lock dependency:
> >  (&irq_desc_lock_class){-.....} -> (&(&(&gcwq->lock)->lock)->wait_lock){+.+...}
> > 
> > but this new dependency connects a HARDIRQ-irq-safe lock:
> >  (&irq_desc_lock_class){-.....}
> > ... which became HARDIRQ-irq-safe at:
> >   [<ffffffff810adba2>] mark_irqflags+0x172/0x190
> >   [<ffffffff810af2c4>] __lock_acquire+0x344/0x4e0
> >   [<ffffffff810af4ea>] lock_acquire+0x8a/0x140
> >   [<ffffffff8158ac50>] _raw_spin_lock+0x40/0x80
> >   [<ffffffff810edfae>] handle_level_irq+0x1e/0x100
> >   [<ffffffff810044e1>] handle_irq+0x71/0x190
> >   [<ffffffff815943ad>] do_IRQ+0x5d/0xe0
> >   [<ffffffff8158b32c>] ret_from_intr+0x0/0x13
> >   [<ffffffff81d16d9d>] tsc_init+0x24/0x102
> >   [<ffffffff81d13d77>] x86_late_time_init+0xf/0x11
> >   [<ffffffff81d10cfe>] start_kernel+0x312/0x3c6
> >   [<ffffffff81d1032d>] x86_64_start_reservations+0x131/0x136
> >   [<ffffffff81d1041f>] x86_64_start_kernel+0xed/0xf4
> 
> Obviously, irq_desc is used in hard-IRQ context.
> 
> > to a HARDIRQ-irq-unsafe lock:
> >  (&(&(&gcwq->lock)->lock)->wait_lock){+.+...}
> > ... which became HARDIRQ-irq-unsafe at:
> > ...  [<ffffffff810adb50>] mark_irqflags+0x120/0x190
> >   [<ffffffff810af2c4>] __lock_acquire+0x344/0x4e0
> >   [<ffffffff810af4ea>] lock_acquire+0x8a/0x140
> >   [<ffffffff8158ac50>] _raw_spin_lock+0x40/0x80
> >   [<ffffffff81589a78>] rt_spin_lock_slowlock+0x48/0x2f0
> >   [<ffffffff8158a1b6>] rt_spin_lock+0x16/0x40
> >   [<ffffffff8106cf99>] create_worker+0x69/0x220
> >   [<ffffffff81d2bae5>] init_workqueues+0x24b/0x3f8
> >   [<ffffffff810001c2>] do_one_initcall+0x42/0x170
> >   [<ffffffff81d10775>] kernel_init+0xe5/0x17a
> >   [<ffffffff81593c24>] kernel_thread_helper+0x4/0x10
> [...]
> 
> Workqueue code uses spin_lock_irq() on the workqueue lock, which with
> PREEMPT_RT enabled doesn't actually block IRQs.
> 
> In 3.6, the irq_cpu_rmap functions relies on a workqueue flush to finish
> any outstanding notifications before freeing the cpu_rmap that they use.
> This won't be reliable if the notification is scheduled after releasing
> the irq_desc lock.
> 
> However, following commit 896f97ea95c1 ('lib: cpu_rmap: avoid flushing
> all workqueues') in 3.8, I think that it is sufficient to do only
> kref_get(&desc->affinity_notify->kref) in __irq_set_affinity_locked()
> and then call schedule_work() in irq_set_affinity() after releasing the
> lock.  Something like this (untested):

Does the following make sense to you?

Ben.

> diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
> index 9d36774..0406481 100644
> --- a/arch/mips/cavium-octeon/octeon-irq.c
> +++ b/arch/mips/cavium-octeon/octeon-irq.c
> @@ -635,7 +635,8 @@ static void octeon_irq_cpu_offline_ciu(struct irq_data *data)
>  		cpumask_clear(&new_affinity);
>  		cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
>  	}
> -	__irq_set_affinity_locked(data, &new_affinity);
> +	/* XXX No-one else calls this; why does this chip need it? */
> +	__irq_set_affinity_locked(data, &new_affinity, NULL);
>  }
>  
>  static int octeon_irq_ciu_set_affinity(struct irq_data *data,
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index f04d3ba..de992f4 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -380,7 +380,9 @@ extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
>  
>  extern void irq_cpu_online(void);
>  extern void irq_cpu_offline(void);
> -extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
> +extern int __irq_set_affinity_locked(struct irq_data *data,
> +				     const struct cpumask *cpumask,
> +				     struct irq_affinity_notify **notify);
>  
>  #ifdef CONFIG_GENERIC_HARDIRQS
>  
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..157afa2 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -162,12 +162,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  	return ret;
>  }
>  
> -int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
> +int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
> +			      struct irq_affinity_notify **notify)
>  {
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
>  	struct irq_desc *desc = irq_data_to_desc(data);
>  	int ret = 0;
>  
> +	if (notify)
> +		*notify = NULL;
> +
>  	if (!chip || !chip->irq_set_affinity)
>  		return -EINVAL;
>  
> @@ -178,9 +182,9 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
>  		irq_copy_pending(desc, mask);
>  	}
>  
> -	if (desc->affinity_notify) {
> +	if (notify && desc->affinity_notify) {
>  		kref_get(&desc->affinity_notify->kref);
> -		schedule_work(&desc->affinity_notify->work);
> +		*notify = desc->affinity_notify;
>  	}
>  	irqd_set(data, IRQD_AFFINITY_SET);
>  
> @@ -196,6 +200,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
>  int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
> +	struct irq_affinity_notify *notify;
>  	unsigned long flags;
>  	int ret;
>  
> @@ -203,8 +208,13 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
>  		return -EINVAL;
>  
>  	raw_spin_lock_irqsave(&desc->lock, flags);
> -	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
> +	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask,
> +					 &notify);
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +
> +	if (notify)
> +		schedule_work(&notify->work);
> +
>  	return ret;
>  }
>  
> --- END ---
> 
> Ben.
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

