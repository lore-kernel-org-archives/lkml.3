Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3BEEBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:01:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3BEEBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:01:14 -0500
Date: Mon, 4 Feb 2013 20:04:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
Message-Id: <20130204200459.f2a0a1cc.akpm@linux-foundation.org>
In-Reply-To: <1360032122.27007.4.camel@gandalf.local.home>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	<20130204172001.8bb358b0.akpm@linux-foundation.org>
	<CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
	<20130204180948.68c206c0.akpm@linux-foundation.org>
	<1360032122.27007.4.camel@gandalf.local.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2013 21:42:02 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2013-02-04 at 18:09 -0800, Andrew Morton wrote:
> 
> > I don't think so.  Conceptually printk() should be "inner" to the
> > scheduler and shouldn't call into sched things at all.  The (afaik
> > sole) exception to that was the klogd wakeup.
> > 
> > Traditionally the deadlock happened when calling printk() with
> > tasklist_lock (now q->lock) held.  printk() would call wake_up(klogd)
> > and wake_up() tries to take tasklist_lock and boom.  Moving the
> > wake_up() out to the tick "thread" fixed that.
> > 
> > Maybe there were other deadlock scenarios, dunno.  That knowledge
> > appears to be disappearing into the mists of time :(
> 
> Even without the printk irq_work the current printk method uses a
> delayed wakeup anyway.
> 
> The wake_up_klogd() sets PRINTK_PENDING_WAKEUP, and the wakeup happens
> at time of the tick. I don't see where there is a deadlock.
>
> ...
>
> Do we really even need that printk_sched()?

3ccf3e8306156a282 ("printk/sched: Introduce special printk_sched() for
those awkward moments") was added _after_ wake_up_klogd() was switched
to using the printk_pending->printk_tick() thing.  So presumably there
were deadlocks other than around wake_up_klogd().

The printk_pending->printk_tick() thing was added by b845b517b5e
("printk: robustify printk"), four years earlier in 2008.  It says
"Avoid deadlocks against rq->lock and xtime_lock...".

So what deadlocks was the March 2012 3ccf3e830 ("printk/sched:
Introduce special printk_sched() for those awkward moments") supposed
to fix?  grr.  I searched my lkml archives for March 2012 and few
preceding months, but couldn't find any additional info.

> I added a printk in __sched_setscheduler() where the run queue lock is held,
> and booted that with full lockdep debugging enabled. No deadlock is
> detected.

Well, you'd need to enable various printk options to get full coverage.
For example, that xtime_lock deadlock would only have occurred when
timestamping is enabled.

