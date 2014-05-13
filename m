Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbaEMN3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:29:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48685 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727AbaEMN3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:29:30 -0400
Date: Tue, 13 May 2014 15:30:20 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.3-rt5
Message-Id: <20140513153020.35c0e9d08db60c7b3919e593@gmail.com>
In-Reply-To: <20140509181214.GK29014@linutronix.de>
References: <20140509181214.GK29014@linutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 9 May 2014 20:12:14 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Dear RT folks!
> 
> I'm pleased to announce the v3.14.3-rt5 patch set.
> 
> Changes since v3.14.3-rt4
> - remove one of the two identical rt_mutex_init() definitions. A patch
>   from Steven Rostedt
> - use EXPORT_SYMBOL() on __rt_mutex_init() and
>   rt_down_write_nested_lock(). The former was dropped accidently and is
>   needed by some binary only modules, the latter was requsted by the f2fs
>   module. Patch by Joakim Hernberg.
> - during v3.14 porting I accidently dropped preempt_check_resched() in
>   the non-preempt case which means configs non-preempt configs did not
>   build. Reported by Yang Honggang.
> - NETCONSOLE is no longer disabled on RT. Daniel Bristot de Oliveira did
>   some testing and did not find anything wrong it. That means it can be
>   enabled if someone needs/wants it.
> - rt_read_lock() uses rwlock_acquire() instead of rwlock_acquire_read()
>   for lockdep annotation. It was different compared to what the trylock
>   variant used and on RT both act the same way. Patch by Mike Galbraith.
> - the tracing code wrongly disable preemption while shrinking the ring
>   buffer. Reported by Stanislav Meduna.
> 
> Known issues:
> 
>       - bcache is disabled.
> 
>       - lazy preempt on x86_64 leads to a crash with some load.
> 
>       - CPU hotplug works in general. Steven's test script however
>         deadlocks usually on the second invocation.
> 

Also SCHED_DEADLINE dies without the following.

Thanks,

- Juri

---From 3ca5943538c728399037823e5632431bc2da707c Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 13 May 2014 15:21:16 +0200
Subject: [PATCH] sched/deadline: dl_task_timer has to be irqsafe

As for rt_period_timer, dl_task_timer has to be irqsafe.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/deadline.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6e79b3f..48b04ce 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -537,6 +537,7 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 
 	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	timer->function = dl_task_timer;
+	timer->irqsafe = 1;
 }
 
 static
-- 
1.7.10.4
