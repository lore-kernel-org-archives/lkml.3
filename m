Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3BALCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:02:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3BALCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:02:05 -0500
Date: Fri, 1 Feb 2013 03:01:36 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-1c53a270724df91276d28d66f8e5a302fc6a5d74@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20130123062454.GD13720@us.ibm.com>
References: <20130123062454.GD13720@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/POWER7:
  Make generic event translations available in sysfs
Git-Commit-ID: 1c53a270724df91276d28d66f8e5a302fc6a5d74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 03:01:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c53a270724df91276d28d66f8e5a302fc6a5d74
Gitweb:     http://git.kernel.org/tip/1c53a270724df91276d28d66f8e5a302fc6a5d74
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 22:24:54 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:50 -0300

perf/POWER7: Make generic event translations available in sysfs

Make the generic perf events in POWER7 available via sysfs.

	$ ls /sys/bus/event_source/devices/cpu/events
	branch-instructions
	branch-misses
	cache-misses
	cache-references
	cpu-cycles
	instructions
	stalled-cycles-backend
	stalled-cycles-frontend

	$ cat /sys/bus/event_source/devices/cpu/events/cache-misses
	event=0x400f0

This patch is based on commits that implement this functionality on x86.
Eg:
	commit a47473939db20e3961b200eb00acf5fcf084d755
	Author: Jiri Olsa <jolsa@redhat.com>
	Date:   Wed Oct 10 14:53:11 2012 +0200

	    perf/x86: Make hardware event translations available in sysfs

Changelog:[v2]
	[Jiri Osla] Drop EVENT_ID() macro since it is only used once.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130123062454.GD13720@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../ABI/stable/sysfs-devices-cpu-events            |  0
 arch/powerpc/include/asm/perf_event_server.h       | 23 +++++++++++++++
 arch/powerpc/perf/core-book3s.c                    | 12 ++++++++
 arch/powerpc/perf/power7-pmu.c                     | 34 ++++++++++++++++++++++
 4 files changed, 69 insertions(+)

diff --git a/tools/virtio/linux/hrtimer.h b/Documentation/ABI/stable/sysfs-devices-cpu-events
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to Documentation/ABI/stable/sysfs-devices-cpu-events
diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 9710be3..b9b6c55 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <asm/hw_irq.h>
+#include <linux/device.h>
 
 #define MAX_HWEVENTS		8
 #define MAX_EVENT_ALTERNATIVES	8
@@ -35,6 +36,7 @@ struct power_pmu {
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
 	u32		flags;
+	const struct attribute_group	**attr_groups;
 	int		n_generic;
 	int		*generic_events;
 	int		(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
@@ -109,3 +111,24 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
  * If an event_id is not subject to the constraint expressed by a particular
  * field, then it will have 0 in both the mask and value for that field.
  */
+
+extern ssize_t power_events_sysfs_show(struct device *dev,
+				struct device_attribute *attr, char *page);
+
+/*
+ * EVENT_VAR() is same as PMU_EVENT_VAR with a suffix.
+ *
+ * Having a suffix allows us to have aliases in sysfs - eg: the generic
+ * event 'cpu-cycles' can have two entries in sysfs: 'cpu-cycles' and
+ * 'PM_CYC' where the latter is the name by which the event is known in
+ * POWER CPU specification.
+ */
+#define	EVENT_VAR(_id, _suffix)		event_attr_##_id##_suffix
+#define	EVENT_PTR(_id, _suffix)		&EVENT_VAR(_id, _suffix)
+
+#define	EVENT_ATTR(_name, _id, _suffix)					\
+	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), PME_PM_##_id,	\
+			power_events_sysfs_show)
+
+#define	GENERIC_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _g)
+#define	GENERIC_EVENT_PTR(_id)		EVENT_PTR(_id, _g)
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index aa2465e..fa476d5 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1305,6 +1305,16 @@ static int power_pmu_event_idx(struct perf_event *event)
 	return event->hw.idx;
 }
 
+ssize_t power_events_sysfs_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr;
+
+	pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
+
+	return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
+}
+
 struct pmu power_pmu = {
 	.pmu_enable	= power_pmu_enable,
 	.pmu_disable	= power_pmu_disable,
@@ -1537,6 +1547,8 @@ int __cpuinit register_power_pmu(struct power_pmu *pmu)
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
+	power_pmu.attr_groups = ppmu->attr_groups;
+
 #ifdef MSR_HV
 	/*
 	 * Use FCHV to ignore kernel events if MSR.HV is set.
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index eebb36d..269bf24 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -374,6 +374,39 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
+
+GENERIC_EVENT_ATTR(cpu-cycles,			CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-frontend,	GCT_NOSLOT_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-backend,	CMPLU_STALL);
+GENERIC_EVENT_ATTR(instructions,		INST_CMPL);
+GENERIC_EVENT_ATTR(cache-references,		LD_REF_L1);
+GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
+GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
+GENERIC_EVENT_ATTR(branch-misses,		BRU_MPRED);
+
+static struct attribute *power7_events_attr[] = {
+	GENERIC_EVENT_PTR(CYC),
+	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
+	GENERIC_EVENT_PTR(CMPLU_STALL),
+	GENERIC_EVENT_PTR(INST_CMPL),
+	GENERIC_EVENT_PTR(LD_REF_L1),
+	GENERIC_EVENT_PTR(LD_MISS_L1),
+	GENERIC_EVENT_PTR(BRU_FIN),
+	GENERIC_EVENT_PTR(BRU_MPRED),
+	NULL
+};
+
+
+static struct attribute_group power7_pmu_events_group = {
+	.name = "events",
+	.attrs = power7_events_attr,
+};
+
+static const struct attribute_group *power7_pmu_attr_groups[] = {
+	&power7_pmu_events_group,
+	NULL,
+};
+
 static struct power_pmu power7_pmu = {
 	.name			= "POWER7",
 	.n_counter		= 6,
@@ -385,6 +418,7 @@ static struct power_pmu power7_pmu = {
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
 	.flags			= PPMU_ALT_SIPR,
+	.attr_groups		= power7_pmu_attr_groups,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
