Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaDMBcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:32:16 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37649 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaDMBcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:32:13 -0400
Date: Sat, 12 Apr 2014 21:32:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140413013209.GC26252@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Unified hierarchy has finally been posted.

  http://thread.gmane.org/gmane.linux.kernel.containers/27601

It took a lot longer than I originally anticipated and over the course
quite a few aspects of the initial design have changed, hopefully, for
the better.  One of the areas which has seen major redirection is
internal tasks competing against child cgroups.  The original plan was
implementing an implicit leaf node for each cgroup so that internal
tasks compete as an implicit child against other children.  cfq was
chosen as the first one to try the strategy and the result was
leaf_weight[_device] knobs.  This, unfortunately, doesn't seem to be
the right direction.

The strategy complicates the controller interface and implementation,
and ends up adding an extra layer of nesting at leaves.  Also,
initially, it was thought that internal tasks are problematic only for
weight based controllers; however, it turns out it also is a problem
for absolute limit based ones like memory, which means that we'd need
to complicate more controllers.

As the problem is something fundamental in most resource controllers,
the implemented unified hierarchy now enforces structural constraint
which prevents competion between internal tasks and child cgroups from
the get-go making leaf_weight[_device] mechanism unnecessary.

In addition, blkio interface is generally a bit messy and all cfq
knobs are missing "cfq." prefix.  As unified hierarchy involves
noticeable changes in usage, this patch takes the chance and make
blkio present more consistent and concise interface on unified
hierarchy

I'm currently preparing a doc describing the design and rationales of
unified hierarchy and most of the above information will be present in
the documentation.

Thanks.

------ 8< ------
Some blkcg knobs don't make sense on unified hierarchy.  This patch
makes the following changes for unified hierarchy.

* reset_stats never made much sense outside developement and
  debugging.  Omit it.

* As unified hierarchy excludes internal tasks competing against child
  cgroups, cfq's leaf_weight[_device] knobs are no longer necessary.
  Omit it.

* For cfq, weight[_device] behave inherently differently from the same
  knobs on !root cgroups as root cgroup is treated as parallel to
  immediate children.  Let's omit it for now.

* cfq's time stats reports the total time slice consumed but its unit
  is in jiffies and it's not reported per-device like all other stats.
  Omit it for now.  If slice time is actually necessary, let's add it
  in the form consistent with other stats.

* cfq's io_queued reporting is different from all other stats in that
  it's a snapshot value rather than accumulated value and is mostly
  meaningful only for debugging.  Omit it.

* As unified hierarchy doesn't allow internal tasks, non-recursive
  stats are largely irrelevant.  Omit them.

* cfq adds a number of stats knobs if CONFIG_DEBUG_BLK_CGROUP.  If
  these are actually for debugging, they shouldn't show up by default
  (ie. should be gated by kernel param or something).  If userland
  already developed dependency on them, we need to take them out of
  CONFIG_DEBUG_BLK_CGROUP.  Skip them for now.  We can add back the
  relevant ones later.

