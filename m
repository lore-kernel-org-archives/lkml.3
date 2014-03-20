Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbaCTPB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:01:28 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:45050 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaCTPB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
References: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
Date: Thu, 20 Mar 2014 12:01:25 -0300
Message-ID: <CAA6-i6p-=4Dk9-ujvL36EVpm80MS-BiYjw+V9JQ8g4AypBJeZw@mail.gmail.com>
Subject: Re: [BUG] Paravirtual time accounting / IRQ time accounting
From: Glauber Costa <glommer@gmail.com>
To: lwcheng@cs.hku.hk, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:42 AM,  <lwcheng@cs.hku.hk> wrote:
> In consolidated environments, when there are multiple virtual machines (VMs)
> running on one CPU core, timekeeping will be a problem to the guest OS.
> Here, I report my findings about Linux process scheduler.
>
>
> Description
> ------------
> Linux CFS relies on rq->clock_task to charge each task, determine vruntime,
> etc.
>
> When CONFIG_IRQ_TIME_ACCOUNTING is enabled, the time spent on serving IRQ
> will be excluded from updating rq->clock_task.
> When CONFIG_PARAVIRT_TIME_ACCOUNTING is enabled, the time stolen by the
> hypervisor
> will also be excluded from updating rq->clock_task.
>
> With "both" CONFIG_IRQ_TIME_ACCOUNTING and CONFIG_PARAVIRT_TIME_ACCOUNTING
> enabled,
> I put three KVM guests on one core and run hackbench in each guest. I find
> that
> in the guests, rq->clock_task stays *unchanged*. The malfunction embarrasses
> CFS.
> ------------
>
>
> Analysis
> ------------
> [src/kernel/sched/core.c]
> static void update_rq_clock_task(struct rq *rq, s64 delta)
> {
>     ... ...
> #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>     irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>     ... ...
>     rq->prev_irq_time += irq_delta;
>     delta -= irq_delta;
> #endif
>
> #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>     if (static_key_false((&paravirt_steal_rq_enabled))) {
>         steal = paravirt_steal_clock(cpu_of(rq));
>         steal -= rq->prev_steal_time_rq;
>         ... ...
>         rq->prev_steal_time_rq += steal;
>         delta -= steal;
>     }
> #endif
>
>     rq->clock_task += delta;
>     ... ...
> }
> --
> "delta" -> the intended increment to rq->clock_task
> "irq_delta" -> the time spent on serving IRQ (hard + soft)
> "steal" -> the time stolen by the underlying hypervisor
> --
> "irq_delta" is calculated based on sched_clock_cpu(), which is vulnerable
> to VM scheduling delays.

This looks like a real problem indeed. The main problem in searching
for a solution, is that of course not all of the irq time is steal
time and vice versa. In this case, we could subtract irq_time from
steal, and add only the steal part time that is in excess. I don't
think this is 100 % guaranteed, but maybe it is a good approximation.

Rik, do you have an opinion on this ?
