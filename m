Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaEGTIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:08:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29368 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaEGTIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:08:11 -0400
Date: Wed, 7 May 2014 15:07:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 18/19] pvqspinlock, x86: Enable PV qspinlock PV for
 KVM
Message-ID: <20140507190706.GA16333@phenom.dumpdata.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-19-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399474907-22206-19-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Raghavendra KT had done some performance testing on this patch with
> the following results:
> 
> Overall we are seeing good improvement for pv-unfair version.
> 
> System: 32 cpu sandybridge with HT on (4 node with 32 GB each)
> Guest : 8GB with 16 vcpu/VM.
> Average was taken over 8-10 data points.
> 
> Base = 3.15-rc2  with PRAVIRT_SPINLOCK = y
> 
> A = 3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y
> PRAVIRT_SPINLOCK = y PARAVIRT_UNFAIR_LOCKS = y (unfair lock)
> 
> B =  3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y
> PRAVIRT_SPINLOCK = n PARAVIRT_UNFAIR_LOCKS = n
> (queue spinlock without paravirt)
> 
> C = 3.15-rc2 + qspinlock v9 patch with  QUEUE_SPINLOCK = y
> PRAVIRT_SPINLOCK = y  PARAVIRT_UNFAIR_LOCKS = n
> (queue spinlock with paravirt)

Could you do s/PRAVIRT/PARAVIRT/ please?

> 
> Ebizzy %improvements
> ====================
> overcommit  A            B            C
> 0.5x     4.4265        2.0611       1.5824
> 1.0x     0.9015       -7.7828       4.5443
> 1.5x    46.1162       -2.9845      -3.5046
> 2.0x    99.8150       -2.7116       4.7461

