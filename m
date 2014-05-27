Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaE0SwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:52:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:49387 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752202AbaE0SwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:52:06 -0400
Date: Tue, 27 May 2014 14:52:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 3.14-rt] sched/numa: Fix task_numa_free() lockdep splat
Message-ID: <20140527145201.6e79230f@gandalf.local.home>
In-Reply-To: <20140527182541.GH11096@twins.programming.kicks-ass.net>
References: <20140509181214.GK29014@linutronix.de>
	<1400297819.9493.11.camel@marge.simpson.net>
	<20140527141836.4f466086@gandalf.local.home>
	<20140527182541.GH11096@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 20:25:41 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> Nope, its really IRQs.
> 
> do_exit()
>   exit_itimers()
>     itimer_delete()
>       spin_lock_irqsave(&timer->it_lock, &flags);
>       timer_delete_hook(timer);
>         kc->timer_del(timer) := posix_cpu_timer_del()
>           put_task_struct()
>             __put_task_struct()
>               task_numa_free()
>                 spin_lock(&grp->lock);
> 
> Which nests the grp->lock inside the timer->it_lock, and where the
> timer->it_lock is IRQ-safe, the grp->lock is not.
> 
> This allows for IRQ deadlocks.

Ah crap. I did a search on all the callers of put_task_struct(), and
somehow missed this one.  Yep, I was looking for places that called
this while holding other irq safe locks.

-- Steve

