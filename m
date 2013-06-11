Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3FKQnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:43:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3FKQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:43:12 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 13/14] perf, persistent: Exposing persistent events using sysfs
Date: Tue, 11 Jun 2013 18:42:39 +0200
Message-Id: <1370968960-22527-14-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

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

[ Document attr<index> syntax in sysfs ABI ]
Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 .../testing/sysfs-bus-event_source-devices-format  | 43 ++++++++++++-----
 kernel/events/persistent.c                         | 55 +++++++++++++++++++++-
 2 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 77f47ff..47b7353 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -1,13 +1,14 @@
-Where:		/sys/bus/event_source/devices/<dev>/format
+Where:		/sys/bus/event_source/devices/<pmu>/format/<name>
 Date:		January 2012
-Kernel Version: 3.3
+Kernel Version:	3.3
+		3.12	(added attr<index>:<bits>)
 Contact:	Jiri Olsa <jolsa@redhat.com>
-Description:
-		Attribute group to describe the magic bits that go into
-		perf_event_attr::config[012] for a particular pmu.
-		Each attribute of this group defines the 'hardware' bitmask
-		we want to export, so that userspace can deal with sane
-		name/value pairs.
+
+Description:	Define formats for bit ranges in perf_event_attr
+
+		Attribute group to describe the magic bits that go
+		into struct perf_event_attr for a particular pmu. Bit
+		range may be any bit mask of an u64 (bits 0 to 63).
 
 		Userspace must be prepared for the possibility that attributes
 		define overlapping bit ranges. For example:
@@ -15,6 +16,26 @@ Description:
 			attr2 = 'config:0-7'
 			attr3 = 'config:12-35'
 
-		Example: 'config1:1,6-10,44'
-		Defines contents of attribute that occupies bits 1,6-10,44 of
-		perf_event_attr::config1.
+		Syntax			Description
+
+		config[012]*:<bits>	Each attribute of this group
+					defines the 'hardware' bitmask
+					we want to export, so that
+					userspace can deal with sane
+					name/value pairs.
+
+		attr<index>:<bits>	Set any field of the event
+					attribute. The index is a
+					decimal number that specifies
+					the u64 value to be set within
+					struct perf_event_attr.
+
+		Examples:
+
+		'config1:1,6-10,44'	Defines contents of attribute
+					that occupies bits 1,6-10,44
+					of perf_event_attr::config1.
+
+		'attr5:23'		Define the persistent event
+					flag (bit 23 of the attribute
+					flags)
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 96201c1..8be7c05 100644
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
@@ -207,12 +215,57 @@ static struct attribute_group persistent_format_group = {
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

