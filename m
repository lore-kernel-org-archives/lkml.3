Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3KVMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:07:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43836 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3KVMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:07:39 -0500
Date: Fri, 22 Nov 2013 13:07:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
Message-ID: <20131122120733.GP3866@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
 <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
 <20131121150344.GG10022@twins.programming.kicks-ass.net>
 <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 09:22:24AM -0800, Yinghai Lu wrote:
> On Thu, Nov 21, 2013 at 7:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> This one seems fix NULL reference in compute_group_power.
> >>
> >> but get following on current Linus tree plus tip/sched/urgent.
> >>
> >> divide error: 0000 [#1]  SMP
> >> [   28.190477] Modules linked in:
> >> [   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
> >> 3.12.0-yh-10487-g4b94e59-dirty #2044
> >> [   28.210488] Hardware name: Oracle Corporation  Sun Fire
> >> [   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
> >> ffff88ff2520a000
> >> [   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
> >> find_busiest_group+0x2b4/0x8a0
> >
> > Hurmph.. what kind of hardware is that? and is there anything funny you
> > do to make it do this?
> 
> intel nehanem-ex or westmere-ex 8 sockets system.
> 
> I tried without my local patches, the problem is still there.

And I suppose a kernel before

  863bffc80898 ("sched/fair: Fix group power_orig computation")

work fine, eh?

I'll further assume that your RIP points to:

	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;

indicating that sds.total_pwr := 0.

update_sd_lb_stats() computes it like:

		sds->total_pwr += sgs->group_power;

which comes out of update_sg_lb_stats() like:

	sgs->group_power = group->sgp->power;

Which we compute in update_group_power() similarly to how we did before
863bffc80898.

Which leaves me a bit puzzled.


