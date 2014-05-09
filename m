Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaEIJSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:18:42 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43291 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaEIJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:18:30 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, sbradshaw@micron.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] block: per-cpu counters for in-flight IO accounting
Date: Fri,  9 May 2014 11:17:41 +0200
Message-Id: <1399627061-5960-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399627061-5960-1-git-send-email-m@bjorling.me>
References: <1399627061-5960-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With multi-million IOPS and multi-node workloads, the atomic_t in_flight
tracking becomes a bottleneck. Change the in-flight accounting to per-cpu
counters to elevate.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 block/partition-generic.c |  4 ++--
 include/linux/genhd.h     | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..b21937a 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -140,8 +140,8 @@ ssize_t part_inflight_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
-		atomic_read(&p->in_flight[1]));
+	return sprintf(buf, "%8d %8d\n", percpu_counter_sum(&p->in_flight[0]),
+		percpu_counter_sum(&p->in_flight[1]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9f3c275..8487d70 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -118,7 +118,6 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -126,6 +125,7 @@ struct hd_struct {
 #endif
 	atomic_t ref;
 	struct rcu_head rcu_head;
+	struct percpu_counter in_flight[2];
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -330,15 +330,26 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 
 static inline int init_part_stats(struct hd_struct *part)
 {
+	if (percpu_counter_init(&part->in_flight[0], 0))
+		return 0;
+	if (percpu_counter_init(&part->in_flight[1], 0))
+		goto err_cnt;
 	part->dkstats = alloc_percpu(struct disk_stats);
 	if (!part->dkstats)
-		return 0;
+		goto err_stats;
 	return 1;
+err_stats:
+	percpu_counter_destroy(&part->in_flight[1]);
+err_cnt:
+	percpu_counter_destroy(&part->in_flight[0]);
+	return 0;
 }
 
 static inline void free_part_stats(struct hd_struct *part)
 {
 	free_percpu(part->dkstats);
+	percpu_counter_destroy(&part->in_flight[1]);
+	percpu_counter_destroy(&part->in_flight[0]);
 }
 
 #else /* !CONFIG_SMP */
@@ -382,21 +393,21 @@ static inline void free_part_stats(struct hd_struct *part)
 
 static inline void part_inc_in_flight(struct hd_struct *part, int rw)
 {
-	atomic_inc(&part->in_flight[rw]);
+	__percpu_counter_add(&part->in_flight[rw], 1, 1000000);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		__percpu_counter_add(&part_to_disk(part)->part0.in_flight[rw], 1, 1000000);
 }
 
 static inline void part_dec_in_flight(struct hd_struct *part, int rw)
 {
-	atomic_dec(&part->in_flight[rw]);
+	__percpu_counter_add(&part->in_flight[rw], -1, 1000000);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		__percpu_counter_add(&part_to_disk(part)->part0.in_flight[rw], -1, 1000000);
 }
 
 static inline int part_in_flight(struct hd_struct *part)
 {
-	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
+	return percpu_counter_sum(&part->in_flight[0]) + percpu_counter_sum(&part->in_flight[1]);
 }
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
-- 
1.9.1

