Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaDGPJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:09:21 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51563 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaDGPFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:11 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 07/16] perf, persistent: Implementing a persistent pmu
Date: Mon,  7 Apr 2014 17:04:29 +0200
Message-Id: <1396883078-25320-8-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

We want to use the kernel's pmu design to later expose persistent
events via sysfs to userland. Initially implement a persistent pmu.

The format syntax is introduced allowing to set bits anywhere in
struct perf_event_attr. This is used in this case to set the
persistent flag (attr5:24). The syntax is attr<num> where num is the
index of the u64 array in struct perf_event_attr. Otherwise syntax is
same as for config<num>.

Patches that implement this functionality for perf tools are sent in a
separate patchset.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 kernel/events/persistent.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 78fdd74..6b039f5 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -12,6 +12,7 @@ struct pevent {
 	int		id;
 };
 
+static struct pmu persistent_pmu;
 static DEFINE_PER_CPU(struct list_head, pevents);
 static DEFINE_PER_CPU(struct mutex, pevents_lock);
 
@@ -210,10 +211,43 @@ int perf_get_persistent_event_fd(int cpu, int id)
 	return event_fd;
 }
 
+PMU_FORMAT_ATTR(persistent, "attr5:24");
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
 void __init perf_register_persistent(void)
 {
 	int cpu;
 
+	perf_pmu_register(&persistent_pmu, "persistent", PERF_TYPE_PERSISTENT);
+
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(pevents, cpu));
 		mutex_init(&per_cpu(pevents_lock, cpu));
-- 
1.7.11.7

