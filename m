Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaLIUMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:12:21 -0500
Received: from mail.efficios.com ([78.47.125.74]:58228 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaLIUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:12:20 -0500
Date: Tue, 9 Dec 2014 20:12:20 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <1556651722.25314.1418155940330.JavaMail.zimbra@efficios.com>
In-Reply-To: <1418150903-15760-1-git-send-email-bobby.prani@gmail.com>
References: <1418150903-15760-1-git-send-email-bobby.prani@gmail.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.22.116]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF33 (Linux)/8.0.7_GA_6021)
Thread-Topic: srcu: Isolate srcu sections using CONFIG_SRCU
Thread-Index: 1BhY29EYrf7Au6Jlt9hLFhDt/F7o9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Pranith Kumar" <bobby.prani@gmail.com>
> To: "Martin Schwidefsky" <schwidefsky@de.ibm.com>, "Heiko Carstens" <heiko.carstens@de.ibm.com>, "supporter:S390"
> <linux390@de.ibm.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
> "Josh Triplett" <josh@joshtriplett.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Mathieu Desnoyers"
> <mathieu.desnoyers@efficios.com>, "Christian Borntraeger" <borntraeger@de.ibm.com>, "Jens Freimann"
> <jfrei@linux.vnet.ibm.com>, "open list:S390" <linux-s390@vger.kernel.org>, "open list"
> <linux-kernel@vger.kernel.org>
> Sent: Tuesday, December 9, 2014 1:48:21 PM
> Subject: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
> 
> Isolate the SRCU functions and data structures within CONFIG_SRCU so that
> there
> is a compile time failure if srcu is used when not enabled. This was decided
> to
> be better than waiting until link time for a failure to occur.
> 
> Also make including kvm_host.h conditional on CONFIG_KVM being enabled. This
> prevents build failures as KVM is dependent on SRCU.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  arch/s390/kernel/asm-offsets.c |  7 ++++++-
>  include/linux/notifier.h       | 47
>  ++++++++++++++++++++++++------------------
>  include/linux/srcu.h           |  6 +++++-
>  3 files changed, 38 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
> index ef279a1..2813a3c 100644
> --- a/arch/s390/kernel/asm-offsets.c
> +++ b/arch/s390/kernel/asm-offsets.c
> @@ -7,12 +7,15 @@
>  #define ASM_OFFSETS_C
>  
>  #include <linux/kbuild.h>
> -#include <linux/kvm_host.h>
>  #include <linux/sched.h>
>  #include <asm/idle.h>
>  #include <asm/vdso.h>
>  #include <asm/pgtable.h>
>  
> +#if IS_ENABLED(CONFIG_KVM)
> +#include <linux/kvm_host.h>
> +#endif
> +

Seeing this kind of conditional include makes me cringe. Is there some
way to hide this within linux/kvm_host.h instead ?

Thanks,

Mathieu

>  /*
>   * Make sure that the compiler is new enough. We want a compiler that
>   * is known to work with the "Q" assembler constraint.
> @@ -182,8 +185,10 @@ int main(void)
>  	DEFINE(__LC_PGM_TDB, offsetof(struct _lowcore, pgm_tdb));
>  	DEFINE(__THREAD_trap_tdb, offsetof(struct task_struct, thread.trap_tdb));
>  	DEFINE(__GMAP_ASCE, offsetof(struct gmap, asce));
> +#if IS_ENABLED(CONFIG_KVM)
>  	DEFINE(__SIE_PROG0C, offsetof(struct kvm_s390_sie_block, prog0c));
>  	DEFINE(__SIE_PROG20, offsetof(struct kvm_s390_sie_block, prog20));
> +#endif /* CONFIG_KVM */
>  #endif /* CONFIG_32BIT */
>  	return 0;
>  }
> diff --git a/include/linux/notifier.h b/include/linux/notifier.h
> index d14a4c3..fe4f02a 100644
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -47,6 +47,8 @@
>   * runtime initialization.
>   */
>  
> +struct notifier_block;
> +
>  typedef	int (*notifier_fn_t)(struct notifier_block *nb,
>  			unsigned long action, void *data);
>  
> @@ -70,12 +72,6 @@ struct raw_notifier_head {
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
> @@ -88,11 +84,6 @@ struct srcu_notifier_head {
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
> @@ -101,7 +92,6 @@ extern void srcu_init_notifier_head(struct
> srcu_notifier_head *nh);
>  		.head = NULL }
>  #define RAW_NOTIFIER_INIT(name)	{				\
>  		.head = NULL }
> -/* srcu_notifier_heads cannot be initialized statically */
>  
>  #define ATOMIC_NOTIFIER_HEAD(name)				\
>  	struct atomic_notifier_head name =			\
> @@ -121,8 +111,6 @@ extern int blocking_notifier_chain_register(struct
> blocking_notifier_head *nh,
>  		struct notifier_block *nb);
>  extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
>  		struct notifier_block *nb);
> -extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
> -		struct notifier_block *nb);
>  
>  extern int blocking_notifier_chain_cond_register(
>  		struct blocking_notifier_head *nh,
> @@ -134,8 +122,6 @@ extern int blocking_notifier_chain_unregister(struct
> blocking_notifier_head *nh,
>  		struct notifier_block *nb);
>  extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
>  		struct notifier_block *nb);
> -extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
> -		struct notifier_block *nb);
>  
>  extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
>  		unsigned long val, void *v);
> @@ -149,10 +135,6 @@ extern int raw_notifier_call_chain(struct
> raw_notifier_head *nh,
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
> @@ -211,5 +193,30 @@ static inline int notifier_to_errno(int ret)
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
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