* Prefix the remaining cfq knobs with "cfq." and make the names
  consistent.

  weight_device			-> cfq.weight_device
  weight			-> cfq.weight
  sectors_recursive		-> cfq.sectors
  io_service_bytes_recursive	-> cfq.bytes
  io_serviced_recursive		-> cfq.serviced
  io_merged_recursive		-> cfq.merged
  io_service_time_recursive	-> cfq.io_time
  io_wait_time_recursive	-> cfq.wait_time

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c  |    1 
 block/cfq-iosched.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 86 insertions(+), 4 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -761,6 +761,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_finish);
 struct cftype blkcg_files[] = {
 	{
 		.name = "reset_stats",
+		.flags = CFTYPE_INSANE,
 		.write_u64 = blkcg_reset_stats,
 	},
 	{ }	/* terminate */
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1835,13 +1835,13 @@ static struct cftype cfq_blkcg_files[] =
 	/* on root, weight is mapped to leaf_weight */
 	{
 		.name = "weight_device",
-		.flags = CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cfqg_print_leaf_weight_device,
 		.write_string = cfqg_set_leaf_weight_device,
 	},
 	{
 		.name = "weight",
-		.flags = CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cfq_print_leaf_weight,
 		.write_u64 = cfq_set_leaf_weight,
 	},
@@ -1849,24 +1849,26 @@ static struct cftype cfq_blkcg_files[] =
 	/* no such mapping necessary for !roots */
 	{
 		.name = "weight_device",
-		.flags = CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_NOT_ON_ROOT,
 		.seq_show = cfqg_print_weight_device,
 		.write_string = cfqg_set_weight_device,
 	},
 	{
 		.name = "weight",
-		.flags = CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_INSANE | CFTYPE_NOT_ON_ROOT,
 		.seq_show = cfq_print_weight,
 		.write_u64 = cfq_set_weight,
 	},
 
 	{
 		.name = "leaf_weight_device",
+		.flags = CFTYPE_INSANE,
 		.seq_show = cfqg_print_leaf_weight_device,
 		.write_string = cfqg_set_leaf_weight_device,
 	},
 	{
 		.name = "leaf_weight",
+		.flags = CFTYPE_INSANE,
 		.seq_show = cfq_print_leaf_weight,
 		.write_u64 = cfq_set_leaf_weight,
 	},
@@ -1874,41 +1876,49 @@ static struct cftype cfq_blkcg_files[] =
 	/* statistics, covers only the tasks in the cfqg */
 	{
 		.name = "time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.time),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "sectors",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.sectors),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "io_service_bytes",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.service_bytes),
 		.seq_show = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_serviced",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.serviced),
 		.seq_show = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_service_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.service_time),
 		.seq_show = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_wait_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.wait_time),
 		.seq_show = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_merged",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.merged),
 		.seq_show = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_queued",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.queued),
 		.seq_show = cfqg_print_rwstat,
 	},
@@ -1916,75 +1926,146 @@ static struct cftype cfq_blkcg_files[] =
 	/* the same statictics which cover the cfqg and its descendants */
 	{
 		.name = "time_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.time),
 		.seq_show = cfqg_print_stat_recursive,
 	},
 	{
 		.name = "sectors_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.sectors),
 		.seq_show = cfqg_print_stat_recursive,
 	},
 	{
 		.name = "io_service_bytes_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.service_bytes),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_serviced_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.serviced),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_service_time_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.service_time),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_wait_time_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.wait_time),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_merged_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.merged),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_queued_recursive",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.queued),
 		.seq_show = cfqg_print_rwstat_recursive,
 	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
+		.flags = CFTYPE_INSANE,
 		.seq_show = cfqg_print_avg_queue_size,
 	},
 	{
 		.name = "group_wait_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.group_wait_time),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "idle_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.idle_time),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "empty_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.empty_time),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "dequeue",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.dequeue),
 		.seq_show = cfqg_print_stat,
 	},
 	{
 		.name = "unaccounted_time",
+		.flags = CFTYPE_INSANE,
 		.private = offsetof(struct cfq_group, stats.unaccounted_time),
 		.seq_show = cfqg_print_stat,
 	},
 #endif	/* CONFIG_DEBUG_BLK_CGROUP */
+
+	/* files for default hierarchy, properly prefixed with cfq */
+	{
+		.name = "cfq.weight_device",
+		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.seq_show = cfqg_print_weight_device,
+		.write_string = cfqg_set_weight_device,
+	},
+	{
+		.name = "cfq.weight",
+		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.seq_show = cfq_print_weight,
+		.write_u64 = cfq_set_weight,
+	},
+
+	/*
+	 * All stats are recursive and fewer are visible.  Please do not
+	 * add stats which aren't strictly necessary or expose internal
+	 * details.
+	 */
+	{
+		.name = "cfq.sectors",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.sectors),
+		.seq_show = cfqg_print_stat_recursive,
+	},
+	{
+		.name = "cfq.bytes",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.service_bytes),
+		.seq_show = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "cfq.serviced",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.serviced),
+		.seq_show = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "cfq.merged",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.merged),
+		.seq_show = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "cfq.io_time",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.service_time),
+		.seq_show = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "cfq.wait_time",
+		.flags = CFTYPE_ONLY_ON_DFL,
+		.private = offsetof(struct cfq_group, stats.wait_time),
+		.seq_show = cfqg_print_rwstat_recursive,
+	},
+
 	{ }	/* terminate */
 };
 #else /* GROUP_IOSCHED */
