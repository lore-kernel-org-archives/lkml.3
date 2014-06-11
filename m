Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFKUaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:30:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFKUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:30:51 -0400
Date: Wed, 11 Jun 2014 13:34:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eyal Perry <eyalpe@mellanox.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: genirq: Provide !SMP stub for irq_set_affinity_notifier()
Message-ID: <20140611203438.GA4035@kroah.com>
References: <20140608185919.57FB46621E2@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608185919.57FB46621E2@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eyal, the commit you reference below isn't anywhere to be found in
Linus's tree.  Why is this commit needed at all if that one isn't there
either?

Confused,

greg k-h


On Sun, Jun 08, 2014 at 06:59:19PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
> Commit:     f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
> Parent:     d6d211db37e75de2ddc3a4f979038c40df7cc79c
> Refname:    refs/heads/master
> Author:     Eyal Perry <eyalpe@mellanox.com>
> AuthorDate: Tue May 20 17:57:00 2014 +0300
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed May 21 11:31:51 2014 +0900
> 
>     genirq: Provide !SMP stub for irq_set_affinity_notifier()
>     
>     Instead of requiring each consumer of the IRQ affinity notifier to have
>     themselves be explicitly dependent on CONFIG_SMP, make the definition of
>     struct irq_affinity_notify to exist independently of that config option
>     and introduce a stub for irq_set_affinity_notifier() under non SMP
>     configuration.
>     
>     Fixes: 2eacc23 ("net/mlx4_core: Enforce irq affinity changes
>     immediatly")
>     
>     Signed-off-by: Eyal Perry <eyalpe@mellanox.com>
>     Signed-off-by: Amir Vadai <amirv@mellanox.com>
>     Cc: Ben Hutchings <bhutchings@solarflare.com>
>     Cc: Yevgeny Petrilin <yevgenyp@mellanox.com>
>     Cc: Or Gerlitz <ogerlitz@mellanox.com>
>     Cc: David S. Miller <davem@davemloft.net>
>     Link: http://lkml.kernel.org/r/1400597820-30685-1-git-send-email-amirv@mellanox.com
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/interrupt.h |   46 +++++++++++++++++++++++++-------------------
>  1 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 97ac926..3f74c05 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -199,6 +199,26 @@ extern int check_wakeup_irqs(void);
>  static inline int check_wakeup_irqs(void) { return 0; }
>  #endif
>  
> +/**
> + * struct irq_affinity_notify - context for notification of IRQ affinity changes
> + * @irq:		Interrupt to which notification applies
> + * @kref:		Reference count, for internal use
> + * @work:		Work item, for internal use
> + * @notify:		Function to be called on change.  This will be
> + *			called in process context.
> + * @release:		Function to be called on release.  This will be
> + *			called in process context.  Once registered, the
> + *			structure must only be freed when this function is
> + *			called or later.
> + */
> +struct irq_affinity_notify {
> +	unsigned int irq;
> +	struct kref kref;
> +	struct work_struct work;
> +	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
> +	void (*release)(struct kref *ref);
> +};
> +
>  #if defined(CONFIG_SMP)
>  
>  extern cpumask_var_t irq_default_affinity;
> @@ -242,26 +262,6 @@ extern int irq_select_affinity(unsigned int irq);
>  
>  extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
>  
> -/**
> - * struct irq_affinity_notify - context for notification of IRQ affinity changes
> - * @irq:		Interrupt to which notification applies
> - * @kref:		Reference count, for internal use
> - * @work:		Work item, for internal use
> - * @notify:		Function to be called on change.  This will be
> - *			called in process context.
> - * @release:		Function to be called on release.  This will be
> - *			called in process context.  Once registered, the
> - *			structure must only be freed when this function is
> - *			called or later.
> - */
> -struct irq_affinity_notify {
> -	unsigned int irq;
> -	struct kref kref;
> -	struct work_struct work;
> -	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
> -	void (*release)(struct kref *ref);
> -};
> -
>  extern int
>  irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
>  
> @@ -284,6 +284,12 @@ static inline int irq_set_affinity_hint(unsigned int irq,
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int
> +irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_SMP */
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
