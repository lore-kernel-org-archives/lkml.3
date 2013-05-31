Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3EaItH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:49:07 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45891 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3EaIsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:35 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 15/16] perf, persistent: Exposing persistent events using sysfs
Date: Fri, 31 May 2013 10:47:35 +0200
Message-Id: <1369990056-10310-16-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Expose persistent events in the system to userland using sysfs. Perf
tools are able to read existing pmu events from sysfs. Now we use a
persistent pmu as an event container containing all registered
persistent events of the system. This patch adds dynamically
registration of persistent events to sysfs. E.g. something like this:

 /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
 /sys/bus/event_source/devices/persistent/format/persistent:attr5:23

Perf tools need to support the attr<num> syntax that is added in a
separate patch set. With it we are able to run perf tool commands to
read persistent events, e.g.:

 # perf record -e persistent/mce_record/ sleep 10
 # perf top -e persistent/mce_record/

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index d5093a3..a764144 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -17,8 +17,10 @@ struct pers_event_desc {
 struct pers_event {
 	char				*name;
 	struct perf_event_attr		attr;
+	struct perf_pmu_events_attr	sysfs;
 };
 
+static struct pmu persistent_pmu;
 static DEFINE_PER_CPU(struct list_head, pers_events);
 static DEFINE_PER_CPU(struct mutex, pers_events_lock);
 
@@ -137,6 +139,8 @@ unwind:
 	return PTR_ERR(event);
 }
 
+static int pers_event_sysfs_register(struct pers_event *event);
+
 int perf_add_persistent_event_by_id(char* name, int id)
 {
 	struct pers_event	*event;
@@ -150,6 +154,8 @@ int perf_add_persistent_event_by_id(char* name, int id)
 	if (!event->name)
 		goto fail;
 
+	event->sysfs.id		= id;
+
 	attr = &event->attr;
 	attr->sample_period	= 1;
 	attr->wakeup_events	= 1;
@@ -163,6 +169,8 @@ int perf_add_persistent_event_by_id(char* name, int id)
 	if (ret)
 		goto fail;
 
+	pers_event_sysfs_register(event);
+
 	return 0;
 fail:
 	kfree(event->name);
@@ -204,12 +212,57 @@ static struct attribute_group persistent_format_group = {
 	.attrs = persistent_format_attrs,
 };
 
+#define MAX_EVENTS 16
+
+static struct attribute *persistent_events_attr[MAX_EVENTS + 1] = { };
+
+static struct attribute_group persistent_events_group = {
+	.name = "events",
+	.attrs = persistent_events_attr,
+};
+
 static const struct attribute_group *persistent_attr_groups[] = {
 	&persistent_format_group,
+	NULL, /* placeholder: &persistent_events_group */
 	NULL,
 };
+#define EVENTS_GROUP	(persistent_attr_groups[1])
 
-static struct pmu persistent_pmu;
+static ssize_t pers_event_sysfs_show(struct device *dev,
+				struct device_attribute *__attr, char *page)
+{
+	struct perf_pmu_events_attr *attr =
+		container_of(__attr, struct perf_pmu_events_attr, attr);
+	return sprintf(page, "persistent,config=%lld",
+		(unsigned long long)attr->id);
+}
+
+static int pers_event_sysfs_register(struct pers_event *event)
+{
+	struct device_attribute *attr = &event->sysfs.attr;
+	int idx;
+
+	*attr = (struct device_attribute)__ATTR(, 0444, pers_event_sysfs_show,
+						NULL);
+	attr->attr.name = event->name;
+
+	/* add sysfs attr to events: */
+	for (idx = 0; idx < MAX_EVENTS; idx++) {
+		if (!cmpxchg(persistent_events_attr + idx, NULL, &attr->attr))
+			break;
+	}
+
+	if (idx >= MAX_EVENTS)
+		return -ENOSPC;
+	if (!idx)
+		EVENTS_GROUP = &persistent_events_group;
+	if (!persistent_pmu.dev)
+		return 0;	/* sysfs not yet initialized */
+	if (idx)
+		return sysfs_update_group(&persistent_pmu.dev->kobj,
+					EVENTS_GROUP);
+	return sysfs_create_group(&persistent_pmu.dev->kobj, EVENTS_GROUP);
+}
 
 static int persistent_pmu_init(struct perf_event *event)
 {
-- 
1.8.1.1

