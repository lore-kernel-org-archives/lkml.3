Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab3FCPzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:55:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37934 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab3FCPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:55:35 -0400
Date: Mon, 3 Jun 2013 11:53:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 8/19]  x86/pvticketlock: When paravirtualizing
 ticket locks, increment by 2
Message-ID: <20130603155341.GC4224@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192402.5966.4600.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601192402.5966.4600.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 12:54:02AM +0530, Raghavendra K T wrote:
> x86/pvticketlock: When paravirtualizing ticket locks, increment by 2
> 
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Increment ticket head/tails by 2 rather than 1 to leave the LSB free
> to store a "is in slowpath state" bit.  This halves the number
> of possible CPUs for a given ticket size, but this shouldn't matter
> in practice - kernels built for 32k+ CPU systems are probably
> specially built for the hardware rather than a generic distro
> kernel.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Tested-by: Attilio Rao <attilio.rao@citrix.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/spinlock.h       |   10 +++++-----
>  arch/x86/include/asm/spinlock_types.h |   10 +++++++++-
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 7442410..04a5cd5 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -78,7 +78,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
>   */
>  static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
>  {
> -	register struct __raw_tickets inc = { .tail = 1 };
> +	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
>  
>  	inc = xadd(&lock->tickets, inc);
>  
> @@ -104,7 +104,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
>  	if (old.tickets.head != old.tickets.tail)
>  		return 0;
>  
> -	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
> +	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
>  
>  	/* cmpxchg is a full barrier, so nothing can move before it */
>  	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
> @@ -112,9 +112,9 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
>  
>  static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
> -	__ticket_t next = lock->tickets.head + 1;
> +	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
>  
> -	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
> +	__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
>  	__ticket_unlock_kick(lock, next);
>  }
>  
> @@ -129,7 +129,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
>  {
>  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
> -	return (__ticket_t)(tmp.tail - tmp.head) > 1;
> +	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
>  }
>  #define arch_spin_is_contended	arch_spin_is_contended
>  
> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
> index 83fd3c7..e96fcbd 100644
> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -3,7 +3,13 @@
>  
>  #include <linux/types.h>
>  
> -#if (CONFIG_NR_CPUS < 256)
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +#define __TICKET_LOCK_INC	2
> +#else
> +#define __TICKET_LOCK_INC	1
> +#endif
> +
> +#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
>  typedef u8  __ticket_t;
>  typedef u16 __ticketpair_t;
>  #else
> @@ -11,6 +17,8 @@ typedef u16 __ticket_t;
>  typedef u32 __ticketpair_t;
>  #endif
>  
> +#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
> +
>  #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
>  
>  typedef struct arch_spinlock {
> 
