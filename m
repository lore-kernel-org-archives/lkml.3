Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaBKPeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:34:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:42684 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaBKPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:34:35 -0500
Date: Tue, 11 Feb 2014 16:34:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v2] sched: Init idle->on_rq in init_idle()
In-Reply-To: <20140211092108.GL27965@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1402111534000.21991@ionos.tec.linutronix.de>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de> <1391803122-4425-2-git-send-email-bigeasy@linutronix.de> <20140207210905.GV5002@laptop.programming.kicks-ass.net> <20140211091758.GA19477@linutronix.de>
 <20140211092108.GL27965@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Peter Zijlstra wrote:

> On Tue, Feb 11, 2014 at 10:17:58AM +0100, Sebastian Andrzej Siewior wrote:
> > The init task is state TASK_RUNNING and on_irq should be set to 1. It won't
> 
> 					^^^ irq? :-)
> 
> > be set by scheduler because the idle task is never woken up, it is always the
> > task we fall back to if there is no other task pending.
> 
> But why? Who cares? I mean, its true.. but what problem does it solve.
> Why did Thomas write this patch.

I could slap myself for not writing a proper changelog right away. It
took me some time to figure out why it was added in the first place,
why it's not longer necessary and why I kept it.

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

Thanks,

	tglx






