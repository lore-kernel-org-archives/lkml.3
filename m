Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613Ab3DBJj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:39:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964Ab3DBJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:39:55 -0400
Date: Tue, 2 Apr 2013 02:39:41 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-3a54aaa0a3ddb2cf2ec1b94a94024e9a8a8af962@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1359040242-8269-3-git-send-email-eranian@google.com>
References: <1359040242-8269-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Improve sysfs event mapping with event string
Git-Commit-ID: 3a54aaa0a3ddb2cf2ec1b94a94024e9a8a8af962
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:39:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a54aaa0a3ddb2cf2ec1b94a94024e9a8a8af962
Gitweb:     http://git.kernel.org/tip/3a54aaa0a3ddb2cf2ec1b94a94024e9a8a8af962
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:26 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 26 Mar 2013 17:36:45 -0300

perf/x86: Improve sysfs event mapping with event string

This patch extends Jiri's changes to make generic
events mapping visible via sysfs. The patch extends
the mechanism to non-generic events by allowing
the mappings to be hardcoded in strings.

This mechanism will be used by the PEBS-LL patch
later on.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ fixed up conflict with 2663960 "perf: Make EVENT_ATTR global" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c | 20 ++++++++++++--------
 arch/x86/kernel/cpu/perf_event.h | 17 +++++++++++++++++
 include/linux/perf_event.h       |  1 +
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c886dc8..6e8ab04 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1316,9 +1316,16 @@ static struct attribute_group x86_pmu_format_group = {
  */
 static void __init filter_events(struct attribute **attrs)
 {
+	struct device_attribute *d;
+	struct perf_pmu_events_attr *pmu_attr;
 	int i, j;
 
 	for (i = 0; attrs[i]; i++) {
+		d = (struct device_attribute *)attrs[i];
+		pmu_attr = container_of(d, struct perf_pmu_events_attr, attr);
+		/* str trumps id */
+		if (pmu_attr->event_str)
+			continue;
 		if (x86_pmu.event_map(i))
 			continue;
 
@@ -1361,17 +1368,14 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
 {
 	struct perf_pmu_events_attr *pmu_attr = \
 		container_of(attr, struct perf_pmu_events_attr, attr);
-
 	u64 config = x86_pmu.event_map(pmu_attr->id);
-	return x86_pmu.events_sysfs_show(page, config);
-}
 
-#define EVENT_VAR(_id)  event_attr_##_id
-#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+	/* string trumps id */
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s", pmu_attr->event_str);
 
-#define EVENT_ATTR(_name, _id)						\
-	PMU_EVENT_ATTR(_name, EVENT_VAR(_id), PERF_COUNT_HW_##_id,	\
-			events_sysfs_show)
+	return x86_pmu.events_sysfs_show(page, config);
+}
 
 EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
 EVENT_ATTR(instructions,		INSTRUCTIONS		);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 95152c1..b1518ee 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -422,6 +422,23 @@ do {									\
 #define ERF_NO_HT_SHARING	1
 #define ERF_HAS_RSP_1		2
 
+#define EVENT_VAR(_id)  event_attr_##_id
+#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+
+#define EVENT_ATTR(_name, _id)						\
+static struct perf_pmu_events_attr EVENT_VAR(_id) = {			\
+	.attr		= __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id		= PERF_COUNT_HW_##_id,				\
+	.event_str	= NULL,						\
+};
+
+#define EVENT_ATTR_STR(_name, v, str)					\
+static struct perf_pmu_events_attr event_attr_##v = {			\
+	.attr		= __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id		= 0,						\
+	.event_str	= str,						\
+};
+
 extern struct x86_pmu x86_pmu __read_mostly;
 
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8737e1c..1c59211 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -809,6 +809,7 @@ do {									\
 struct perf_pmu_events_attr {
 	struct device_attribute attr;
 	u64 id;
+	const char *event_str;
 };
 
 #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
