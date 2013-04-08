Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219Ab3DHLs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:48:58 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:51861 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DHLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:48:56 -0400
Date: Mon, 8 Apr 2013 13:48:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/7] sched: Update rq clock on nohz CPU before migrating
 tasks
Message-ID: <20130408114851.GA3928@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
 <1365266760-24725-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365266760-24725-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> @@ -1115,6 +1116,12 @@ static inline void dec_nr_running(struct rq *rq)
>  
>  extern void update_rq_clock(struct rq *rq);
>  
> +static inline void update_nohz_rq_clock(struct rq *rq)
> +{
> +	if (tick_nohz_extended_cpu(cpu_of(rq)))
> +		update_rq_clock(rq);
> +}

A minor comment: instead of implicitly knowing that full nohz CPUs mean a stale 
rq_clock, how about adding this information to the rq-> itself?

Something like introducing rq->clock_valid, initializing it to 1, and setting it 
to 0 when a CPU stops the tick.

(This would also allow the debug detection of sched_clock() use of stale values.)

We already have a similar flag: rq->skip_clock_update. I'd suggest to introduce a 
'struct sched_clock' helper structure and add the flags and scheduler clock fields 
as:

   rq->clock                 ->       rq->clock.cpu
   rq->clock_task            ->       rq->clock.task
   rq->clock_valid           ->       rq->clock.valid
   rq->clock_skip_uipdate    ->       rq->clock.skip_update
   rq->hrtick_timer          ->       rq->clock.hrtick_timer

   rq->prev_irq_time         ->       rq->clock.prev_irq_time
   rq->prev_steal_time       ->       rq->clock.prev_steal_time
   rq->prev_steal_time_rq    ->       rq->clock.prev_steal_time_rq

Thanks,

	ngo
