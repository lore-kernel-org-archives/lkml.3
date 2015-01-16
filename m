Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbbAPInS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:43:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbAPInR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:43:17 -0500
Date: Fri, 16 Jan 2015 00:42:33 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-433678bdc6ed39f053c55da96b51de5bf0aeebb1@git.kernel.org>
Cc: eranian@google.com, torvalds@linux-foundation.org, acme@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, peterz@infradead.org,
        hpa@zytor.com, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        acme@kernel.org, eranian@google.com
In-Reply-To: <20150113225953.GA21525@thinkpad>
References: <20150113225953.GA21525@thinkpad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/rapl: Fix sysfs_show()
  initialization for RAPL PMU
Git-Commit-ID: 433678bdc6ed39f053c55da96b51de5bf0aeebb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  433678bdc6ed39f053c55da96b51de5bf0aeebb1
Gitweb:     http://git.kernel.org/tip/433678bdc6ed39f053c55da96b51de5bf0aeebb1
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 13 Jan 2015 23:59:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Jan 2015 09:06:58 +0100

perf/rapl: Fix sysfs_show() initialization for RAPL PMU

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20150113225953.GA21525@thinkpad
Cc: vincent.weaver@maine.edu
Cc: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
