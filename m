Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3LJRcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab3LJRco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:32:44 -0500
Date: Tue, 10 Dec 2013 18:32:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 tip/core/locking 6/7] locking: Add an
	smp_mb__after_unlock_lock() for UNLOCK+LOCK barrier
Message-ID: <20131210173250.GA25934@redhat.com>
References: <20131210012738.GA24317@linux.vnet.ibm.com> <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com> <1386638883-25379-6-git-send-email-paulmck@linux.vnet.ibm.com> <20131210170404.GB23506@redhat.com> <20131210171859.GT4208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210171859.GT4208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Paul E. McKenney wrote:
>
> On Tue, Dec 10, 2013 at 06:04:04PM +0100, Oleg Nesterov wrote:
> >
> > I am wondering, perhaps smp_mb__after_unlock() makes more sense?
> >
> > Note that it already has the potential user:
> >
> > 	--- x/kernel/sched/wait.c
> > 	+++ x/kernel/sched/wait.c
> > 	@@ -176,8 +176,9 @@ prepare_to_wait(wait_queue_head_t *q, wa
> > 		spin_lock_irqsave(&q->lock, flags);
> > 		if (list_empty(&wait->task_list))
> > 			__add_wait_queue(q, wait);
> > 	-	set_current_state(state);
> > 	+	__set_current_state(state);
> > 		spin_unlock_irqrestore(&q->lock, flags);
> > 	+	smp_mb__after_unlock();
> > 	 }
> > 	 EXPORT_SYMBOL(prepare_to_wait);
> >
> > 	@@ -190,8 +191,9 @@ prepare_to_wait_exclusive(wait_queue_hea
> > 		spin_lock_irqsave(&q->lock, flags);
> > 		if (list_empty(&wait->task_list))
> > 			__add_wait_queue_tail(q, wait);
> > 	-	set_current_state(state);
> > 	+	__set_current_state(state);
> > 		spin_unlock_irqrestore(&q->lock, flags);
> > 	+	smp_mb__after_unlock();
> > 	 }
> > 	 EXPORT_SYMBOL(prepare_to_wait_exclusive);
> >
> >
> > Assuming it can also be used "later", after another LOCK, like in
> > your example in 5/7.
>
> I am fine either way.  But there was an objection to tying this to the
> unlock because it costs more on many architectures than tying this to
> the lock.

OK, I see, thanks.

> But if you are saying "in addition to" rather than "instead of" that
> would be a different conversation.

Yes, please forget for now.

Oleg.

