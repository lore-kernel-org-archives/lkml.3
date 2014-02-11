Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBKPvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:51:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaBKPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:51:21 -0500
Date: Tue, 11 Feb 2014 16:51:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v2] sched: Init idle->on_rq in init_idle()
Message-ID: <20140211155115.GR27965@twins.programming.kicks-ass.net>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
 <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
 <20140207210905.GV5002@laptop.programming.kicks-ass.net>
 <20140211091758.GA19477@linutronix.de>
 <20140211092108.GL27965@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402111534000.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402111534000.21991@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:34:38PM +0100, Thomas Gleixner wrote:
> I could slap myself for not writing a proper changelog right away. It
> took me some time to figure out why it was added in the first place,
> why it's not longer necessary and why I kept it.

:-)

Thanks!

---
Subject: sched: Init idle->on_rq in init_idle()
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 7 Feb 2014 20:58:37 +0100

We stumbled in RT over a SMP bringup issue on ARM where the
idle->on_rq == 0 was causing try_to_wakeup() on the other cpu to run
into nada land.

After adding that idle->on_rq = 1; I was able to find the root cause
of the lockup: the idle task on the newly woken up cpu was fiddling
with a sleeping spinlock, which is a nono.

I kept the init of idle->on_rq to keep the state consistent and to
avoid another long lasting debug session.

As a side note, the whole debug mess could have been avoided if
might_sleep() would have yelled when called from the idle task. That's
fixed with patch 2/6 - and that one actually has a changelog :)

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-2-git-send-email-bigeasy@linutronix.de
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4443,6 +4443,7 @@ void init_idle(struct task_struct *idle,
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
