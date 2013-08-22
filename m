Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3HVOOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:52 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:32824 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3HVOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:50 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 09/12] perf, persistent: Use unique event ids
Date: Thu, 22 Aug 2013 16:13:24 +0200
Message-Id: <1377180807-12758-10-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Tracepoints have a unique attr.config value. But, this is not
sufficient to support all event types. For this we need to generate
unique event ids.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index aca1e98..f23270b 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -1,6 +1,7 @@
 #include <linux/slab.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
+#include <linux/idr.h>
 
 #include "internal.h"
 
@@ -13,10 +14,37 @@ struct pevent {
 	int		id;
 };
 
+static struct idr event_idr;
+static struct mutex event_lock;
 static struct pmu persistent_pmu;
 static DEFINE_PER_CPU(struct list_head, pevents);
 static DEFINE_PER_CPU(struct mutex, pevents_lock);
 
+static inline struct pevent *find_event(int id)
+{
+	struct pevent *pevent;
+	rcu_read_lock();
+	pevent = idr_find(&event_idr, id);
+	rcu_read_lock();
+	return pevent;
+}
+
+static inline int get_event_id(struct pevent *pevent)
+{
+	int event_id;
+	mutex_lock(&event_lock);
+	event_id = idr_alloc(&event_idr, pevent, 1, INT_MAX, GFP_KERNEL);
+	mutex_unlock(&event_lock);
+	return event_id;
+}
+
+static inline void put_event_id(int id)
+{
+	mutex_lock(&event_lock);
+	idr_remove(&event_idr, id);
+	mutex_unlock(&event_lock);
+}
+
 /* Must be protected with pevents_lock. */
 static struct perf_event *__pevent_find(int cpu, int id)
 {
@@ -128,13 +156,16 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 	struct pevent *pevent;
 	char id_buf[32];
 	int cpu;
-	int ret = 0;
+	int ret;
 
 	pevent = kzalloc(sizeof(*pevent), GFP_KERNEL);
 	if (!pevent)
 		return -ENOMEM;
 
-	pevent->id = attr->config;
+	ret = get_event_id(pevent);
+	if (ret < 0)
+		goto fail;
+	pevent->id = ret;
 
 	if (!name) {
 		snprintf(id_buf, sizeof(id_buf), "%d", pevent->id);
@@ -163,6 +194,9 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 fail:
 	for_each_possible_cpu(cpu)
 		persistent_event_close(cpu, pevent);
+
+	if (pevent->id)
+		put_event_id(pevent->id);
 	kfree(pevent->name);
 	kfree(pevent);
 
@@ -306,6 +340,8 @@ void __init perf_register_persistent(void)
 {
 	int cpu;
 
+	idr_init(&event_idr);
+	mutex_init(&event_lock);
 	perf_pmu_register(&persistent_pmu, "persistent", PERF_TYPE_PERSISTENT);
 
 	for_each_possible_cpu(cpu) {
-- 
1.8.3.2

