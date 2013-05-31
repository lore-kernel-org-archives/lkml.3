Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3EaIuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:50:51 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55842 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3EaIs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:28 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 11/16] perf, persistent: Protect event lists with mutex
Date: Fri, 31 May 2013 10:47:31 +0200
Message-Id: <1369990056-10310-12-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Protect esp. access to struct pers_event_desc *desc. There are race
conditions possible where the descriptor could be removed from list
while it is used.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 4ecbdab..ebef089 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -15,6 +15,7 @@ struct pers_event_desc {
 };
 
 static DEFINE_PER_CPU(struct list_head, pers_events);
+static DEFINE_PER_CPU(struct mutex, pers_events_lock);
 
 static struct pers_event_desc
 *get_persistent_event(int cpu, struct perf_event_attr *attr)
@@ -37,9 +38,13 @@ add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 	struct pers_event_desc *desc;
 	struct ring_buffer *buf;
 
+	mutex_lock(&per_cpu(pers_events_lock, cpu));
+
 	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return ERR_PTR(-ENOMEM);
+	if (!desc) {
+		event = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
 	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
 	if (IS_ERR(event))
@@ -66,6 +71,7 @@ err_rb:
 err_event:
 	kfree(desc);
 out:
+	mutex_unlock(&per_cpu(pers_events_lock, cpu));
 	return event;
 }
 
@@ -74,9 +80,11 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 	struct pers_event_desc *desc;
 	struct perf_event *event;
 
+	mutex_lock(&per_cpu(pers_events_lock, cpu));
+
 	desc = get_persistent_event(cpu, attr);
 	if (!desc)
-		return;
+		goto out;
 	event = desc->event;
 
 	list_del(&desc->plist);
@@ -85,6 +93,8 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 	perf_event_release_kernel(event);
 	put_unused_fd(desc->fd);
 	kfree(desc);
+out:
+	mutex_unlock(&per_cpu(pers_events_lock, cpu));
 }
 
 /*
@@ -137,25 +147,31 @@ int perf_add_persistent_event_by_id(int id)
 
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 {
-	struct pers_event_desc *desc = get_persistent_event(cpu, attr);
-	int event_fd;
+	struct pers_event_desc *desc;
+	int event_fd = -ENODEV;
 
+	mutex_lock(&per_cpu(pers_events_lock, cpu));
+
+	desc = get_persistent_event(cpu, attr);
 	if (!desc)
-		return -ENODEV;
+		goto out;
 
 	event_fd = anon_inode_getfd("[pers_event]", &perf_fops,
 				desc->event, O_RDONLY);
 	if (event_fd >= 0)
 		desc->fd = event_fd;
+out:
+	mutex_unlock(&per_cpu(pers_events_lock, cpu));
 
 	return event_fd;
 }
 
-
 void __init persistent_events_init(void)
 {
-	int i;
+	int cpu;
 
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(&per_cpu(pers_events, i));
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(&per_cpu(pers_events, cpu));
+		mutex_init(&per_cpu(pers_events_lock, cpu));
+	}
 }
-- 
1.8.1.1

