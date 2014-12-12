Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbaLLPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:31:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:36204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934898AbaLLPb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:31:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="636712026"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: eranian@google.com, ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf, core: Use sample period avg as child event's initial period
Date: Fri, 12 Dec 2014 10:10:35 -0500
Message-Id: <1418397035-7014-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

For perf record frequency mode, the initial sample_period is 1. That's
because perf doesn't know what period should be set. It uses the minimum
period 1 as the first period. It will trigger an interrupt soon. Then
there will be enough data to calculate the period for the given
frequency. But too many very short period like 1 may cause various
problems and increase the overhead. It's better to limit the 1 period to
just the first several period setting.

However, for some workload, 1 period is frequently set. For example,
perf record a busy loop for 10 seconds.

perf record ./finity_busy_loop.sh 10

while [ "A" != "B" ]
do
date > /dev/null
done

Period was changed 150503 times in 10 seconds. 22.5% (33861 times) of
the period is set to 1. That's because, in the inherit_event, the period
for child event is inherit from parent's parent's event, which is
usually the default sample_period 1. Each child event has to recaculate
the period from 1 everytime. That brings high overhead.

This patch keeps the sample period average in original parent event.
Each new child event can use it as its initial sample period.
Adding a ori_parent in struct perf_event to help child event access the
original parent. For each new child event, the parent event refcount++.
Parent will not go away until all children go away. So the stored
pointer is safe to be accessed.

After applying this patch, the 1 period rate reduces to 0.1%.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 include/linux/perf_event.h |  4 ++++
 kernel/events/core.c       | 22 ++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 486e84c..b328617 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -403,6 +403,10 @@ struct perf_event {
 	struct list_head		child_list;
 	struct perf_event		*parent;
 
+	/* Average Sample period in the original parent event */
+	struct perf_event		*ori_parent;
+	local64_t			avg_sample_period;
+
 	int				oncpu;
 	int				cpu;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index af0a5ba..a8be6d3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2795,7 +2795,8 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bo
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 period, sample_period;
-	s64 delta;
+	s64 delta, avg_period;
+	struct perf_event *head_event = event->ori_parent;
 
 	period = perf_calculate_period(event, nsec, count);
 
@@ -2809,6 +2810,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bo
 
 	hwc->sample_period = sample_period;
 
+	avg_period = (local64_read(&head_event->avg_sample_period) + sample_period) / 2;
+	local64_set(&head_event->avg_sample_period, avg_period);
+
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
 		if (disable)
 			event->pmu->stop(event, PERF_EF_UPDATE);
@@ -6996,6 +7000,10 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->oncpu		= -1;
 
 	event->parent		= parent_event;
+	if (parent_event)
+		event->ori_parent = parent_event->ori_parent;
+	else
+		event->ori_parent = event;
 
 	event->ns		= get_pid_ns(task_active_pid_ns(current));
 	event->id		= atomic64_inc_return(&perf_event_id);
@@ -7030,8 +7038,16 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	hwc = &event->hw;
 	hwc->sample_period = attr->sample_period;
-	if (attr->freq && attr->sample_freq)
+	if (attr->freq && attr->sample_freq) {
 		hwc->sample_period = 1;
+		if (parent_event) {
+			struct perf_event *head_event = event->ori_parent;
+
+			hwc->sample_period = local64_read(&head_event->avg_sample_period);
+		} else {
+			local64_set(&event->avg_sample_period, hwc->sample_period);
+		}
+	}
 	hwc->last_period = hwc->sample_period;
 
 	local64_set(&hwc->period_left, hwc->sample_period);
@@ -7904,7 +7920,9 @@ inherit_event(struct perf_event *parent_event,
 	if (parent_event->attr.freq) {
 		u64 sample_period = parent_event->hw.sample_period;
 		struct hw_perf_event *hwc = &child_event->hw;
+		struct perf_event *head_event = child_event->ori_parent;
 
+		sample_period = local64_read(&head_event->avg_sample_period);
 		hwc->sample_period = sample_period;
 		hwc->last_period   = sample_period;
 
-- 
1.8.3.2

