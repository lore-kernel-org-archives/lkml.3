Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaEHTHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:07:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbaEHTHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:07:03 -0400
Date: Thu, 8 May 2014 21:06:49 +0200
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
Subject: Re: [PATCH v10 09/19] qspinlock: Prepare for unfair lock support
Message-ID: <20140508190649.GR2844@laptop.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-10-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399474907-22206-10-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:01:37AM -0400, Waiman Long wrote:
> If unfair lock is supported, the lock acquisition loop at the end of
> the queue_spin_lock_slowpath() function may need to detect the fact
> the lock can be stolen. Code are added for the stolen lock detection.
> 
> A new qhead macro is also defined as a shorthand for mcs.locked.

NAK, unfair should be a pure test-and-set lock.

>  /**
>   * get_qlock - Set the lock bit and own the lock
> - * @lock: Pointer to queue spinlock structure
> + * @lock : Pointer to queue spinlock structure
> + * Return: 1 if lock acquired, 0 otherwise
>   *
>   * This routine should only be called when the caller is the only one
>   * entitled to acquire the lock.
>   */
> -static __always_inline void get_qlock(struct qspinlock *lock)
> +static __always_inline int get_qlock(struct qspinlock *lock)
>  {
>  	struct __qspinlock *l = (void *)lock;
>  
>  	barrier();
>  	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
>  	barrier();
> +	return 1;
>  }

and here you make a horribly named function more horrible;
try_set_locked() is that its now.
