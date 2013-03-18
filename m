Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3CRPZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:25:03 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:33441 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:24:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH V3 6/7] block: queue work on any cpu
Date: Mon, 18 Mar 2013 20:53:28 +0530
Message-Id: <9aa157216e60de7d245128d42fb896918184ae8c.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block layer uses workqueues for multiple purposes. There is no real dependency
of scheduling these on the cpu which scheduled them.

On a idle system, it is observed that and idle cpu wakes up many times just to
service this work. It would be better if we can schedule it on a cpu which isn't
idle to save on power.

By idle cpu (from scheduler's perspective) we mean:
- Current task is idle task
- nr_running == 0
- wake_list is empty

This patch replaces schedule_work() and queue_[delayed_]work() with
queue_[delayed_]work_on_any_cpu() siblings.

These routines would look for the closest (via scheduling domains) non-idle cpu
(non-idle from schedulers perspective). If the current cpu is not idle or all
cpus are idle, work will be scheduled on local cpu.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 block/blk-core.c | 6 +++---
 block/blk-ioc.c  | 2 +-
 block/genhd.c    | 9 ++++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 186603b..14ae74f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -225,7 +225,7 @@ static void blk_delay_work(struct work_struct *work)
 void blk_delay_queue(struct request_queue *q, unsigned long msecs)
 {
 	if (likely(!blk_queue_dead(q)))
-		queue_delayed_work(kblockd_workqueue, &q->delay_work,
+		queue_delayed_work_on_any_cpu(kblockd_workqueue, &q->delay_work,
 				   msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_delay_queue);
@@ -2852,14 +2852,14 @@ EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
 
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
-	return queue_work(kblockd_workqueue, work);
+	return queue_work_on_any_cpu(kblockd_workqueue, work);
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
 int kblockd_schedule_delayed_work(struct request_queue *q,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work(kblockd_workqueue, dwork, delay);
+	return queue_delayed_work_on_any_cpu(kblockd_workqueue, dwork, delay);
 }
 EXPORT_SYMBOL(kblockd_schedule_delayed_work);
 
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 9c4bb82..2eefeb1 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -144,7 +144,7 @@ void put_io_context(struct io_context *ioc)
 	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		spin_lock_irqsave(&ioc->lock, flags);
 		if (!hlist_empty(&ioc->icq_list))
-			schedule_work(&ioc->release_work);
+			queue_work_on_any_cpu(system_wq, &ioc->release_work);
 		else
 			free_ioc = true;
 		spin_unlock_irqrestore(&ioc->lock, flags);
diff --git a/block/genhd.c b/block/genhd.c
index a1ed52a..4bdb735 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1488,9 +1488,11 @@ static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 	intv = disk_events_poll_jiffies(disk);
 	set_timer_slack(&ev->dwork.timer, intv / 4);
 	if (check_now)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
+		queue_delayed_work_on_any_cpu(system_freezable_wq, &ev->dwork,
+				0);
 	else if (intv)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work_on_any_cpu(system_freezable_wq, &ev->dwork,
+				intv);
 out_unlock:
 	spin_unlock_irqrestore(&ev->lock, flags);
 }
@@ -1626,7 +1628,8 @@ static void disk_check_events(struct disk_events *ev,
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work_on_any_cpu(system_freezable_wq, &ev->dwork,
+				intv);
 
 	spin_unlock_irq(&ev->lock);
 
-- 
1.7.12.rc2.18.g61b472e

