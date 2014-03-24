Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaCXOSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:18:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:41715 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753188AbaCXOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:18:05 -0400
Date: Mon, 24 Mar 2014 10:18:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] dont calculate hweight in update_migrate_disable
Message-ID: <20140324101800.3f978842@gandalf.local.home>
In-Reply-To: <20140324121848.GA18300@opentech.at>
References: <20140324121848.GA18300@opentech.at>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 13:18:48 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> Hi ! 
> 
> Proposal for a minor optimization in update_migrate_disable - its only a few 
> instructions saved but those are in the hot path of locks so it might be worth
> it
> 
> When being scheduled out while migrate_disable > 0 and migrate_disabled_updated
> is not yet set we end up here (kernel/sched/core.c):
> 
> static inline void update_migrate_disable(struct task_struct *p)
> {
>         ...
> 
>         mask = tsk_cpus_allowed(p);
> 
>         if (p->sched_class->set_cpus_allowed)
>                 p->sched_class->set_cpus_allowed(p, mask);
>         p->nr_cpus_allowed = cpumask_weight(mask);
> 
> 
> as we only can get here if migrate_disable > 0 there is no need to calculate
> the cpumask_weight(mask) as tsk_cpus_allowed in that case will return
> cpumask_of(task_cpu(p)) which only can have a hamming weight of 1 anyway.
> So we can simply do:
> 
>         p->nr_cpus_allowed = 1;
> 
> without changing the behavior.
> 
> Patch is on top of 3.12.13-rt21
> 

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

