Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaFRT3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:29:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45948 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaFRT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:29:00 -0400
Date: Wed, 18 Jun 2014 12:40:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/11] qspinlock: Revert to test-and-set on hypervisors
Message-ID: <20140618164059.GA2390@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.940699466@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130153.940699466@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:47:05PM +0200, Peter Zijlstra wrote:
> When we detect a hypervisor (!paravirt, see later patches), revert to

Please spell out the name of the patches.

> a simple test-and-set lock to avoid the horrors of queue preemption.

Heheh.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/include/asm/qspinlock.h |   14 ++++++++++++++
>  include/asm-generic/qspinlock.h  |    7 +++++++
>  kernel/locking/qspinlock.c       |    3 +++
>  3 files changed, 24 insertions(+)
> 
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_X86_QSPINLOCK_H
>  #define _ASM_X86_QSPINLOCK_H
>  
> +#include <asm/cpufeature.h>
>  #include <asm-generic/qspinlock_types.h>
>  
>  #if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
> @@ -20,6 +21,19 @@ static inline void queue_spin_unlock(str
>  
>  #endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
>  
> +#define virt_queue_spin_lock virt_queue_spin_lock
> +
> +static inline bool virt_queue_spin_lock(struct qspinlock *lock)
> +{
> +	if (!static_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return false;
> +
> +	while (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) != 0)
> +		cpu_relax();
> +
> +	return true;
> +}
> +
>  #include <asm-generic/qspinlock.h>
>  
>  #endif /* _ASM_X86_QSPINLOCK_H */
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -98,6 +98,13 @@ static __always_inline void queue_spin_u
>  }
>  #endif
>  
> +#ifndef virt_queue_spin_lock
> +static __always_inline bool virt_queue_spin_lock(struct qspinlock *lock)
> +{
> +	return false;
> +}
> +#endif
> +
>  /*
>   * Initializier
>   */
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -247,6 +247,9 @@ void queue_spin_lock_slowpath(struct qsp
>  
>  	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
>  
> +	if (virt_queue_spin_lock(lock))
> +		return;
> +
>  	/*
>  	 * wait for in-progress pending->locked hand-overs
>  	 *
> 
> 
