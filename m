Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3LQTWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:22:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55543 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3LQTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:22:43 -0500
Date: Tue, 17 Dec 2013 11:22:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 2/4] qrwlock x86: Enable x86 to use queue read/write
 lock
Message-ID: <20131217192236.GB15969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385147087-26588-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121719-1542-0000-0000-0000045995C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:04:45PM -0500, Waiman Long wrote:
> This patch makes the necessary changes at the x86 architecture specific
> layer to enable the presence of the CONFIG_QUEUE_RWLOCK kernel option
> to replace the read/write lock by the queue read/write lock.
> 
> It also enables the CONFIG_QUEUE_RWLOCK option by default for x86 which
> will force the use of queue read/write lock. That will greatly improve
> the fairness of read/write lock and eliminate live-lock situation
> where one task may not get the lock for an indefinite period of time.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/Kconfig                      |    1 +
>  arch/x86/include/asm/spinlock.h       |    2 ++
>  arch/x86/include/asm/spinlock_types.h |    4 ++++
>  3 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e903c71..c4a9c54 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -124,6 +124,7 @@ config X86
>  	select RTC_LIB
>  	select HAVE_DEBUG_STACKOVERFLOW
>  	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
> +	select QUEUE_RWLOCK
> 
>  config INSTRUCTION_DECODER
>  	def_bool y
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index bf156de..8fb88c5 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -188,6 +188,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
>  		cpu_relax();
>  }
> 
> +#ifndef CONFIG_QUEUE_RWLOCK
>  /*
>   * Read-write spinlocks, allowing multiple readers
>   * but only one writer.
> @@ -270,6 +271,7 @@ static inline void arch_write_unlock(arch_rwlock_t *rw)
>  	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
>  		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
>  }
> +#endif /* CONFIG_QUEUE_RWLOCK */
> 
>  #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
>  #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index 4f1bea1..a585635 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -34,6 +34,10 @@ typedef struct arch_spinlock {
> 
>  #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
> 
> +#ifdef CONFIG_QUEUE_RWLOCK
> +#include <asm-generic/qrwlock.h>
> +#else
>  #include <asm/rwlock.h>
> +#endif
> 
>  #endif /* _ASM_X86_SPINLOCK_TYPES_H */
> -- 
> 1.7.1
> 

