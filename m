Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3KLPaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:30:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3KLPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:30:07 -0500
Date: Tue, 12 Nov 2013 16:29:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131112152956.GY5056@laptop.programming.kicks-ass.net>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
 <20131112100140.GM5056@laptop.programming.kicks-ass.net>
 <20131112151541.GD24980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112151541.GD24980@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:15:41AM -0500, Vivek Goyal wrote:
> I see that we allocate per cpu stats but don't do any initializations.
> 
> static void tg_stats_alloc_fn(struct work_struct *work)
> {
>         static struct tg_stats_cpu *stats_cpu;  /* this fn is non-reentrant */
>         struct delayed_work *dwork = to_delayed_work(work);
>         bool empty = false;
> 
> alloc_stats:
>         if (!stats_cpu) {
>                 stats_cpu = alloc_percpu(struct tg_stats_cpu);
>                 if (!stats_cpu) {
>                         /* allocation failed, try again after some time */
>                         schedule_delayed_work(dwork, msecs_to_jiffies(10));
>                         return;
>                 }
>         }
> 
>         spin_lock_irq(&tg_stats_alloc_lock);

Absolutely!

Something like this perhaps? Did I miss more blkg_[rw]stats? If I read
the git grep output right, this was the last one.

---
 block/blk-throttle.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8331aba9426f..fd743d98c41d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -256,6 +256,12 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
 	}								\
 } while (0)
 
+static void tg_stats_init(struct tg_stats_cpu *tg_stats)
+{
+	blkg_rwstat_init(&tg_stats->service_bytes);
+	blkg_rwstat_init(&tg_stats->serviced);
+}
+
 /*
  * Worker for allocating per cpu stat for tgs. This is scheduled on the
  * system_wq once there are some groups on the alloc_list waiting for
@@ -269,12 +275,16 @@ static void tg_stats_alloc_fn(struct work_struct *work)
 
 alloc_stats:
 	if (!stats_cpu) {
+		int cpu;
+
 		stats_cpu = alloc_percpu(struct tg_stats_cpu);
 		if (!stats_cpu) {
 			/* allocation failed, try again after some time */
 			schedule_delayed_work(dwork, msecs_to_jiffies(10));
 			return;
 		}
+		for_each_possible_cpu(cpu)
+			tg_stats_init(per_cpu(stats_cpu, cpu));
 	}
 
 	spin_lock_irq(&tg_stats_alloc_lock);
