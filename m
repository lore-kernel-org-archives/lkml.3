Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3HVOO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:58 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39045 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3HVOO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:56 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to control persistency
Date: Thu, 22 Aug 2013 16:13:27 +0200
Message-Id: <1377180807-12758-13-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Implementing ioctl functions to control persistent events. There are
functions to detach or attach an event to or from a process. The
PERF_EVENT_IOC_DETACH ioctl call makes an event persistent. After
closing the event's fd it runs then in the background of the system
without the need of a controlling process. The perf_event_open()
syscall can be used to reopen the event by any process. The
PERF_EVENT_IOC_ATTACH ioctl attaches the event again so that it is
removed after closing the event's fd.

This is for Linux man-pages:

    type ...

        PERF_TYPE_PERSISTENT (Since Linux 3.xx)

            This indicates a persistent event. There is a unique
            identifier for each persistent event that needs to be
            specified in the event's attribute config field.
            Persistent events are listed under:

              /sys/bus/event_source/devices/persistent/

    ...
    persistent : 41, /* always-on event */
    ...

    persistent: (Since Linux 3.xx)

        Put event into persistent state after opening. After closing
        the event's fd the event is persistent in the system and
        continues to run.

    perf_event ioctl calls

        PERF_EVENT_IOC_DETACH (Since Linux 3.xx)

            Detach the event specified by the file descriptor from the
            process and make it persistent in the system. After
            closing the fd the event will continue to run. An unique
            identifier for the persistent event is returned or an
            error otherwise. The following allows to connect to the
            event again:

                pe.type = PERF_TYPE_PERSISTENT;
                pe.config = <pevent_id>;
                ...
                fd = perf_event_open(...);

            The event must be reopened on the same cpu.

        PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)

            Attach the event specified by the file descriptor to the
            current process. The event is no longer persistent in the
            system and will be removed after all users disconnected
            from the event. Thus, if there are no other users the
            event will be closed too after closing its file
            descriptor, the event then no longer exists.

Cc: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 include/uapi/linux/perf_event.h |   2 +
 kernel/events/core.c            |   6 ++
 kernel/events/internal.h        |   2 +
 kernel/events/persistent.c      | 178 +++++++++++++++++++++++++++++++++-------
 4 files changed, 160 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 2b84b97..82a8244 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -324,6 +324,8 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
+#define PERF_EVENT_IOC_DETACH		_IO ('$', 8)
+#define PERF_EVENT_IOC_ATTACH		_IO ('$', 9)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d9d6e67..8d5c6e3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3622,6 +3622,12 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_DETACH:
+		return perf_event_detach(event);
+
+	case PERF_EVENT_IOC_ATTACH:
+		return perf_event_attach(event);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 94c3f73..f9bc15f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -195,5 +195,7 @@ extern void perf_free_rb(struct perf_event *event);
 extern int perf_get_fd(struct perf_event *event);
 extern int perf_get_persistent_event_fd(int cpu, int id);
 extern void __init perf_register_persistent(void);
+extern int perf_event_detach(struct perf_event *event);
+extern int perf_event_attach(struct perf_event *event);
 
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index a0ef6d4..e156afe 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -59,6 +59,49 @@ static struct perf_event *__pevent_find(int cpu, int id)
 	return NULL;
 }
 
