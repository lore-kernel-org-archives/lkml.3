Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3BECGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:06:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3BECGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:06:05 -0500
Date: Mon, 4 Feb 2013 18:09:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
Message-Id: <20130204180948.68c206c0.akpm@linux-foundation.org>
In-Reply-To: <CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	<20130204172001.8bb358b0.akpm@linux-foundation.org>
	<CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 02:37:54 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/2/5 Andrew Morton <akpm@linux-foundation.org>:
> > On Tue,  5 Feb 2013 01:51:18 +0100
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >>       printk: Wake up klogd using irq_work
> >
> > That seems reasonable.
> >
> > I'm wondering if we can now remove the printk_sched() special-case.
> > iirc, that was needed because wake_up(klogd) would deadlock when called
> > from sched internals.  But now that wakeup is punted to the timer tick,
> > perhaps this is now unnecessary?
> 
> I fear irq work doesn't change much the picture in this regard. Before
> irq work, printk() and printk_sched() were already relying on the tick
> (printk_tick()) to do the wake up on klogd clients. I guess that the
> deadlocks referenced by Peter were about printk() internals. May be
> logbuf_lock against some other scheduler lock?

I don't think so.  Conceptually printk() should be "inner" to the
scheduler and shouldn't call into sched things at all.  The (afaik
sole) exception to that was the klogd wakeup.

Traditionally the deadlock happened when calling printk() with
tasklist_lock (now q->lock) held.  printk() would call wake_up(klogd)
and wake_up() tries to take tasklist_lock and boom.  Moving the
wake_up() out to the tick "thread" fixed that.

Maybe there were other deadlock scenarios, dunno.  That knowledge
appears to be disappearing into the mists of time :(

