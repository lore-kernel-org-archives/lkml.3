Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaKDPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:46:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaKDPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:46:34 -0500
Date: Tue, 4 Nov 2014 16:46:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>, Juri Lelli <juri.lelli@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
Message-ID: <20141104154623.GK10501@worktop.programming.kicks-ass.net>
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141103104111.GA23531@worktop.programming.kicks-ass.net>
 <20141103235747.GA26702@kernel>
 <20141104083225.GG10501@worktop.programming.kicks-ass.net>
 <20141104082345.GA22062@kernel>
 <20141104101022.GH10501@worktop.programming.kicks-ass.net>
 <5458D506.4080702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5458D506.4080702@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:30:46PM +0800, Wanpeng Li wrote:


> + if (!rq->online) {
> + struct rq *latest_rq = NULL;
> + int cpu;
> + u64 dmin = LONG_MAX;
> +
> + for_each_cpu(cpu, &p->cpus_allowed)
> + if (cpu_online(cpu) &&
> + cpu_rq(cpu)->dl.earliest_dl.curr < dmin) {
> + latest_rq = cpu_rq(cpu);
> + dmin = latest_rq->dl.earliest_dl.curr;
> + }

I would have expected something using find_later_rq(), but I might be
mistaken, I'll let Juri suggest something.

> +
> + if (!latest_rq)
> + goto unlock;
> +
> + raw_spin_lock(&latest_rq->lock);
> +
> + deactivate_task(rq, p, 0);
> + set_task_cpu(p, latest_rq->cpu);
> + activate_task(latest_rq, p, 0);
> +
> + raw_spin_unlock(&latest_rq->lock);
> + }
> +
> unlock:
> raw_spin_unlock(&rq->lock);
