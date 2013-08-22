Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3HVOPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:15:39 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56977 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3HVOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:55 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 11/12] perf, persistent: Dynamically resize list of sysfs entries
Date: Thu, 22 Aug 2013 16:13:26 +0200
Message-Id: <1377180807-12758-12-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

There was a limitation of the total number of persistent events to be
registered in sysfs due to the lack of dynamically list allocation.
This patch implements memory reallocation in case an event is added or
removed from the list.

While at this also implement pevent_sysfs_unregister() which we need
later for proper event removal.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 115 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 99 insertions(+), 16 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 70446ae..a0ef6d4 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -154,6 +154,7 @@ static void persistent_event_close(int cpu, struct pevent *pevent)
 }
 
 static int pevent_sysfs_register(struct pevent *event);
+static void pevent_sysfs_unregister(struct pevent *event);
 
 static int __maybe_unused
 persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
@@ -204,6 +205,7 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 		__func__, ret);
 out:
 	if (atomic_dec_and_test(&pevent->refcount)) {
+		pevent_sysfs_unregister(pevent);
 		if (pevent->id)
 			put_event_id(pevent->id);
 		kfree(pevent->name);
@@ -273,13 +275,12 @@ static struct attribute_group persistent_format_group = {
 	.attrs = persistent_format_attrs,
 };
 
-#define MAX_EVENTS 16
-
-static struct attribute *pevents_attr[MAX_EVENTS + 1] = { };
+static struct mutex sysfs_lock;
+static int sysfs_nr_entries;
 
 static struct attribute_group pevents_group = {
 	.name = "events",
-	.attrs = pevents_attr,
+	.attrs = NULL,		/* dynamically allocated */
 };
 
 static const struct attribute_group *persistent_attr_groups[] = {
@@ -288,6 +289,7 @@ static const struct attribute_group *persistent_attr_groups[] = {
 	NULL,
 };
 #define EVENTS_GROUP_PTR	(&persistent_attr_groups[1])
+#define EVENTS_ATTRS_PTR	(&pevents_group.attrs)
 
 static ssize_t pevent_sysfs_show(struct device *dev,
 				struct device_attribute *__attr, char *page)
@@ -304,7 +306,9 @@ static int pevent_sysfs_register(struct pevent *pevent)
 	struct attribute *attr = &sysfs->attr.attr;
 	struct device *dev = persistent_pmu.dev;
 	const struct attribute_group **group = EVENTS_GROUP_PTR;
-	int idx;
+	struct attribute ***attrs_ptr = EVENTS_ATTRS_PTR;
+	struct attribute **attrs;
+	int ret = 0;
 
 	sysfs->id	= pevent->id;
 	sysfs->attr	= (struct device_attribute)
@@ -312,21 +316,99 @@ static int pevent_sysfs_register(struct pevent *pevent)
 	attr->name	= pevent->name;
 	sysfs_attr_init(attr);
 
-	/* add sysfs attr to events: */
-	for (idx = 0; idx < MAX_EVENTS; idx++) {
-		if (!cmpxchg(pevents_attr + idx, NULL, attr))
-			break;
+	mutex_lock(&sysfs_lock);
+
+	/*
+	 * Keep old list if no new one is available. Need this for
+	 * device_remove_attrs() if unregistering pmu.
+	 */
+	attrs = __krealloc(*attrs_ptr, (sysfs_nr_entries + 2) * sizeof(*attrs),
+			GFP_KERNEL);
+
+	if (!attrs) {
+		ret = -ENOMEM;
+		goto unlock;
 	}
 
-	if (idx >= MAX_EVENTS)
-		return -ENOSPC;
-	if (!idx)
+	attrs[sysfs_nr_entries++]	= attr;
+	attrs[sysfs_nr_entries]		= NULL;
+
+	if (!*group)
 		*group = &pevents_group;
+
+	if (!dev)
+		goto out;	/* sysfs not yet initialized */
+
+	if (sysfs_nr_entries == 1)
+		ret = sysfs_create_group(&dev->kobj, *group);
+	else
+		ret = sysfs_add_file_to_group(&dev->kobj, attr, (*group)->name);
+
+	if (ret) {
+		/* roll back */
+		sysfs_nr_entries--;
+		if (!sysfs_nr_entries)
+			*group = NULL;
+		if (*attrs_ptr != attrs)
+			kfree(attrs);
+		else
+			attrs[sysfs_nr_entries] = NULL;
+		goto unlock;
+	}
+out:
+	if (*attrs_ptr != attrs) {
+		kfree(*attrs_ptr);
+		*attrs_ptr = attrs;
+	}
+unlock:
+	mutex_unlock(&sysfs_lock);
+
+	return ret;
+}
+
+static void pevent_sysfs_unregister(struct pevent *pevent)
+{
+	struct attribute *attr = &pevent->sysfs.attr.attr;
+	struct device *dev = persistent_pmu.dev;
+	const struct attribute_group **group = EVENTS_GROUP_PTR;
+	struct attribute ***attrs_ptr = EVENTS_ATTRS_PTR;
+	struct attribute **attrs, **dest;
+
+	mutex_lock(&sysfs_lock);
+
+	for (dest = *attrs_ptr; *dest; dest++) {
+		if (*dest == attr)
+			break;
+	}
+
+	if (!*dest)
+		goto unlock;
+
+	sysfs_nr_entries--;
+
+	*dest = (*attrs_ptr)[sysfs_nr_entries];
+	(*attrs_ptr)[sysfs_nr_entries] = NULL;
+
 	if (!dev)
-		return 0;	/* sysfs not yet initialized */
-	if (idx)
-		return sysfs_add_file_to_group(&dev->kobj, attr, (*group)->name);
-	return sysfs_create_group(&persistent_pmu.dev->kobj, *group);
+		goto out;	/* sysfs not yet initialized */
+
+	if (!sysfs_nr_entries)
+		sysfs_remove_group(&dev->kobj, *group);
+	else
+		sysfs_remove_file_from_group(&dev->kobj, attr, (*group)->name);
+out:
+	if (!sysfs_nr_entries)
+		*group = NULL;
+
+	attrs = __krealloc(*attrs_ptr, (sysfs_nr_entries + 1) * sizeof(*attrs),
+			GFP_KERNEL);
+
+	if (!attrs && *attrs_ptr != attrs) {
+		kfree(*attrs_ptr);
+		*attrs_ptr = attrs;
+	}
+unlock:
+	mutex_unlock(&sysfs_lock);
 }
 
 static int persistent_pmu_init(struct perf_event *event)
@@ -349,6 +431,7 @@ void __init perf_register_persistent(void)
 
 	idr_init(&event_idr);
 	mutex_init(&event_lock);
+	mutex_init(&sysfs_lock);
 	perf_pmu_register(&persistent_pmu, "persistent", PERF_TYPE_PERSISTENT);
 
 	for_each_possible_cpu(cpu) {
-- 
1.8.3.2

