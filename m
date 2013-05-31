Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3EaIvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:51:03 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33620 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3EaIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:24 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 09/16] perf, persistent: Introduce get_persistent_event()
Date: Fri, 31 May 2013 10:47:29 +0200
Message-Id: <1369990056-10310-10-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Reducing duplicate code by introducing function get_persistent_event()
to get the descriptor of an persistent event.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index ff1ce3b..7d1aff3 100644
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
 
@@ -156,13 +164,12 @@ int perf_add_persistent_event_by_id(int id)
 
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 {
-	struct pers_event_desc *desc;
+	struct pers_event_desc *desc = get_persistent_event(cpu, attr);
 
-	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
-		if (desc->event->attr.config == attr->config)
-			return __alloc_persistent_event_fd(desc);
+	if (!desc)
+		return -ENODEV;
 
-	return -ENODEV;
+	return __alloc_persistent_event_fd(desc);
 }
 
 
-- 
1.8.1.1

