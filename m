Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaLAWIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:08:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26079 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbaLAWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:08:48 -0500
Date: Mon, 1 Dec 2014 11:40:35 -0500
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
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v13 09/11] pvqspinlock, x86: Add para-virtualization
 support
Message-ID: <20141201164035.GF3180@laptop.dumpdata.com>
References: <1414613951-32532-1-git-send-email-Waiman.Long@hp.com>
 <1414613951-32532-10-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414613951-32532-10-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:19:09PM -0400, Waiman Long wrote:
> This patch adds para-virtualization support to the queue spinlock
> code base with minimal impact to the native case. There are some
> minor code changes in the generic qspinlock.c file which should be
> usable in other architectures. The other code changes are specific
> to x86 processors and so are all put under the arch/x86 directory.
> 
> On the lock side, the slowpath code is split into 2 separate functions
> generated from the same code - one for bare metal and one for PV guest.
> The switching is done in the _raw_spin_lock* functions. This makes
> sure that the performance impact to the bare metal case is minimal,
> just a few NOPs in the _raw_spin_lock* functions. In the PV slowpath
> code, there are 2 paravirt callee saved calls that minimize register
> pressure.
> 
> On the unlock side, however, the disabling of unlock function inlining
> does have some slight impact on bare metal performance.
> 
> The actual paravirt code comes in 5 parts;
> 
>  - init_node; this initializes the extra data members required for PV
>    state. PV state data is kept 1 cacheline ahead of the regular data.
> 
>  - link_and_wait_node; this replaces the regular MCS queuing code. CPU
>    halting can happen if the wait is too long.
> 
>  - wait_head; this waits until the lock is avialable and the CPU will
>    be halted if the wait is too long.
> 
>  - wait_check; this is called after acquiring the lock to see if the
>    next queue head CPU is halted. If this is the case, the lock bit is
>    changed to indicate the queue head will have to be kicked on unlock.
> 
>  - queue_unlock;  this routine has a jump label to check if paravirt
>    is enabled. If yes, it has to do an atomic cmpxchg to clear the lock
>    bit or call the slowpath function to kick the queue head cpu.
> 
> Tracking the head is done in two parts, firstly the pv_wait_head will
> store its cpu number in whichever node is pointed to by the tail part
> of the lock word. Secondly, pv_link_and_wait_node() will propagate the
> existing head from the old to the new tail node.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  arch/x86/include/asm/paravirt.h       |   19 ++
>  arch/x86/include/asm/paravirt_types.h |   20 ++
>  arch/x86/include/asm/pvqspinlock.h    |  411 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/qspinlock.h      |   71 ++++++-
>  arch/x86/kernel/paravirt-spinlocks.c  |    6 +
>  include/asm-generic/qspinlock.h       |    2 +
>  kernel/locking/qspinlock.c            |   69 +++++-
>  7 files changed, 591 insertions(+), 7 deletions(-)
>  create mode 100644 arch/x86/include/asm/pvqspinlock.h
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index cd6e161..7e296e6 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -712,6 +712,24 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
>  
>  #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
>  
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +
> +static __always_inline void pv_kick_cpu(int cpu)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.kick_cpu, cpu);
> +}
> +
> +static __always_inline void pv_lockwait(u8 *lockbyte)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.lockwait, lockbyte);
> +}
> +
> +static __always_inline void pv_lockstat(enum pv_lock_stats type)
> +{
> +	PVOP_VCALLEE1(pv_lock_ops.lockstat, type);
> +}
> +
> +#else
>  static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
>  							__ticket_t ticket)
>  {
> @@ -723,6 +741,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
>  {
>  	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
>  }
> +#endif
>  
>  #endif
>  
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 7549b8b..49e4b76 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -326,6 +326,9 @@ struct pv_mmu_ops {
>  			   phys_addr_t phys, pgprot_t flags);
>  };
>  
> +struct mcs_spinlock;
> +struct qspinlock;
> +
>  struct arch_spinlock;
>  #ifdef CONFIG_SMP
>  #include <asm/spinlock_types.h>
> @@ -333,9 +336,26 @@ struct arch_spinlock;
>  typedef u16 __ticket_t;
>  #endif
>  
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +enum pv_lock_stats {
> +	PV_HALT_QHEAD,		/* Queue head halting	    */
> +	PV_HALT_QNODE,		/* Other queue node halting */
> +	PV_HALT_ABORT,		/* Halting aborted	    */
> +	PV_WAKE_KICKED,		/* Wakeup by kicking	    */
> +	PV_WAKE_SPURIOUS,	/* Spurious wakeup	    */
> +	PV_KICK_NOHALT		/* Kick but CPU not halted  */
> +};
> +#endif
> +
>  struct pv_lock_ops {
> +#ifdef CONFIG_QUEUE_SPINLOCK
> +	struct paravirt_callee_save kick_cpu;
> +	struct paravirt_callee_save lockstat;
> +	struct paravirt_callee_save lockwait;
> +#else
>  	struct paravirt_callee_save lock_spinning;
>  	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
> +#endif
>  };
>  
>  /* This contains all the paravirt structures: we get a convenient
> diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
> new file mode 100644
> index 0000000..85ccde6
> --- /dev/null
> +++ b/arch/x86/include/asm/pvqspinlock.h
> @@ -0,0 +1,411 @@
> +#ifndef _ASM_X86_PVQSPINLOCK_H
> +#define _ASM_X86_PVQSPINLOCK_H
> +
> +/*
> + *	Queue Spinlock Para-Virtualization (PV) Support
> + *
> + * The PV support code for queue spinlock is roughly the same as that
> + * of the ticket spinlock. Each CPU waiting for the lock will spin until it
> + * reaches a threshold. When that happens, it will put itself to a halt state
> + * so that the hypervisor can reuse the CPU cycles in some other guests as
> + * well as returning other hold-up CPUs faster.

Kind of. There is a lot more of going to sleep here than the PV ticketlock.
In there the CPU would go to sleep and wait until it was its turn in. Here
we need go to sleep when we are at the queue and then wake up to move a bit.

That means the next in the line has at least two halt and wakeups?

How does it compare to the PV ticketlocks that exists right now?
