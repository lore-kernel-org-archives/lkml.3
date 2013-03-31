Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3CaOcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 10:32:36 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:36291 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3CaOce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 10:32:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 3/4] block: queue work on unbound wq
Date: Sun, 31 Mar 2013 20:01:46 +0530
Message-Id: <91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364740180.git.viresh.kumar@linaro.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364740180.git.viresh.kumar@linaro.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block layer uses workqueues for multiple purposes. There is no real dependency
of scheduling these on the cpu which scheduled them.

On a idle system, it is observed that and idle cpu wakes up many times just to
service this work. It would be better if we can schedule it on a cpu which the
scheduler believes to be the most appropriate one.

This patch replaces normal workqueues with UNBOUND versions.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 block/blk-core.c |  3 ++-
 block/blk-ioc.c  |  2 +-
 block/genhd.c    | 10 ++++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 492242f..91cd486 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3186,7 +3186,8 @@ int __init blk_dev_init(void)
 
 	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
 	kblockd_workqueue = alloc_workqueue("kblockd",
-					    WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+					    WQ_MEM_RECLAIM | WQ_HIGHPRI |
+					    WQ_UNBOUND, 0);
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
 
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 9c4bb82..5dd576d 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -144,7 +144,7 @@ void put_io_context(struct io_context *ioc)
 	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		spin_lock_irqsave(&ioc->lock, flags);
 		if (!hlist_empty(&ioc->icq_list))
-			schedule_work(&ioc->release_work);
+			queue_work(system_unbound_wq, &ioc->release_work);
 		else
 			free_ioc = true;
 		spin_unlock_irqrestore(&ioc->lock, flags);
diff --git a/block/genhd.c b/block/genhd.c
index a1ed52a..0f4470a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1488,9 +1488,10 @@ static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 	intv = disk_events_poll_jiffies(disk);
 	set_timer_slack(&ev->dwork.timer, intv / 4);
 	if (check_now)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
+		queue_delayed_work(system_freezable_unbound_wq, &ev->dwork, 0);
 	else if (intv)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work(system_freezable_unbound_wq, &ev->dwork,
+				intv);
 out_unlock:
 	spin_unlock_irqrestore(&ev->lock, flags);
 }
@@ -1533,7 +1534,7 @@ void disk_flush_events(struct gendisk *disk, unsigned int mask)
 	spin_lock_irq(&ev->lock);
 	ev->clearing |= mask;
 	if (!ev->block)
-		mod_delayed_work(system_freezable_wq, &ev->dwork, 0);
+		mod_delayed_work(system_freezable_unbound_wq, &ev->dwork, 0);
 	spin_unlock_irq(&ev->lock);
 }
 
@@ -1626,7 +1627,8 @@ static void disk_check_events(struct disk_events *ev,
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
-		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work(system_freezable_unbound_wq, &ev->dwork,
+				intv);
 
 	spin_unlock_irq(&ev->lock);
 
-- 
1.7.12.rc2.18.g61b472e

