Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaFONNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:13:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaFONM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:12:59 -0400
Date: Sun, 15 Jun 2014 15:12:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
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
Subject: Re: [PATCH v11 06/16] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140615131255.GH11371@laptop.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-7-git-send-email-Waiman.Long@hp.com>
 <20140611102606.GK3213@twins.programming.kicks-ass.net>
 <5398C894.6040808@hp.com>
 <20140612060032.GQ6758@twins.programming.kicks-ass.net>
 <539A139C.50400@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A139C.50400@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:54:52PM -0400, Waiman Long wrote:
> If two tasks see the pending bit goes away and try to grab it with cmpxchg,
> there is no way we can avoid the contention. However, if some how the
> pending bit holder get the lock and another task set the pending bit before
> the current task, the spinlock value will become
> _Q_PENDING_VAL|_Q_LOCKED_VAL. The while loop will end and the code will
> blindly try to do a cmpxchg unless we check for this case before hand. This
> is what my code does by going back to the beginning of the for loop.

There is already a test for that; see the goto queue;

---

	/*
	 * wait for in-progress pending->locked hand-overs
	 *
	 * 0,1,0 -> 0,0,1
	 */
	if (val == _Q_PENDING_VAL) {
		while ((val = atomic_read(&lock->val)) == _Q_PENDING_VAL)
			cpu_relax();
	}

	/*
	 * trylock || pending
	 *
	 * 0,0,0 -> 0,0,1 ; trylock
	 * 0,0,1 -> 0,1,1 ; pending
	 */
	for (;;) {
		/*
		 * If we observe any contention; queue.
		 */
		if (val & ~_Q_LOCKED_MASK)
			goto queue;

		new = _Q_LOCKED_VAL;
		if (val == new)
			new |= _Q_PENDING_VAL;

		old = atomic_cmpxchg(&lock->val, val, new);
		if (old == val)
			break;

		val = old;
	}



