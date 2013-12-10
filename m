Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3LJQp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab3LJQp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:45:27 -0500
Date: Tue, 10 Dec 2013 17:44:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v5 tip/core/locking 5/7]
	Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Message-ID: <20131210164436.GA23506@redhat.com>
References: <20131210012738.GA24317@linux.vnet.ibm.com> <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com> <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Paul E. McKenney wrote:
>
> @@ -1626,7 +1626,10 @@ for each construct.  These operations all imply certain barriers:
>       operation has completed.
>
>       Memory operations issued before the LOCK may be completed after the LOCK
> -     operation has completed.
> +     operation has completed.  An smp_mb__before_spinlock(), combined
> +     with a following LOCK, acts as an smp_wmb().  Note the "w",
> +     this is smp_wmb(), not smp_mb().

Well, but smp_mb__before_spinlock + LOCK is not wmb... But it is not
the full barrier. It should guarantee that, say,

	CONDITION = true;		// 1

	// try_to_wake_up
	smp_mb__before_spinlock();
	spin_lock(&task->pi_lock);

	if (!(p->state & state))	// 2
		return;		

can't race with with set_current_state() + check(CONDITION), this means
that 1 and 2 above must not be reordered.

But a LOAD before before spin_lock() can leak into the critical section.

Perhaps this should be clarified somehow, or perhaps it should actually
imply mb (if combined with LOCK).

Oleg

