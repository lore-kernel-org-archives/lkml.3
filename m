Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaFJRIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaFJRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:08:40 -0400
Date: Tue, 10 Jun 2014 19:07:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140610170716.GA7629@redhat.com>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com> <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406101051210.3830@nanos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Thomas Gleixner wrote:
>
> +static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
> +	__releases(lock->wait_lock)
> +{
> +	unsigned long owner, *p = (unsigned long *) &lock->owner;
> +
> +	owner = (unsigned long) rt_mutex_owner(lock);
> +	clear_rt_mutex_waiters(lock);
> +	raw_spin_unlock(&lock->wait_lock);
> +	/*
> +	 * If a new waiter comes in between the unlock and the cmpxchg
> +	 * we have two situations:
> +	 *
> +	 * unlock(wait_lock);
> +	 *					lock(wait_lock);
> +	 * cmpxchg(p, owner, 0) == owner
> +	 *					mark_rt_mutex_waiters(lock);
> +	 *					acquire(lock);
> +	 * or:
> +	 *
> +	 * unlock(wait_lock);
> +	 *					lock(wait_lock);
> +	 *					mark_rt_mutex_waiters(lock);
> +	 *
> +	 * cmpxchg(p, owner, 0) != owner
> +	 *					enqueue_waiter();
> +	 *					unlock(wait_lock);
> +	 * lock(wait_lock);
> +	 * wake waiter();
> +	 * unlock(wait_lock);
> +	 *					lock(wait_lock);
> +	 *					acquire(lock);
> +	 */
> +	return rt_mutex_cmpxchg(p, owner, 0);

Wait, but this looks like a typo. rt_mutex_cmpxchg() needs "struct rt_mutex *",
not "long *". It seems that you should simply kill "*p" above.

Oleg.

