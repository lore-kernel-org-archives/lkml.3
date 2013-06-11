Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3FKQnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:43:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34756 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3FKQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:43:03 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 07/14] perf, persistent: Introduce get_persistent_event()
Date: Tue, 11 Jun 2013 18:42:33 +0200
Message-Id: <1370968960-22527-8-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Reducing duplicate code by introducing function get_persistent_event()
to get the descriptor of an persistent event.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index e6a7664..7d91871 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -16,6 +16,19 @@ struct pers_event_desc {
 
 static DEFINE_PER_CPU(struct list_head, pers_events);
 
+static struct pers_event_desc
+*get_persistent_event(int cpu, struct perf_event_attr *attr)
+{
+	struct pers_event_desc *desc;
+
+	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist) {
+		if (desc->event->attr.config == attr->config)
+			return desc;
+	}
+
+	return NULL;
+}
+
 static struct perf_event *
 add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 			    unsigned nr_pages)
@@ -58,18 +71,13 @@ out:
 
 static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 {
-	struct pers_event_desc *desc, *tmp;
-	struct perf_event *event = NULL;
-
-	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
-		if (desc->event->attr.config == attr->config) {
-			event = desc->event;
-			break;
-		}
-	}
+	struct pers_event_desc *desc;
+	struct perf_event *event;
 
-	if (!event)
+	desc = get_persistent_event(cpu, attr);
+	if (!desc)
 		return;
+	event = desc->event;
 
 	list_del(&desc->plist);
 
@@ -161,11 +169,11 @@ int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 	if (cpu >= (unsigned)nr_cpu_ids)
 		return -EINVAL;
 
-	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
-		if (desc->event->attr.config == attr->config)
-			return __alloc_persistent_event_fd(desc);
+	desc = get_persistent_event(cpu, attr);
+	if (!desc)
+		return -ENODEV;
 
-	return -ENODEV;
+	return __alloc_persistent_event_fd(desc);
 }
 
 
-- 
1.8.1.1

