Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3HVOQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:16:30 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:42113 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HVOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:49 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Robert Richter <rric@kernel.org>
Subject: [PATCH v3 08/12] perf, persistent: Exposing persistent events using sysfs
Date: Thu, 22 Aug 2013 16:13:23 +0200
Message-Id: <1377180807-12758-9-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
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

[ Jiri: Document attr<index> syntax in sysfs ABI ]
[ Namhyung: Fix sysfs registration with lockdep enabled ]
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 .../testing/sysfs-bus-event_source-devices-format  | 43 ++++++++++++----
 kernel/events/persistent.c                         | 60 ++++++++++++++++++++++
 2 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 77f47ff..2dbb911 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -1,13 +1,14 @@
-Where:		/sys/bus/event_source/devices/<dev>/format
+Where:		/sys/bus/event_source/devices/<pmu>/format/<name>
 Date:		January 2012
-Kernel Version: 3.3
+Kernel Version:	3.3
+		3.xx	(added attr<index>:<bits>)
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
@@ -15,6 +16,26 @@ Contact:	Jiri Olsa <jolsa@redhat.com>
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
index ede95ab..aca1e98 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -8,6 +8,7 @@
 #define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
 
 struct pevent {
+	struct perf_pmu_events_attr sysfs;
 	char		*name;
 	int		id;
 };
@@ -119,6 +120,8 @@ static void persistent_event_close(int cpu, struct pevent *pevent)
 		persistent_event_release(event);
 }
 
+static int pevent_sysfs_register(struct pevent *event);
+
 static int __maybe_unused
 persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 {
@@ -144,12 +147,18 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 		goto fail;
 	}
 
+	pevent->sysfs.id = pevent->id;
+
 	for_each_possible_cpu(cpu) {
 		ret = persistent_event_open(cpu, pevent, attr, nr_pages);
 		if (ret)
 			goto fail;
 	}
 
+	ret = pevent_sysfs_register(pevent);
+	if (ret)
+		goto fail;
+
 	return 0;
 fail:
 	for_each_possible_cpu(cpu)
@@ -223,10 +232,61 @@ static struct attribute_group persistent_format_group = {
 	.attrs = persistent_format_attrs,
 };
 
+#define MAX_EVENTS 16
+
+static struct attribute *pevents_attr[MAX_EVENTS + 1] = { };
+
+static struct attribute_group pevents_group = {
+	.name = "events",
+	.attrs = pevents_attr,
+};
+
 static const struct attribute_group *persistent_attr_groups[] = {
 	&persistent_format_group,
+	NULL,			/* placeholder: &pevents_group */
 	NULL,
 };
+#define EVENTS_GROUP_PTR	(&persistent_attr_groups[1])
+
+static ssize_t pevent_sysfs_show(struct device *dev,
+				struct device_attribute *__attr, char *page)
+{
+	struct perf_pmu_events_attr *attr =
+		container_of(__attr, struct perf_pmu_events_attr, attr);
+	return sprintf(page, "persistent,config=%lld",
+		(unsigned long long)attr->id);
+}
+
+static int pevent_sysfs_register(struct pevent *pevent)
+{
+	struct perf_pmu_events_attr *sysfs = &pevent->sysfs;
+	struct attribute *attr = &sysfs->attr.attr;
+	struct device *dev = persistent_pmu.dev;
+	const struct attribute_group **group = EVENTS_GROUP_PTR;
+	int idx;
+
+	sysfs->id	= pevent->id;
+	sysfs->attr	= (struct device_attribute)
+				__ATTR(, 0444, pevent_sysfs_show, NULL);
+	attr->name	= pevent->name;
+	sysfs_attr_init(attr);
+
+	/* add sysfs attr to events: */
+	for (idx = 0; idx < MAX_EVENTS; idx++) {
+		if (!cmpxchg(pevents_attr + idx, NULL, attr))
+			break;
+	}
+
+	if (idx >= MAX_EVENTS)
+		return -ENOSPC;
+	if (!idx)
+		*group = &pevents_group;
+	if (!dev)
+		return 0;	/* sysfs not yet initialized */
+	if (idx)
+		return sysfs_add_file_to_group(&dev->kobj, attr, (*group)->name);
+	return sysfs_create_group(&persistent_pmu.dev->kobj, *group);
+}
 
 static int persistent_pmu_init(struct perf_event *event)
 {
-- 
1.8.3.2

