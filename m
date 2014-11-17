Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaKQVOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:14:02 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45290 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaKQVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:14:00 -0500
Date: Mon, 17 Nov 2014 16:13:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH block/for-next 2/4] blkcg: add blkcg_root_css
Message-ID: <20141117211357.GE23126@htj.dyndns.org>
References: <20141117211321.GD23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117211321.GD23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup writeback support would need to tell whether a given blkcg
cgroup_subsys_state is the root one or not.  Add global constant
blkcg_root_css which points to &blkcg_root.css.  If blkcg is disabled,
it's defined as ERR_PTR(-EINVAL).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c     |    2 ++
 include/linux/blkdev.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -30,6 +30,8 @@ struct blkcg blkcg_root = { .cfq_weight
 			    .cfq_leaf_weight = 2 * CFQ_WEIGHT_DEFAULT, };
 EXPORT_SYMBOL_GPL(blkcg_root);
 
+struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
+
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
 static bool blkcg_policy_enabled(struct request_queue *q,
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1408,6 +1408,9 @@ int kblockd_schedule_delayed_work(struct
 int kblockd_schedule_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
+
+extern struct cgroup_subsys_state * const blkcg_root_css;
+
 /*
  * This should not be using sched_clock(). A real patch is in progress
  * to fix this up, until that is in place we need to disable preemption
@@ -1437,6 +1440,9 @@ static inline uint64_t rq_io_start_time_
         return req->io_start_time_ns;
 }
 #else
+
+#define blkcg_root_css	((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
+
 static inline void set_start_time_ns(struct request *req) {}
 static inline void set_io_start_time_ns(struct request *req) {}
 static inline uint64_t rq_start_time_ns(struct request *req)
