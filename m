Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3FKQnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:43:12 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43225 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3FKQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:43:09 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 11/14] perf, persistent: Implementing a persistent pmu
Date: Tue, 11 Jun 2013 18:42:37 +0200
Message-Id: <1370968960-22527-12-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

We want to use the kernel's pmu design to later expose persistent
events via sysfs to userland. Initially implement a persistent pmu.

The format syntax is introduced allowing to set bits anywhere in
struct perf_event_attr. This is used in this case to set the
persistent flag (attr5:23). The syntax is attr<num> where num is the
index of the u64 array in struct perf_event_attr. Otherwise syntax is
same as for config<num>.

Patches that implement this functionality for perf tools are sent in a
separate patchset.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 4fcd071..97c57c9 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -175,10 +175,45 @@ out:
 	return event_fd;
 }
 
+PMU_FORMAT_ATTR(persistent, "attr5:23");
+
+static struct attribute *persistent_format_attrs[] = {
+	&format_attr_persistent.attr,
+	NULL,
+};
+
+static struct attribute_group persistent_format_group = {
+	.name = "format",
+	.attrs = persistent_format_attrs,
+};
+
+static const struct attribute_group *persistent_attr_groups[] = {
+	&persistent_format_group,
+	NULL,
+};
+
+static struct pmu persistent_pmu;
+
+static int persistent_pmu_init(struct perf_event *event)
+{
+	if (persistent_pmu.type != event->attr.type)
+		return -ENOENT;
+
+	/* Not a persistent event. */
+	return -EFAULT;
+}
+
+static struct pmu persistent_pmu = {
+	.event_init	= persistent_pmu_init,
+	.attr_groups	= persistent_attr_groups,
+};
+
 void __init persistent_events_init(void)
 {
 	int cpu;
 
+	perf_pmu_register(&persistent_pmu, "persistent", -1);
+
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(pers_events, cpu));
 		mutex_init(&per_cpu(pers_events_lock, cpu));
-- 
1.8.1.1