Considering B sucks
> 
> Dbench %improvements
> ====================
> overcommit  A            B            C
> 0.5x     3.2617        3.5436        2.5676
> 1.0x     0.6302        2.2342        5.2201
> 1.5x     5.0027        4.8275        3.8375
> 2.0x    23.8242        4.5782        12.6067
> 
> Absolute values of base results: (overcommit, value, stdev)
> Ebizzy ( records / sec with 120 sec run)
> 0.5x 20941.8750 (2%)
> 1.0x 17623.8750 (5%)
> 1.5x  5874.7778 (15%)
> 2.0x  3581.8750 (7%)
> 
> Dbench (throughput in MB/sec)
> 0.5x 10009.6610 (5%)
> 1.0x  6583.0538 (1%)
> 1.5x  3991.9622 (4%)
> 2.0x  2527.0613 (2.5%)
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Tested-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/kvm.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/Kconfig.locks  |    2 +-
>  2 files changed, 136 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 7ab8ab3..eef427b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -567,6 +567,7 @@ static void kvm_kick_cpu(int cpu)
>  	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
>  }
>  
> +#ifndef CONFIG_QUEUE_SPINLOCK
>  enum kvm_contention_stat {
>  	TAKEN_SLOW,
>  	TAKEN_SLOW_PICKUP,
> @@ -794,6 +795,134 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
>  		}
>  	}
>  }
> +#else /* !CONFIG_QUEUE_SPINLOCK */
> +
> +#ifdef CONFIG_KVM_DEBUG_FS
> +static struct dentry *d_spin_debug;
> +static struct dentry *d_kvm_debug;
> +static u32 kick_nohlt_stats;	/* Kick but not halt count	*/
> +static u32 halt_qhead_stats;	/* Queue head halting count	*/
> +static u32 halt_qnode_stats;	/* Queue node halting count	*/
> +static u32 halt_abort_stats;	/* Halting abort count		*/
> +static u32 wake_kick_stats;	/* Wakeup by kicking count	*/
> +static u32 wake_spur_stats;	/* Spurious wakeup count	*/
> +static u64 time_blocked;	/* Total blocking time		*/
> +
> +static int __init kvm_spinlock_debugfs(void)
> +{
> +	d_kvm_debug = debugfs_create_dir("kvm-guest", NULL);
> +	if (!d_kvm_debug) {
> +		printk(KERN_WARNING
> +		       "Could not create 'kvm' debugfs directory\n");
> +		return -ENOMEM;
> +	}
> +	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm_debug);
> +
> +	debugfs_create_u32("kick_nohlt_stats",
> +			   0644, d_spin_debug, &kick_nohlt_stats);
> +	debugfs_create_u32("halt_qhead_stats",
> +			   0644, d_spin_debug, &halt_qhead_stats);
> +	debugfs_create_u32("halt_qnode_stats",
> +			   0644, d_spin_debug, &halt_qnode_stats);
> +	debugfs_create_u32("halt_abort_stats",
> +			   0644, d_spin_debug, &halt_abort_stats);
> +	debugfs_create_u32("wake_kick_stats",
> +			   0644, d_spin_debug, &wake_kick_stats);
> +	debugfs_create_u32("wake_spur_stats",
> +			   0644, d_spin_debug, &wake_spur_stats);
> +	debugfs_create_u64("time_blocked",
> +			   0644, d_spin_debug, &time_blocked);
> +	return 0;
> +}
> +
> +static inline void kvm_halt_stats(enum pv_lock_stats type)
> +{
> +	if (type == PV_HALT_QHEAD)
> +		add_smp(&halt_qhead_stats, 1);
> +	else if (type == PV_HALT_QNODE)
> +		add_smp(&halt_qnode_stats, 1);
> +	else /* type == PV_HALT_ABORT */
> +		add_smp(&halt_abort_stats, 1);
> +}
> +
> +static inline void kvm_lock_stats(enum pv_lock_stats type)
> +{
> +	if (type == PV_WAKE_KICKED)
> +		add_smp(&wake_kick_stats, 1);
> +	else if (type == PV_WAKE_SPURIOUS)
> +		add_smp(&wake_spur_stats, 1);
> +	else /* type == PV_KICK_NOHALT */
> +		add_smp(&kick_nohlt_stats, 1);
> +}
> +
> +static inline u64 spin_time_start(void)
> +{
> +	return sched_clock();
> +}
> +
> +static inline void spin_time_accum_blocked(u64 start)
> +{
> +	u64 delta;
> +
> +	delta = sched_clock() - start;
> +	add_smp(&time_blocked, delta);
> +}
> +
> +fs_initcall(kvm_spinlock_debugfs);
> +
> +#else /* CONFIG_KVM_DEBUG_FS */
> +static inline void kvm_halt_stats(enum pv_lock_stats type)
> +{
> +}
> +
> +static inline void kvm_lock_stats(enum pv_lock_stats type)
> +{
> +}
> +
> +static inline u64 spin_time_start(void)
> +{
> +	return 0;
> +}
> +
> +static inline void spin_time_accum_blocked(u64 start)
> +{
> +}
> +#endif /* CONFIG_KVM_DEBUG_FS */
> +
> +/*
> + * Halt the current CPU & release it back to the host
> + */
> +static void kvm_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
> +{
> +	unsigned long flags;
> +	u64 start;
> +
> +	if (in_nmi())
> +		return;
> +
> +	/*
> +	 * Make sure an interrupt handler can't upset things in a
> +	 * partially setup state.
> +	 */
> +	local_irq_save(flags);
> +	/*
> +	 * Don't halt if the CPU state has been changed.
> +	 */
> +	if (ACCESS_ONCE(*state) != sval) {
> +		kvm_halt_stats(PV_HALT_ABORT);
> +		goto out;
> +	}
> +	start = spin_time_start();
> +	kvm_halt_stats(type);
> +	if (arch_irqs_disabled_flags(flags))
> +		halt();
> +	else
> +		safe_halt();
> +	spin_time_accum_blocked(start);
> +out:
> +	local_irq_restore(flags);
> +}
> +#endif /* !CONFIG_QUEUE_SPINLOCK */
>  
>  /*
>   * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
> @@ -806,8 +935,14 @@ void __init kvm_spinlock_init(void)
>  	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>  		return;
>  
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +	pv_lock_ops.kick_cpu = kvm_kick_cpu;
> +	pv_lock_ops.halt_cpu = kvm_halt_cpu;
> +	pv_lock_ops.lockstat = kvm_lock_stats;
> +#else
>  	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
>  	pv_lock_ops.unlock_kick = kvm_unlock_kick;
> +#endif
>  }
>  
>  static __init int kvm_spinlock_init_jump(void)
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index f185584..a70fdeb 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -229,4 +229,4 @@ config ARCH_USE_QUEUE_SPINLOCK
>  
>  config QUEUE_SPINLOCK
>  	def_bool y if ARCH_USE_QUEUE_SPINLOCK
> -	depends on SMP && !PARAVIRT_SPINLOCKS
> +	depends on SMP && (!PARAVIRT_SPINLOCKS || !XEN)
> -- 
> 1.7.1
> 