+static void pevent_free(struct pevent *pevent)
+{
+	if (pevent->id)
+		put_event_id(pevent->id);
+
+	kfree(pevent->name);
+	kfree(pevent);
+}
+
+static struct pevent *pevent_alloc(char *name)
+{
+	struct pevent *pevent;
+	char id_buf[32];
+	int ret;
+
+	pevent = kzalloc(sizeof(*pevent), GFP_KERNEL);
+	if (!pevent)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&pevent->refcount, 1);
+
+	ret = get_event_id(pevent);
+	if (ret < 0)
+		goto fail;
+	pevent->id = ret;
+
+	if (!name) {
+		snprintf(id_buf, sizeof(id_buf), "%d", pevent->id);
+		name = id_buf;
+	}
+
+	pevent->name = kstrdup(name, GFP_KERNEL);
+	if (!pevent->name) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	return pevent;
+fail:
+	pevent_free(pevent);
+	return ERR_PTR(ret);
+}
+
 static int pevent_add(struct pevent *pevent, struct perf_event *event)
 {
 	int ret = -EEXIST;
@@ -74,6 +117,7 @@ static int pevent_add(struct pevent *pevent, struct perf_event *event)
 
 	ret = 0;
 	event->pevent_id = pevent->id;
+	event->attr.persistent = 1;
 	list_add_tail(&event->pevent_entry, &per_cpu(pevents, cpu));
 unlock:
 	mutex_unlock(&per_cpu(pevents_lock, cpu));
@@ -91,6 +135,7 @@ static struct perf_event *pevent_del(struct pevent *pevent, int cpu)
 	if (event) {
 		list_del(&event->pevent_entry);
 		event->pevent_id = 0;
+		event->attr.persistent = 0;
 	}
 
 	mutex_unlock(&per_cpu(pevents_lock, cpu));
@@ -160,33 +205,12 @@ static int __maybe_unused
 persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 {
 	struct pevent *pevent;
-	char id_buf[32];
 	int cpu;
 	int ret;
 
-	pevent = kzalloc(sizeof(*pevent), GFP_KERNEL);
-	if (!pevent)
-		return -ENOMEM;
-
-	atomic_set(&pevent->refcount, 1);
-
-	ret = get_event_id(pevent);
-	if (ret < 0)
-		goto fail;
-	pevent->id = ret;
-
-	if (!name) {
-		snprintf(id_buf, sizeof(id_buf), "%d", pevent->id);
-		name = id_buf;
-	}
-
-	pevent->name = kstrdup(name, GFP_KERNEL);
-	if (!pevent->name) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	pevent->sysfs.id = pevent->id;
+	pevent = pevent_alloc(name);
+	if (IS_ERR(pevent))
+		return PTR_ERR(pevent);
 
 	for_each_possible_cpu(cpu) {
 		ret = persistent_event_open(cpu, pevent, attr, nr_pages);
@@ -206,10 +230,7 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 out:
 	if (atomic_dec_and_test(&pevent->refcount)) {
 		pevent_sysfs_unregister(pevent);
-		if (pevent->id)
-			put_event_id(pevent->id);
-		kfree(pevent->name);
-		kfree(pevent);
+		pevent_free(pevent);
 	}
 
 	return ret;
@@ -439,3 +460,104 @@ void __init perf_register_persistent(void)
 		mutex_init(&per_cpu(pevents_lock, cpu));
 	}
 }
+
+/*
+ * Detach an event from a process. The event will remain in the system
+ * after closing the event's fd, it becomes persistent.
+ */
+int perf_event_detach(struct perf_event *event)
+{
+	struct pevent *pevent;
+	int cpu;
+	int ret;
+
+	if (!try_get_event(event))
+		return -ENOENT;
+
+	/* task events not yet supported: */
+	cpu = event->cpu;
+	if ((unsigned)cpu >= nr_cpu_ids) {
+		ret = -EINVAL;
+		goto fail_rb;
+	}
+
+	/*
+	 * Avoid grabbing an id, later checked again in pevent_add()
+	 * with mmap_mutex held.
+	 */
+	if (event->pevent_id) {
+		ret = -EEXIST;
+		goto fail_rb;
+	}
+
+	mutex_lock(&event->mmap_mutex);
+	if (event->rb)
+		ret = -EBUSY;
+	else
+		ret = perf_alloc_rb(event, CPU_BUFFER_NR_PAGES, 0);
+	mutex_unlock(&event->mmap_mutex);
+
+	if (ret)
+		goto fail_rb;
+
+	pevent = pevent_alloc(NULL);
+	if (IS_ERR(pevent)) {
+		ret = PTR_ERR(pevent);
+		goto fail_pevent;
+	}
+
+	ret = pevent_add(pevent, event);
+	if (ret)
+		goto fail_add;
+
+	ret = pevent_sysfs_register(pevent);
+	if (ret)
+		goto fail_sysfs;
+
+	atomic_inc(&event->mmap_count);
+
+	return pevent->id;
+fail_sysfs:
+	pevent_del(pevent, cpu);
+fail_add:
+	pevent_free(pevent);
+fail_pevent:
+	mutex_lock(&event->mmap_mutex);
+	if (event->rb)
+		perf_free_rb(event);
+	mutex_unlock(&event->mmap_mutex);
+fail_rb:
+	put_event(event);
+	return ret;
+}
+
+/*
+ * Attach an event to a process. The event will be removed after all
+ * users disconnected from it, it's no longer persistent in the
+ * system.
+ */
+int perf_event_attach(struct perf_event *event)
+{
+	int cpu = event->cpu;
+	struct pevent *pevent;
+
+	if ((unsigned)cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	pevent = find_event(event->pevent_id);
+	if (!pevent)
+		return -EINVAL;
+
+	event = pevent_del(pevent, cpu);
+	if (!event)
+		return -EINVAL;
+
+	if (atomic_dec_and_test(&pevent->refcount)) {
+		pevent_sysfs_unregister(pevent);
+		pevent_free(pevent);
+	}
+
+	persistent_event_release(event);
+
+	return 0;
+}
-- 
1.8.3.2

