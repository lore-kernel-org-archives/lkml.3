Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbaDBLIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:08:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbaDBLH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:07:59 -0400
Date: Wed, 2 Apr 2014 13:07:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, ben@decadent.org.uk,
        mkl@pengutronix.de, linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1) instead
 of yield() to wait for outstanding qdisc_run callsb
Message-ID: <20140402110743.GG27965@twins.programming.kicks-ass.net>
References: <1393976987-23555-1-git-send-email-mkl@pengutronix.de>
 <20140306.160622.59358366688518505.davem@davemloft.net>
 <1394392160.15968.13.camel@deadeye.wl.decadent.org.uk>
 <20140309.185338.2057082497431220324.davem@davemloft.net>
 <alpine.DEB.2.02.1403312333100.14882@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403312333100.14882@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:49:16PM +0200, Thomas Gleixner wrote:
> > >> The intent of a yield() call, like this one here, is unambiguously
> > >> that the current thread cannot do anything until some other thread
> > >> gets onto the cpu and makes forward progress.

Yeah; like Thomas said; that's not what yield() does -- or can do.

yield() only says 'I don't know what to do, you figure it out', but then
fails to provide enough information to actually do something sensible.

It cannot put the task to sleep; because it doesn't pair with a wakeup;
and therefore the task stays an eligible/runnable task from a scheduler
pov.

The scheduler is therefore entirely in its right to pick this task
again; and pretty much has to under many circumstances.

yield() does not, and can not, guarantee forward progress - ever.

Use wait_event() and assorted bits to wait for an actual event. That is
a sleep paired with a wakeup and thus has progress guarantees.

Also; see the comment near yield:

/**
 * yield - yield the current processor to other threads.
 *
 * Do not ever use this function, there's a 99% chance you're doing it wrong.
 *
 * The scheduler is at all times free to pick the calling task as the most
 * eligible task to run, if removing the yield() call from your code breaks
 * it, its already broken.
 *
 * Typical broken usage is:
 *
 * while (!event)
 * 	yield();
 *
 * where one assumes that yield() will let 'the other' process run that will
 * make event true. If the current task is a SCHED_FIFO task that will never
 * happen. Never use yield() as a progress guarantee!!
 *
 * If you want to use yield() to wait for something, use wait_event().
 * If you want to use yield() to be 'nice' for others, use cond_resched().
 * If you still want to use yield(), do not!
 */
void __sched yield(void)


