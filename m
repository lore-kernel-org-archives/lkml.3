Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaE0UU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:20:28 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51176 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaE0UU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:20:26 -0400
Message-ID: <1401222025.5367.262.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] sched/numa: Fix use of spin_{un}lock_irq() when
 interrupts are disabled
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Date: Tue, 27 May 2014 13:20:25 -0700
In-Reply-To: <20140527155251.5dc77977@gandalf.local.home>
References: <20140527155251.5dc77977@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 15:52 -0400, Steven Rostedt wrote:
> As Peter Zijlstra told me, we have the following path:
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
> 
> Which means that task_numa_free() can be called with interrupts
> disabled, which means that we should not be using spin_lock_irq() but
> spin_lock_irqsave() instead. Otherwise we are enabling interrupts while
> holding an interrupt unsafe lock!
> 
> Link: http://lkml.kernel.org/r/20140527182541.GH11096@twins.programming.kicks-ass.net
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---

Your patch was mangled it seems...

Fixes: 60e69eed85bb ("sched/numa: Fix task_numa_free() lockdep splat")



