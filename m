Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaFPV5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:57:22 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6317 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaFPV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:57:20 -0400
Message-ID: <539F683A.2070103@hp.com>
Date: Mon, 16 Jun 2014 17:57:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: tglx@linutronix.de, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/11] qspinlock: Revert to test-and-set on hypervisors
References: <20140615124657.264658593@chello.nl> <20140615130153.940699466@chello.nl>
In-Reply-To: <20140615130153.940699466@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 08:47 AM, Peter Zijlstra wrote:
> When we detect a hypervisor (!paravirt, see later patches), revert to
> a simple test-and-set lock to avoid the horrors of queue preemption.
>
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> ---
>   arch/x86/include/asm/qspinlock.h |   14 ++++++++++++++
>   include/asm-generic/qspinlock.h  |    7 +++++++
>   kernel/locking/qspinlock.c       |    3 +++
>   3 files changed, 24 insertions(+)
>
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -1,6 +1,7 @@
>   #ifndef _ASM_X86_QSPINLOCK_H
>   #define _ASM_X86_QSPINLOCK_H
>
> +#include<asm/cpufeature.h>
>   #include<asm-generic/qspinlock_types.h>
>
>   #if !defined(CONFIG_X86_OOSTORE)&&  !defined(CONFIG_X86_PPRO_FENCE)
> @@ -20,6 +21,19 @@ static inline void queue_spin_unlock(str
>
>   #endif /* !CONFIG_X86_OOSTORE&&  !CONFIG_X86_PPRO_FENCE */
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
>   #include<asm-generic/qspinlock.h>
>
>   #endif /* _ASM_X86_QSPINLOCK_H */
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -98,6 +98,13 @@ static __always_inline void queue_spin_u
>   }
>   #endif
>
> +#ifndef virt_queue_spin_lock
> +static __always_inline bool virt_queue_spin_lock(struct qspinlock *lock)
> +{
> +	return false;
> +}
> +#endif
> +
>   /*
>    * Initializier
>    */
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -247,6 +247,9 @@ void queue_spin_lock_slowpath(struct qsp
>
>   	BUILD_BUG_ON(CONFIG_NR_CPUS>= (1U<<  _Q_TAIL_CPU_BITS));
>
> +	if (virt_queue_spin_lock(lock))
> +		return;
> +
>   	/*
>   	 * wait for in-progress pending->locked hand-overs
>   	 *

I just wonder if it is better to allow the kernel distributors to decide 
if unfair lock should be the default for virtual guest. Anyway, I have 
no objection to that myself.

-Longman
