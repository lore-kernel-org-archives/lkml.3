Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389AbaGROIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:08:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaGROIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:08:20 -0400
Date: Fri, 18 Jul 2014 16:08:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Davies <jonathan.davies@citrix.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] sched/core: Make idle_cpu return 0 if doing softirq
 work
Message-ID: <20140718140821.GD20603@laptop.programming.kicks-ass.net>
References: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:59:06PM +0100, Jonathan Davies wrote:
> The current implementation of idle_cpu only considers tasks that might be in the
> CPU's runqueue. If there's nothing in the specified CPU's runqueue, it will
> return 1. But if the CPU is doing work in the softirq context, it is wrong for
> idle_cpu to return 1. This patch makes it return 0.
> 
> I observed this to be a problem with a device driver kicking a kthread by
> executing wake_up from softirq context. The Completely Fair Scheduler's
> select_task_rq_fair was looking for an "idle sibling" of the CPU executing it by
> calling select_idle_sibling, passing the executing CPU as the 'target'
> parameter. The first thing that select_idle_sibling does is to check whether the
> 'target' CPU is idle, using idle_cpu, and to return that CPU if so. Despite the
> executing CPU being busy in softirq context, idle_cpu was returning 1, meaning
> that the scheduler would consistently try to run the kthread on the same CPU as
> the kick came from. Given that the softirq work was on-going, this led to a
> multi-millisecond delay before the scheduler eventually realised it should
> migrate the kthread to a different CPU.

If your softirq takes _that_ long its broken anyhow.

> A solution to this problem would be to make idle_cpu return 0 when the CPU is
> running in softirq context. I haven't got a patch for that because I couldn't
> find an easy way of querying whether an arbitrary CPU is doing this. (Perhaps I
> should look at the per-CPU softirq_work_list[]...?)

in_serving_softirq()?

> Instead, the following patch is a partial solution, only handling the case when
> the currently-executing CPU is in softirq context. This was sufficient to solve
> the problem I observed.

NAK, IRQ and SoftIRQ are outside of what the scheduler can control, so
for its purpose the CPU is indeed idle.
