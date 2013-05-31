Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3EaIt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:49:58 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56104 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3EaIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:33 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 14/16] perf, persistent: Name each persistent event
Date: Fri, 31 May 2013 10:47:34 +0200
Message-Id: <1369990056-10310-15-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

For later adding persistent events to sysfs we need a name for each
event. Adding a name to each persistent event.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |  3 ++-
 include/linux/perf_event.h       |  4 ++--
 kernel/events/persistent.c       | 30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d421937..833eb7a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1991,7 +1991,8 @@ int __init mcheck_init(void)
 
 int __init mcheck_init_tp(void)
 {
-	if (perf_add_persistent_event_by_id(event_mce_record.event.type)) {
+	if (perf_add_persistent_event_by_id(event_mce_record.name,
+					    event_mce_record.event.type)) {
 		pr_err("Error adding MCE persistent event.\n");
 		return -EINVAL;
 	}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dc72c93..06b4357b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -751,7 +751,7 @@ extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
 extern int perf_add_persistent_event(struct perf_event_attr *, unsigned);
-extern int perf_add_persistent_event_by_id(int id);
+extern int perf_add_persistent_event_by_id(char *name, int id);
 #else /* !CONFIG_PERF_EVENTS */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -794,7 +794,7 @@ static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 static inline int perf_add_persistent_event(struct perf_event_attr *attr,
 					    unsigned nr_pages)		{ return -EINVAL; }
-static inline int perf_add_persistent_event_by_id(int id)		{ return -EINVAL; }
+static inline int perf_add_persistent_event_by_id(char *name, int id)	{ return -EINVAL; }
 #endif /* !CONFIG_PERF_EVENTS */
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_NO_HZ_FULL)
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 95d6943..d5093a3 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -14,6 +14,11 @@ struct pers_event_desc {
 	int fd;
 };
 
+struct pers_event {
+	char				*name;
+	struct perf_event_attr		attr;
+};
+
 static DEFINE_PER_CPU(struct list_head, pers_events);
 static DEFINE_PER_CPU(struct mutex, pers_events_lock);
 
@@ -132,14 +137,20 @@ unwind:
 	return PTR_ERR(event);
 }
 
-int perf_add_persistent_event_by_id(int id)
+int perf_add_persistent_event_by_id(char* name, int id)
 {
-	struct perf_event_attr *attr;
+	struct pers_event	*event;
+	struct perf_event_attr	*attr;
+	int ret = -ENOMEM;
 
-	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
 		return -ENOMEM;
+	event->name = kstrdup(name, GFP_KERNEL);
+	if (!event->name)
+		goto fail;
 
+	attr = &event->attr;
 	attr->sample_period	= 1;
 	attr->wakeup_events	= 1;
 	attr->sample_type	= PERF_SAMPLE_RAW;
@@ -148,7 +159,16 @@ int perf_add_persistent_event_by_id(int id)
 	attr->type		= PERF_TYPE_TRACEPOINT;
 	attr->size		= sizeof(*attr);
 
-	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
+	ret = perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
+	if (ret)
+		goto fail;
+
+	return 0;
+fail:
+	kfree(event->name);
+	kfree(event);
+
+	return ret;
 }
 
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
-- 
1.8.1.1

