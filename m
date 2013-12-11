Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3LKHL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:42220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab3LKHLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352565"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 14/15] perf, x86: Enable LBR callstack when recording callchain
Date: Wed, 11 Dec 2013 15:10:59 +0800
Message-Id: <1386745860-21143-15-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Try enabling the LBR call stack feature if event requests recording
callchain. Also adds a cpu pmu attribute to enable/disable this
feature (disabled by default).

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 94 +++++++++++++++++++++++++++-------------
 arch/x86/kernel/cpu/perf_event.h |  7 +++
 2 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1509340..7fbb751 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -399,37 +399,49 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
+	}
+	/*
+	 * check that PEBS LBR correction does not conflict with
+	 * whatever the user is asking with attr->branch_sample_type
+	 */
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
+		u64 *br_type = &event->attr.branch_sample_type;
+
+		if (has_branch_stack(event)) {
+			if (!precise_br_compat(event))
+				return -EOPNOTSUPP;
+
+			/* branch_sample_type is compatible */
+
+		} else {
+			/*
+			 * user did not specify  branch_sample_type
+			 *
+			 * For PEBS fixups, we capture all
+			 * the branches at the priv level of the
+			 * event.
+			 */
+			*br_type = PERF_SAMPLE_BRANCH_ANY;
+
+			if (!event->attr.exclude_user)
+				*br_type |= PERF_SAMPLE_BRANCH_USER;
+
+			if (!event->attr.exclude_kernel)
+				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
+		}
+	} else if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+		   !has_branch_stack(event) &&
+		   x86_pmu.attr_lbr_callstack &&
+		   !event->attr.exclude_user &&
+		   (event->attach_state & PERF_ATTACH_TASK)) {
 		/*
-		 * check that PEBS LBR correction does not conflict with
-		 * whatever the user is asking with attr->branch_sample_type
+		 * user did not specify branch_sample_type,
+		 * try using the LBR call stack facility to
+		 * record call chains of user program.
 		 */
-		if (event->attr.precise_ip > 1 &&
-		    x86_pmu.intel_cap.pebs_format < 2) {
-			u64 *br_type = &event->attr.branch_sample_type;
-
-			if (has_branch_stack(event)) {
-				if (!precise_br_compat(event))
-					return -EOPNOTSUPP;
-
-				/* branch_sample_type is compatible */
-
-			} else {
-				/*
-				 * user did not specify  branch_sample_type
-				 *
-				 * For PEBS fixups, we capture all
-				 * the branches at the priv level of the
-				 * event.
-				 */
-				*br_type = PERF_SAMPLE_BRANCH_ANY;
-
-				if (!event->attr.exclude_user)
-					*br_type |= PERF_SAMPLE_BRANCH_USER;
-
-				if (!event->attr.exclude_kernel)
-					*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
-			}
-		}
+		event->attr.branch_sample_type =
+			PERF_SAMPLE_BRANCH_USER |
+			PERF_SAMPLE_BRANCH_CALL_STACK;
 	}
 
 	/*
@@ -1828,10 +1840,34 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	return count;
 }
 
+static ssize_t get_attr_lbr_callstack(struct device *cdev,
+				      struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, 40, "%d\n", x86_pmu.attr_lbr_callstack);
+}
+
+static ssize_t set_attr_lbr_callstack(struct device *cdev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	unsigned long val = simple_strtoul(buf, NULL, 0);
+
+	if (x86_pmu.attr_lbr_callstack != !!val) {
+		if (val && !x86_pmu_has_lbr_callstack())
+			return -EOPNOTSUPP;
+		x86_pmu.attr_lbr_callstack = !!val;
+	}
+	return count;
+}
+
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_ATTR(lbr_callstack, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+		   get_attr_lbr_callstack, set_attr_lbr_callstack);
+
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_lbr_callstack.attr,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index bcc8e1f..f07cc04 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -401,6 +401,7 @@ struct x86_pmu {
 	 * sysfs attrs
 	 */
 	int		attr_rdpmc;
+	int		attr_lbr_callstack;
 	struct attribute **format_attrs;
 	struct attribute **event_attrs;
 
@@ -505,6 +506,12 @@ static struct perf_pmu_events_attr event_attr_##v = {			\
 
 extern struct x86_pmu x86_pmu __read_mostly;
 
+static inline bool x86_pmu_has_lbr_callstack(void)
+{
+	return  x86_pmu.lbr_sel_map &&
+		x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
+}
+
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
 int x86_perf_event_set_period(struct perf_event *event);
-- 
1.8.1.4

