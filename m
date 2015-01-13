Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbAMW75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:59:57 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:36357 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbAMW74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:59:56 -0500
Date: Tue, 13 Jan 2015 23:59:53 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        vincent.weaver@maine.edu, jolsa@redhat.com
Subject: [PATCH] perf/rapl: fix sysfs_show() initialization for RAPL PMU
Message-ID: <20150113225953.GA21525@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a problem with the initialization of the
sysfs_show() routine for the RAPL PMU.

The current code was wrongly relying on the EVENT_ATTR_STR()
macro which uses the events_sysfs_show() function in the x86
PMU code. That function itself was relying on the x86_pmu data
structure. Yet RAPL and the core PMU (x86_pmu) have nothing to
do with each other. They should therefore not interact with
each other.

The x86_pmu structure is initialized at boot time based on
the host CPU model. When the host CPU is not supported, the
x86_pmu remains uninitialized and some of the callbacks it
contains are NULL.

The false dependency with x86_pmu could potentially cause crashes
in case the x86_pmu is not initialized while the RAPL PMU is. This
may, for instance, be the case in virtualized environments.

This patch fixes the problem by using a private sysfs_show()
routine for exporting the RAPL PMU events.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 44 +++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 673f930..6e434f8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -103,6 +103,13 @@ static struct kobj_attribute format_attr_##_var =		\
 
 #define RAPL_CNTR_WIDTH 32 /* 32-bit rapl counters */
 
+#define RAPL_EVENT_ATTR_STR(_name, v, str)				\
+static struct perf_pmu_events_attr event_attr_##v = {			\
+	.attr		= __ATTR(_name, 0444, rapl_sysfs_show, NULL),	\
+	.id		= 0,						\
+	.event_str	= str,						\
+};
+
 struct rapl_pmu {
 	spinlock_t	 lock;
 	int		 hw_unit;  /* 1/2^hw_unit Joule */
@@ -379,23 +386,36 @@ static struct attribute_group rapl_pmu_attr_group = {
 	.attrs = rapl_pmu_attrs,
 };
 
-EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
-EVENT_ATTR_STR(energy-pkg  ,   rapl_pkg, "event=0x02");
-EVENT_ATTR_STR(energy-ram  ,   rapl_ram, "event=0x03");
-EVENT_ATTR_STR(energy-gpu  ,   rapl_gpu, "event=0x04");
+static ssize_t rapl_sysfs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr = \
+		container_of(attr, struct perf_pmu_events_attr, attr);
+
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s", pmu_attr->event_str);
+
+	return 0;
+}
+
+RAPL_EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
+RAPL_EVENT_ATTR_STR(energy-pkg  ,   rapl_pkg, "event=0x02");
+RAPL_EVENT_ATTR_STR(energy-ram  ,   rapl_ram, "event=0x03");
+RAPL_EVENT_ATTR_STR(energy-gpu  ,   rapl_gpu, "event=0x04");
 
-EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
-EVENT_ATTR_STR(energy-pkg.unit  ,   rapl_pkg_unit, "Joules");
-EVENT_ATTR_STR(energy-ram.unit  ,   rapl_ram_unit, "Joules");
-EVENT_ATTR_STR(energy-gpu.unit  ,   rapl_gpu_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-pkg.unit  ,   rapl_pkg_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-ram.unit  ,   rapl_ram_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-gpu.unit  ,   rapl_gpu_unit, "Joules");
 
 /*
  * we compute in 0.23 nJ increments regardless of MSR
  */
-EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-pkg.scale,     rapl_pkg_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-ram.scale,     rapl_ram_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-gpu.scale,     rapl_gpu_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-pkg.scale,     rapl_pkg_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-ram.scale,     rapl_ram_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-gpu.scale,     rapl_gpu_scale, "2.3283064365386962890625e-10");
 
 static struct attribute *rapl_events_srv_attr[] = {
 	EVENT_PTR(rapl_cores),
-- 
1.9.1

