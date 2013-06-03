Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3FCPc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:32:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3FCPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:32:56 -0400
Date: Mon, 3 Jun 2013 11:28:37 -0400
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
Subject: Re: [PATCH RFC V9 3/19]  x86/ticketlock: Collapse a layer of
 functions
Message-ID: <20130603152837.GB4224@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192229.5966.49935.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601192229.5966.49935.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 12:52:29AM +0530, Raghavendra K T wrote:
> x86/ticketlock: Collapse a layer of functions
> 
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Now that the paravirtualization layer doesn't exist at the spinlock
> level any more, we can collapse the __ticket_ functions into the arch_
> functions.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Tested-by: Attilio Rao <attilio.rao@citrix.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/spinlock.h |   35 +++++------------------------------
>  1 file changed, 5 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 4d54244..7442410 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -76,7 +76,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
>   * in the high part, because a wide xadd increment of the low part would carry
>   * up and contaminate the high part.
>   */
> -static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
> +static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
>  {
>  	register struct __raw_tickets inc = { .tail = 1 };
>  
> @@ -96,7 +96,7 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
>  out:	barrier();	/* make sure nothing creeps before the lock is taken */
>  }
>  
> -static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> +static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
>  {
>  	arch_spinlock_t old, new;
>  
> @@ -110,7 +110,7 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>  	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
>  }
>  
> -static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> +static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
>  	__ticket_t next = lock->tickets.head + 1;
>  
> @@ -118,46 +118,21 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  	__ticket_unlock_kick(lock, next);
>  }
>  
> -static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
> +static inline int arch_spin_is_locked(arch_spinlock_t *lock)
>  {
>  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
>  	return tmp.tail != tmp.head;
>  }
>  
> -static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
> +static inline int arch_spin_is_contended(arch_spinlock_t *lock)
>  {
>  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
>  	return (__ticket_t)(tmp.tail - tmp.head) > 1;
>  }
> -
> -static inline int arch_spin_is_locked(arch_spinlock_t *lock)
> -{
> -	return __ticket_spin_is_locked(lock);
> -}
> -
> -static inline int arch_spin_is_contended(arch_spinlock_t *lock)
> -{
> -	return __ticket_spin_is_contended(lock);
> -}
>  #define arch_spin_is_contended	arch_spin_is_contended
>  
> -static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
> -{
> -	__ticket_spin_lock(lock);
> -}
> -
> -static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
> -{
> -	return __ticket_spin_trylock(lock);
> -}
> -
> -static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
> -{
> -	__ticket_spin_unlock(lock);
> -}
> -
>  static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
>  						  unsigned long flags)
>  {
> 
