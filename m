Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaBRViH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:38:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaBRViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:38:02 -0500
Date: Tue, 18 Feb 2014 22:37:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140218213748.GT14089@laptop.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
 <20140218073951.GZ27965@twins.programming.kicks-ass.net>
 <5303B6F3.9090001@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303B6F3.9090001@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:39:31PM -0500, Waiman Long wrote:
> >>+	/*
> >>+	 * At the head of the wait queue now
> >>+	 */
> >>+	while (true) {
> >>+		u32 qcode;
> >>+		int retval;
> >>+
> >>+		retval = queue_get_lock_qcode(lock,&qcode, my_qcode);
> >>+		if (retval>  0)
> >>+			;	/* Lock not available yet */
> >>+		else if (retval<  0)
> >>+			/* Lock taken, can release the node&  return */
> >>+			goto release_node;
> >>+		else if (qcode != my_qcode) {
> >>+			/*
> >>+			 * Just get the lock with other spinners waiting
> >>+			 * in the queue.
> >>+			 */
> >>+			if (queue_spin_trylock_unfair(lock))
> >>+				goto notify_next;
> >Why is this an option at all?
> >
> >
> 
> Are you referring to the case (qcode != my_qcode)? This condition will be
> true if more than one tasks have queued up.

But in no case should we revert to unfair spinning or stealing. We
should always respect the queueing order.

If the lock tail no longer points to us, then there's further waiters
and we should wait for ->next and unlock it -- after we've taken the
lock.

