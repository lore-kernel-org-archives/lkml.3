Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3BVOd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:33:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:57949 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3BVOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:33:55 -0500
Date: Fri, 22 Feb 2013 15:33:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in
 irq_exit()
In-Reply-To: <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.02.1302221528470.22263@ionos>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com> <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Frederic Weisbecker wrote:
> The irq code is run under HARDIRQ_OFFSET preempt offset until
> we reach the softirq code. Then it's substracted, leaving the
> preempt count to 0, whether we have pending softirqs or not.
> 
> Afterward, if we have softirqs to run, we'll run them under
> the SOFTIRQ_OFFSET then set the preempt offset back to 0
> after softirqs completion.
> 
> The rest of the code in irq_exit(), mainly tick_nohz_irq_exit()
> and rcu_irq_exit(), are executed with this NULL preempt offset.
> 
> The semantics here are not very intuitive. They leave several portions
> of the code into some half-defined context state, where in_interrupt()
> returns false while we actually are in an interrupt.
> 
> In order to make the context definition less confusing, let's
> cover the whole code in irq_exit() under HARDIRQ_OFFSET, except
> for the softirq processing where we switch back and forth
> from HARDIRQ_OFFSET to SOFTIRQ_OFFSET without leaving a gap
> in the context definition.
> 
> There is a drawback though: raise_softirq() relies on the previous
> semantics considering that as long as we are in_interrupt(), the
> pending softirq will be handled in the end of the interrupt. Otherwise
> it kicks ksoftirqd so the softirq is always processed.
> 
> Now tick_nohz_irq_exit() and rcu_irq_exit() can raise softirqs
> themselves. Since these functions were not under the HARDIRQ_OFFSET,
> calling raise_softirq() resulted in waking up the ksoftirqd thread.
> This is correct because invoke_softirq() has already been invoked at
> this stage. But with this patch they are now under HARDIRQ_OFFSET and
> raise_softirq() wrongly thinks invoke_softirq() has yet to be called.
> In the end, this could leave the softirq unprocessed for a while.
> 
> So as Thomas suggested me, this also brings a check in the end of
> irq_exit() that looks for pending softirqs raised after invoke_softirq()
> and wake up ksoftirqd if needed.
> 
> Given that the cleanup on the contexts transition involves that
> new unpretty workaround, I have mixed feelings about this patch so I
> tagged it as "RFC" and I wait for your opinion.

Of course, I'm all for it because I suggested that solution :)

Seriously, I prefer to have in_interrupt() and in_irq() working in the
functions which are called from irq_exit() rather than having special
case workarounds inside of them. We are in interrupt context at this
point and not in some magic virtual place. 

The minimal extra check at the end of irq_exit() is way better than
any other special cased workaround and the softirq stuff is really the
only thing which needs to be taken care of. Anything else just works.

Thanks,

	tglx
