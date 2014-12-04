Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaLDAKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:10:36 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50350 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaLDAKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:10:34 -0500
Date: Wed, 3 Dec 2014 16:10:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 3/9] x86/spinlock: Replace ACCESS_ONCE with READ_ONCE
Message-ID: <20141204001028.GZ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-4-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417645821-54731-4-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120400-0021-0000-0000-000006A31C53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:30:15PM +0100, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the spinlock code to replace ACCESS_ONCE with READ_ONCE.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/include/asm/spinlock.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 9295016..12a69b4 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -92,7 +92,7 @@ static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  		unsigned count = SPIN_THRESHOLD;
> 
>  		do {
> -			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
> +			if (READ_ONCE(lock->tickets.head) == inc.tail)
>  				goto out;
>  			cpu_relax();
>  		} while (--count);
> @@ -105,7 +105,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
>  {
>  	arch_spinlock_t old, new;
> 
> -	old.tickets = ACCESS_ONCE(lock->tickets);
> +	old.tickets = READ_ONCE(lock->tickets);
>  	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
>  		return 0;
> 
> @@ -162,14 +162,14 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
> 
>  static inline int arch_spin_is_locked(arch_spinlock_t *lock)
>  {
> -	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> +	struct __raw_tickets tmp = READ_ONCE(lock->tickets);
> 
>  	return tmp.tail != tmp.head;
>  }
> 
>  static inline int arch_spin_is_contended(arch_spinlock_t *lock)
>  {
> -	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> +	struct __raw_tickets tmp = READ_ONCE(lock->tickets);
> 
>  	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
>  }
> -- 
> 1.9.3
> 

