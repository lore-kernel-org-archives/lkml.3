Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935921Ab3DIJ0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:26:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934875Ab3DIJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:26:36 -0400
Message-ID: <1365499591.30071.3.camel@laptop>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Date: Tue, 09 Apr 2013 11:26:31 +0200
In-Reply-To: <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-06 at 18:45 +0200, Frederic Weisbecker wrote:
> Because we may update the execution time (sched_group_set_shares()->
>         update_cfs_shares()->reweight_entity()->update_curr()) before
> reweighting the entity after updating the group shares and this
> requires
> an uptodate version of the runqueue clock. Let's update it on the
> target
> CPU if it runs tickless because scheduler_tick() is not there to
> maintain
> it.

Same as the last comment, we should never rely on the tick to update
->clock except for the work done by the tick itself.

Therefore you seem to have found another missing clock update.

The problem seems to be that we haven't been able to come up with a
sane debug framework for the ->clock updates. But we should have at
least one (and preferably no more) update_sched_clock() calls per
scheduler entry point.

> ---
>  kernel/sched/fair.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 539760e..6d35f8a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6060,6 +6060,11 @@ int sched_group_set_shares(struct task_group
> *tg, unsigned long shares)
>                 se = tg->se[i];
>                 /* Propagate contribution to hierarchy */
>                 raw_spin_lock_irqsave(&rq->lock, flags);
> +               /*
> +                * We may call update_curr() which needs an up-to-date
> +                * version of rq clock if the CPU runs tickless.
> +                */
> +               update_nohz_rq_clock(rq);
>                 for_each_sched_entity(se)
>                         update_cfs_shares(group_cfs_rq(se));
>                 raw_spin_unlock_irqrestore(&rq->lock, flags);


