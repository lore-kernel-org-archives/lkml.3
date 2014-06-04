Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaFDVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:44:34 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52599 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFDVoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:44:30 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Date: Wed,  4 Jun 2014 23:34:18 +0200
Message-Id: <1401917658-26065-10-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch adds a sysfs entry:

	/sys/devices/cpu/ht_bug_workaround

to activate/deactivate the PMU HT bug workaround.

To activate (activated by default):
 # echo 1 > /sys/devices/cpu/ht_bug_workaround

To deactivate:
 # echo 0 > /sys/devices/cpu/ht_bug_workaround

Results effective only once there is no more active
events.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h       |    5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 314458a..fdea88e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1876,10 +1876,41 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	return count;
 }
 
+static ssize_t get_attr_xsu(struct device *cdev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	int ff = is_ht_workaround_enabled();
+	return snprintf(buf, 40, "%d\n", ff);
+}
+
+static ssize_t set_attr_xsu(struct device *cdev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	unsigned long val;
+	int ff = is_ht_workaround_enabled();
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (!!val != ff) {
+		if (!val)
+			x86_pmu.flags &= ~PMU_FL_EXCL_ENABLED;
+		else
+			x86_pmu.flags |= PMU_FL_EXCL_ENABLED;
+	}
+	return count;
+}
+
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_ATTR(ht_bug_workaround, S_IRUSR | S_IWUSR, get_attr_xsu, set_attr_xsu);
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_ht_bug_workaround.attr,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index c61ca4a..2e7c6a7 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -537,6 +537,7 @@ do {									\
 #define PMU_FL_NO_HT_SHARING	0x1 /* no hyper-threading resource sharing */
 #define PMU_FL_HAS_RSP_1	0x2 /* has 2 equivalent offcore_rsp regs   */
 #define PMU_FL_EXCL_CNTRS	0x4 /* has exclusive counter requirements  */
+#define PMU_FL_EXCL_ENABLED	0x8 /* exclusive counter active */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
@@ -769,6 +770,10 @@ int knc_pmu_init(void);
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page);
 
+static inline int is_ht_workaround_enabled(void)
+{
+	return !!(x86_pmu.flags & PMU_FL_EXCL_ENABLED);
+}
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4fb4fe6..7040c41 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1747,7 +1747,7 @@ intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
 	 * validating a group does not require
 	 * enforcing cross-thread  exclusion
 	 */
-	if (cpuc->is_fake)
+	if (cpuc->is_fake || !is_ht_workaround_enabled())
 		return c;
 
 	/*
@@ -2610,7 +2610,7 @@ static __init void intel_nehalem_quirk(void)
  */
 static __init void intel_ht_bug(void)
 {
-	x86_pmu.flags |= PMU_FL_EXCL_CNTRS;
+	x86_pmu.flags |= PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED;
 
 	x86_pmu.commit_scheduling = intel_commit_scheduling;
 	x86_pmu.start_scheduling = intel_start_scheduling;
-- 
1.7.9.5

