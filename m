Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBSIzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:55:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49775 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaBSIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:55:35 -0500
Date: Wed, 19 Feb 2014 09:55:12 +0100
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
Message-ID: <20140219085512.GI27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
 <20140218073951.GZ27965@twins.programming.kicks-ass.net>
 <5303B6F3.9090001@hp.com>
 <20140218213748.GT14089@laptop.programming.kicks-ass.net>
 <530401C9.4090100@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530401C9.4090100@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 07:58:49PM -0500, Waiman Long wrote:
> On 02/18/2014 04:37 PM, Peter Zijlstra wrote:
> >On Tue, Feb 18, 2014 at 02:39:31PM -0500, Waiman Long wrote:
> >>>>+	/*
> >>>>+	 * At the head of the wait queue now
> >>>>+	 */
> >>>>+	while (true) {
> >>>>+		u32 qcode;
> >>>>+		int retval;
> >>>>+
> >>>>+		retval = queue_get_lock_qcode(lock,&qcode, my_qcode);
> >>>>+		if (retval>   0)
> >>>>+			;	/* Lock not available yet */
> >>>>+		else if (retval<   0)
> >>>>+			/* Lock taken, can release the node&   return */
> >>>>+			goto release_node;
> >>>>+		else if (qcode != my_qcode) {
> >>>>+			/*
> >>>>+			 * Just get the lock with other spinners waiting
> >>>>+			 * in the queue.
> >>>>+			 */
> >>>>+			if (queue_spin_trylock_unfair(lock))
> >>>>+				goto notify_next;
> >>>Why is this an option at all?
> >>>
> >>>
> >>Are you referring to the case (qcode != my_qcode)? This condition will be
> >>true if more than one tasks have queued up.
> >But in no case should we revert to unfair spinning or stealing. We
> >should always respect the queueing order.
> >
> >If the lock tail no longer points to us, then there's further waiters
> >and we should wait for ->next and unlock it -- after we've taken the
> >lock.
> >
> 
> A task will be in this loop when it is already the head of a queue and is
> entitled to take the lock. The condition (qcode != my_qcode) is to decide
> whether it should just take the lock or take the lock & clear the code
> simultaneously. I am a bit cautious to use queue_spin_trylock_unfair() as
> there is a possibility that a CPU may run out of the queue node and need to
> do unfair busy spinning.

No; there is no such possibility. Add BUG_ON(idx>=4) and make sure of
it.

There's simply no more than 4 contexts what can nest at any one time:

  task context
  softirq context
  hardirq context
  nmi context

And someone contending a spinlock from NMI context should be shot
anyway.

Getting more nested spinlocks is an absolute hard fail.
