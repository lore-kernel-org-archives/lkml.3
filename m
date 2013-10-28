Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3J1Dfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:35:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab3J1Dfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:35:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lglock: Map to spinlock when !CONFIG_SMP
In-Reply-To: <20131025151930.GA9742@leaf>
References: <20131025151930.GA9742@leaf>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 28 Oct 2013 13:29:21 +1030
Message-ID: <87iowigkxi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:
> When the system has only one CPU, lglock is effectively a spinlock; map
> it directly to spinlock to eliminate the indirection and duplicate code.
>
> In addition to removing overhead, this drops 1.6k of code with a defconfig
> modified to have !CONFIG_SMP, and 1.1k with a minimal config.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Nice.  Looks like a patch for Andrew Morton though.

Cheers,
Rusty.

> ---
>  include/linux/lglock.h | 16 ++++++++++++++++
>  kernel/Makefile        |  4 ++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/lglock.h b/include/linux/lglock.h
> index 0d24e93..6561b1c 100644
> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -35,6 +35,8 @@
>  #define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
>  #define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
>  
> +#ifdef CONFIG_SMP
> +
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  #define LOCKDEP_INIT_MAP lockdep_init_map
>  #else
> @@ -67,4 +69,18 @@ void lg_local_unlock_cpu(struct lglock *lg, int cpu);
>  void lg_global_lock(struct lglock *lg);
>  void lg_global_unlock(struct lglock *lg);
>  
> +#else
> +/* When !CONFIG_SMP, map lglock to spinlock */
> +#define lglock spinlock
> +#define DEFINE_LGLOCK(name) DEFINE_SPINLOCK(name)
> +#define DEFINE_STATIC_LGLOCK(name) static DEFINE_SPINLOCK(name)
> +#define lg_lock_init(lg, name) spin_lock_init(lg)
> +#define lg_local_lock spin_lock
> +#define lg_local_unlock spin_unlock
> +#define lg_local_lock_cpu(lg, cpu) spin_lock(lg)
> +#define lg_local_unlock_cpu(lg, cpu) spin_unlock(lg)
> +#define lg_global_lock spin_lock
> +#define lg_global_unlock spin_unlock
> +#endif
> +
>  #endif
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 1ce4755..84a89f7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
>  	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>  	    notifier.o ksysfs.o cred.o reboot.o \
> -	    async.o range.o groups.o lglock.o smpboot.o
> +	    async.o range.o groups.o smpboot.o
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace debug files and internal ftrace files
> @@ -50,7 +50,7 @@ obj-$(CONFIG_SMP) += smp.o
>  ifneq ($(CONFIG_SMP),y)
>  obj-y += up.o
>  endif
> -obj-$(CONFIG_SMP) += spinlock.o
> +obj-$(CONFIG_SMP) += lglock.o spinlock.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
>  obj-$(CONFIG_UID16) += uid16.o
> -- 
> 1.8.4.rc3
