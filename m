Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaDGPFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:05:31 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51933 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDGPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:22 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 11/16] perf, persistent: Dynamically resize list of sysfs entries
Date: Mon,  7 Apr 2014 17:04:33 +0200
Message-Id: <1396883078-25320-12-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
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
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 kernel/events/persistent.c | 115 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 99 insertions(+), 16 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index fcbb4f8..49bf889 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -154,6 +154,7 @@ static void persistent_event_close(int cpu, struct pevent *pevent)
 }
 
 static int pevent_sysfs_register(struct pevent *event);
+static void pevent_sysfs_unregister(struct pevent *event);
 
 static int __maybe_unused
 persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
@@ -204,6 +205,7 @@ fail:
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
1.7.11.7

