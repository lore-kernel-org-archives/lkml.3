Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaEHTM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:45447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaEHTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:31 -0400
Date: Thu, 8 May 2014 21:12:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 10/19] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
Message-ID: <20140508191228.GS2844@laptop.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-11-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399474907-22206-11-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:01:38AM -0400, Waiman Long wrote:


No, we want the unfair thing for VIRT, not PARAVIRT.


> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index 9e7659e..10e87e1 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -227,6 +227,14 @@ static __always_inline int get_qlock(struct qspinlock *lock)
>  {
>  	struct __qspinlock *l = (void *)lock;
>  
> +#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
> +	if (static_key_false(&paravirt_unfairlocks_enabled))
> +		/*
> +		 * Need to use atomic operation to get the lock when
> +		 * lock stealing can happen.
> +		 */
> +		return cmpxchg(&l->locked, 0, _Q_LOCKED_VAL) == 0;

That's missing {}.

> +#endif


>  	barrier();
>  	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
>  	barrier();


But no, what you want is:

static __always_inline bool virt_lock(struct qspinlock *lock)
{
#ifdef CONFIG_VIRT_MUCK
	if (static_key_false(&virt_unfairlocks_enabled)) {
		while (!queue_spin_trylock(lock))
			cpu_relax();

		return true;
	}
#else
	return false;
}


void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
{
	if (virt_lock(lock))
		return;

	...
}
