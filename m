Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbaCTWHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:07:20 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:53225 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537AbaCTWHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:07:17 -0400
Message-ID: <532B668A.4010208@redhat.com>
Date: Thu, 20 Mar 2014 23:07:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Alok Kataria <akataria@vmware.com>, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Scott J Norton <scott.norton@hp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 10/11] pvqspinlock, x86: Enable qspinlock PV support
 for KVM
References: <1395260049-30839-1-git-send-email-Waiman.Long@hp.com> <1395260049-30839-11-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1395260049-30839-11-git-send-email-Waiman.Long@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/03/2014 21:14, Waiman Long ha scritto:
> This patch adds the necessary KVM specific code to allow KVM to support
> the sleeping and CPU kicking operations needed by the queue spinlock PV
> code.

The remaining problem of this patch is that you cannot get the 
generically optimal configuration: qspinlock on baremetal, PV qspinlock 
on KVM/Xen, unfair qspinlock on VMware/Hyper-V.  You really need to 
disable unfair locks in kvm_spinlock_init.

Paolo

> The XFS test had moderate spinlock contention of 1.6% whereas the
> ext4 test had heavy spinlock contention of 15.4% as reported by perf.
>
> A more interesting performance comparison is when there is
> overcommit. With both PV guests (all 20 CPUs equally shared with
> both guests - 200% overcommit) turned on and the "idle=poll" kernel
> option to simulate a busy guest. The results of running the same AIM7
> workloads are shown in the table below.
>
>   XFS Test:
>   kernel		 JPM	Real Time   Sys Time	Usr Time
>   -----			 ---	---------   --------	--------
>   PV ticketlock		597015	  29.99      424.44	 25.85
>   qspinlock		117493	 153.20	    1006.06	 59.60
>   PV qspinlock		616438	  29.20	     397.57	 23.31
>   unfair qspinlock	642398	  28.02	     396.42	 25.42
>   unfair + PV qspinlock	633803	  28.40	     400.45	 26.16
>
>   ext4 Test:
>   kernel		 JPM	Real Time   Sys Time	Usr Time
>   -----			 ---	---------   --------	--------
>   PV ticketlock		120984	 148.78     2378.98	 29.27
>   qspinlock		 54995	 327.30	    5023.58	 54.73
>   PV qspinlock		124215	 144.91	    2282.22	 28.89
>   unfair qspinlock	467411	  38.51	     481.80	 25.80
>   unfair + PV qspinlock	471080	  38.21	     482.40	 25.09
>
> The kernel build test (make -j 20) results are as follows:
>
>   kernel		Real Time   Sys Time	Usr Time
>   -----			---------   --------	--------
>   PV ticketlock		20m6.158s   41m7.167s	283m3.790s
>   qspinlock		26m41.294s  74m55.585s	346m31.981s
>   PV qspinlock		20m17.429s  41m19.434s	281m21.238s
>   unfair qspinlock	19m58.315s  40m18.011s	279m27.177s
>   unfair + PV qspinlock	20m0.030s   40m35.011s	278m50.522s
>
> With no overcommit, the PV code doesn't really do anything. The unfair
> lock does provide some performance advantage depending on the workload.
>
> In an overcommited PV guest, however, there can be a big performance
> benefit with PV and unfair lock. In term of spinlock contention,
> the ordering of the 3 workloads are:
>
>     kernel build < AIM7 disk xfs < AIM7 disk ext4
>
> With light spinlock contention, the PV ticketlock can be a bit
> faster than PV qspinlock. On moderate to high spinlock contention,
> PV qspinlock performs better. The unfair lock has the best performance
> in all cases, especially with heavy spinlock contention.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  arch/x86/kernel/kvm.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/Kconfig.locks  |    2 +-
>  2 files changed, 83 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index f318e78..c28bc1b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -568,6 +568,7 @@ static void kvm_kick_cpu(int cpu)
>  	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
>  }
>
> +#ifndef CONFIG_QUEUE_SPINLOCK
>  enum kvm_contention_stat {
>  	TAKEN_SLOW,
>  	TAKEN_SLOW_PICKUP,
> @@ -795,6 +796,82 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
>  		}
>  	}
>  }
> +#else /* !CONFIG_QUEUE_SPINLOCK */
> +
> +#ifdef CONFIG_KVM_DEBUG_FS
> +static struct dentry *d_spin_debug;
> +static struct dentry *d_kvm_debug;
> +static u32 kick_stats;		/* CPU kick count    */
> +static u32 hibernate_stats;	/* Hibernation count */
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
> +	debugfs_create_u32("kick_stats", 0644, d_spin_debug, &kick_stats);
> +	debugfs_create_u32("hibernate_stats",
> +			   0644, d_spin_debug, &hibernate_stats);
> +	return 0;
> +}
> +
> +static inline void inc_kick_stats(void)
> +{
> +	add_smp(&kick_stats, 1);
> +}
> +
> +static inline void inc_hib_stats(void)
> +{
> +	add_smp(&hibernate_stats, 1);
> +}
> +
> +fs_initcall(kvm_spinlock_debugfs);
> +
> +#else /* CONFIG_KVM_DEBUG_FS */
> +static inline void inc_kick_stats(void)
> +{
> +}
> +
> +static inline void inc_hib_stats(void)
> +{
> +
> +}
> +#endif /* CONFIG_KVM_DEBUG_FS */
> +
> +static void kvm_kick_cpu_type(int cpu)
> +{
> +	kvm_kick_cpu(cpu);
> +	inc_kick_stats();
> +}
> +
> +/*
> + * Halt the current CPU & release it back to the host
> + */
> +static void kvm_hibernate(void)
> +{
> +	unsigned long flags;
> +
> +	if (in_nmi())
> +		return;
> +
> +	inc_hib_stats();
> +	/*
> +	 * Make sure an interrupt handler can't upset things in a
> +	 * partially setup state.
> +	 */
> +	local_irq_save(flags);
> +	if (arch_irqs_disabled_flags(flags))
> +		halt();
> +	else
> +		safe_halt();
> +	local_irq_restore(flags);
> +}
> +#endif /* !CONFIG_QUEUE_SPINLOCK */
>
>  /*
>   * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
> @@ -807,8 +884,13 @@ void __init kvm_spinlock_init(void)
>  	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>  		return;
>
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +	pv_lock_ops.kick_cpu = kvm_kick_cpu_type;
> +	pv_lock_ops.hibernate = kvm_hibernate;
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
>

