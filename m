Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3JXU7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:59:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:16139 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab3JXU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:58:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="424323948"
Subject: Re: [PATCH v8 10/10] MCS Lock: Make mcs_spinlock.h includable in
 other files
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>
In-Reply-To: <1382644912-16458-1-git-send-email-Waiman.Long@hp.com>
References: <1382644912-16458-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Oct 2013 13:58:35 -0700
Message-ID: <1382648315.11046.224.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 16:01 -0400, Waiman Long wrote:
> The following changes are made to enable mcs_spinlock.h file to be
> widely included in other files without causing problem:
> 
> 1) Include a number of prerequisite header files and define
>    arch_mutex_cpu_relax(), if not previously defined.
> 2) Separate out mcs_spin_lock() into a mcs_spinlock.c file.
> 3) Make mcs_spin_unlock() an inlined function.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  include/linux/mcs_spinlock.h |   43 ++++++++++++++++-------------------------
>  kernel/Makefile              |    6 ++--
>  kernel/mcs_spinlock.c        |   37 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+), 29 deletions(-)
>  create mode 100644 kernel/mcs_spinlock.c
> 
> diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
> index b5de3b0..62979f3 100644
> --- a/include/linux/mcs_spinlock.h
> +++ b/include/linux/mcs_spinlock.h
> @@ -12,38 +12,29 @@
>  #ifndef __LINUX_MCS_SPINLOCK_H
>  #define __LINUX_MCS_SPINLOCK_H
>  
> +/*
> + * asm/processor.h may define arch_mutex_cpu_relax().
> + * If it is not defined, cpu_relax() will be used.
> + */
> +#include <asm/barrier.h>
> +#include <asm/cmpxchg.h>
> +#include <asm/processor.h>
> +#include <linux/compiler.h>
> +
> +#ifndef arch_mutex_cpu_relax
> +# define arch_mutex_cpu_relax() cpu_relax()
> +#endif
> +
>  struct mcs_spinlock {
>  	struct mcs_spinlock *next;
>  	int locked; /* 1 if lock acquired */
>  };
>  
> -/*
> - * We don't inline mcs_spin_lock() so that perf can correctly account for the
> - * time spent in this lock function.
> - */
> -static noinline
> -void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> -{
> -	struct mcs_spinlock *prev;
> -
> -	/* Init node */
> -	node->locked = 0;
> -	node->next   = NULL;
> -
> -	prev = xchg(lock, node);
> -	if (likely(prev == NULL)) {
> -		/* Lock acquired */
> -		node->locked = 1;
> -		return;
> -	}
> -	ACCESS_ONCE(prev->next) = node;
> -	smp_wmb();
> -	/* Wait until the lock holder passes the lock down */
> -	while (!ACCESS_ONCE(node->locked))
> -		arch_mutex_cpu_relax();
> -}
> +extern
> +void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
>  
> -static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> +static inline
> +void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  {
>  	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
>  

Do we want to inline the unlock?  Will that prevent proper profile 
accounting of unlock overhead?  

Can we keep the mcs_spin_unlock and mcs_spin_lock in the same
kernel/mcs_spinlock.c file? That makes it easier to read and 
maintain the code.

> diff --git a/kernel/Makefile b/kernel/Makefile
> index 1ce4755..2ad8454 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -50,9 +50,9 @@ obj-$(CONFIG_SMP) += smp.o
>  ifneq ($(CONFIG_SMP),y)
>  obj-y += up.o
>  endif
> -obj-$(CONFIG_SMP) += spinlock.o
> -obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
> -obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
> +obj-$(CONFIG_SMP) += spinlock.o mcs_spinlock.o
> +obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o mcs_spinlock.o
> +obj-$(CONFIG_PROVE_LOCKING) += spinlock.o mcs_spinlock.o
>  obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_MODULES) += module.o
>  obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
> diff --git a/kernel/mcs_spinlock.c b/kernel/mcs_spinlock.c
> new file mode 100644
> index 0000000..6b20324
> --- /dev/null
> +++ b/kernel/mcs_spinlock.c
> @@ -0,0 +1,37 @@
> +/*
> + * MCS lock
> + *
> + * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
> + * with the desirable properties of being fair, and with each cpu trying
> + * to acquire the lock spinning on a local variable.
> + * It avoids expensive cache bouncings that common test-and-set spin-lock
> + * implementations incur.
> + */
> +#include <linux/mcs_spinlock.h>
> +#include <linux/export.h>
> +
> +/*
> + * We don't inline mcs_spin_lock() so that perf can correctly account for the
> + * time spent in this lock function.
> + */
> +void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> +{
> +	struct mcs_spinlock *prev;
> +
> +	/* Init node */
> +	node->locked = 0;
> +	node->next   = NULL;
> +
> +	prev = xchg(lock, node);
> +	if (likely(prev == NULL)) {
> +		/* Lock acquired */
> +		node->locked = 1;
> +		return;
> +	}
> +	ACCESS_ONCE(prev->next) = node;
> +	smp_wmb();
> +	/* Wait until the lock holder passes the lock down */
> +	while (!ACCESS_ONCE(node->locked))
> +		arch_mutex_cpu_relax();
> +}
> +EXPORT_SYMBOL(mcs_spin_lock);

Can you check if you have applied all the previous MCS patches?
The last two for barrier corrections and optimizations seem
to be missing.

MCS Lock: optimizations and extra comments
https://lkml.org/lkml/2013/10/2/644
MCS Lock: Barrier corrections
https://lkml.org/lkml/2013/10/2/650

Thanks.

Tim

