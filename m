Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaLHSKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:10:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38924 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:10:21 -0500
Date: Mon, 8 Dec 2014 10:10:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
Message-ID: <20141208181013.GA14664@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418054134-28746-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418054134-28746-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120818-0017-0000-0000-000006EDB519
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:55:34AM -0500, Pranith Kumar wrote:
> Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
> is a compile time failure if srcu is used when not enabled. This was decided to
> be better than waiting until link time for a failure to occur.

Queued, but the 0day test robot complained, so I dropped it.  Looking
forward to an updated version.  ;-)

							Thanx, Paul

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/notifier.h | 45 +++++++++++++++++++++++++--------------------
>  include/linux/srcu.h     |  6 +++++-
>  2 files changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/notifier.h b/include/linux/notifier.h
> index d14a4c3..291ecb1 100644
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -70,12 +70,6 @@ struct raw_notifier_head {
>  	struct notifier_block __rcu *head;
>  };
> 
> -struct srcu_notifier_head {
> -	struct mutex mutex;
> -	struct srcu_struct srcu;
> -	struct notifier_block __rcu *head;
> -};
> -
>  #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
>  		spin_lock_init(&(name)->lock);	\
>  		(name)->head = NULL;		\
> @@ -88,11 +82,6 @@ struct srcu_notifier_head {
>  		(name)->head = NULL;		\
>  	} while (0)
> 
> -/* srcu_notifier_heads must be initialized and cleaned up dynamically */
> -extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
> -#define srcu_cleanup_notifier_head(name)	\
> -		cleanup_srcu_struct(&(name)->srcu);
> -
>  #define ATOMIC_NOTIFIER_INIT(name) {				\
>  		.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
>  		.head = NULL }
> @@ -101,7 +90,6 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
>  		.head = NULL }
>  #define RAW_NOTIFIER_INIT(name)	{				\
>  		.head = NULL }
> -/* srcu_notifier_heads cannot be initialized statically */
> 
>  #define ATOMIC_NOTIFIER_HEAD(name)				\
>  	struct atomic_notifier_head name =			\
> @@ -121,8 +109,6 @@ extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
>  		struct notifier_block *nb);
>  extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
>  		struct notifier_block *nb);
> -extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
> -		struct notifier_block *nb);
> 
>  extern int blocking_notifier_chain_cond_register(
>  		struct blocking_notifier_head *nh,
> @@ -134,8 +120,6 @@ extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
>  		struct notifier_block *nb);
>  extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
>  		struct notifier_block *nb);
> -extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
> -		struct notifier_block *nb);
> 
>  extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
>  		unsigned long val, void *v);
> @@ -149,10 +133,6 @@ extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
>  		unsigned long val, void *v);
>  extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
>  	unsigned long val, void *v, int nr_to_call, int *nr_calls);
> -extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
> -		unsigned long val, void *v);
> -extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
> -	unsigned long val, void *v, int nr_to_call, int *nr_calls);
> 
>  #define NOTIFY_DONE		0x0000		/* Don't care */
>  #define NOTIFY_OK		0x0001		/* Suits me */
> @@ -211,5 +191,30 @@ static inline int notifier_to_errno(int ret)
> 
>  extern struct blocking_notifier_head reboot_notifier_list;
> 
> +#ifdef CONFIG_SRCU
> +
> +struct srcu_notifier_head {
> +	struct mutex mutex;
> +	struct srcu_struct srcu;
> +	struct notifier_block __rcu *head;
> +};
> +
> +/* srcu_notifier_heads must be initialized and cleaned up dynamically
> + * srcu_notifier_heads cannot be initialized statically
> + */
> +extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
> +#define srcu_cleanup_notifier_head(name) cleanup_srcu_struct(&(name)->srcu)
> +
> +extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
> +		struct notifier_block *nb);
> +extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
> +		struct notifier_block *nb);
> +extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
> +		unsigned long val, void *v);
> +extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
> +	unsigned long val, void *v, int nr_to_call, int *nr_calls);
> +
> +#endif /* CONFIG_SRCU */
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_NOTIFIER_H */
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 9cfd962..ed9c389 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -26,6 +26,8 @@
>   *
>   */
> 
> +#ifdef CONFIG_SRCU
> +
>  #ifndef _LINUX_SRCU_H
>  #define _LINUX_SRCU_H
> 
> @@ -249,4 +251,6 @@ static inline void smp_mb__after_srcu_read_unlock(void)
>  	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
>  }
> 
> -#endif
> +#endif /* _LINUX_SRCU_H */
> +
> +#endif /* CONFIG_SRCU */
> -- 
> 1.9.1
> 

