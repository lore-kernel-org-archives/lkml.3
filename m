Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3CAApx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:45:53 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43497 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3CAAoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 27/30] staging: sync: Add tracepoint support
Date: Thu, 28 Feb 2013 16:43:23 -0800
Message-Id: <1362098606-26469-28-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Add support for tracepoints

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Whitespace changes, add commit message, move to staging]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c       |   11 +++++
 drivers/staging/android/trace/sync.h |   82 ++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)
 create mode 100644 drivers/staging/android/trace/sync.h

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 988f233..1ddc404 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -28,6 +28,9 @@
 
 #include "sync.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace/sync.h"
+
 static void sync_fence_signal_pt(struct sync_pt *pt);
 static int _sync_pt_has_signaled(struct sync_pt *pt);
 static void sync_fence_free(struct kref *kref);
@@ -134,6 +137,8 @@ void sync_timeline_signal(struct sync_timeline *obj)
 	LIST_HEAD(signaled_pts);
 	struct list_head *pos, *n;
 
+	trace_sync_timeline(obj);
+
 	spin_lock_irqsave(&obj->active_list_lock, flags);
 
 	list_for_each_safe(pos, n, &obj->active_list_head) {
@@ -581,6 +586,11 @@ static bool sync_fence_check(struct sync_fence *fence)
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
 	int err = 0;
+	struct sync_pt *pt;
+
+	trace_sync_wait(fence, 1);
+	list_for_each_entry(pt, &fence->pt_list_head, pt_list)
+		trace_sync_pt(pt);
 
 	if (timeout > 0) {
 		timeout = msecs_to_jiffies(timeout);
@@ -591,6 +601,7 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 		err = wait_event_interruptible(fence->wq,
 					       sync_fence_check(fence));
 	}
+	trace_sync_wait(fence, 0);
 
 	if (err < 0)
 		return err;
diff --git a/drivers/staging/android/trace/sync.h b/drivers/staging/android/trace/sync.h
new file mode 100644
index 0000000..9546235
--- /dev/null
+++ b/drivers/staging/android/trace/sync.h
@@ -0,0 +1,82 @@
+#undef TRACE_SYSTEM
+#define TRACE_INCLUDE_PATH ../../drivers/staging/android/trace
+#define TRACE_SYSTEM sync
+
+#if !defined(_TRACE_SYNC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SYNC_H
+
+#include "../sync.h"
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(sync_timeline,
+	TP_PROTO(struct sync_timeline *timeline),
+
+	TP_ARGS(timeline),
+
+	TP_STRUCT__entry(
+			__string(name, timeline->name)
+			__array(char, value, 32)
+	),
+
+	TP_fast_assign(
+			__assign_str(name, timeline->name);
+			if (timeline->ops->timeline_value_str) {
+				timeline->ops->timeline_value_str(timeline,
+							__entry->value,
+							sizeof(__entry->value));
+			} else {
+				__entry->value[0] = '\0';
+			}
+	),
+
+	TP_printk("name=%s value=%s", __get_str(name), __entry->value)
+);
+
+TRACE_EVENT(sync_wait,
+	TP_PROTO(struct sync_fence *fence, int begin),
+
+	TP_ARGS(fence, begin),
+
+	TP_STRUCT__entry(
+			__string(name, fence->name)
+			__field(s32, status)
+			__field(u32, begin)
+	),
+
+	TP_fast_assign(
+			__assign_str(name, fence->name);
+			__entry->status = fence->status;
+			__entry->begin = begin;
+	),
+
+	TP_printk("%s name=%s state=%d", __entry->begin ? "begin" : "end",
+			__get_str(name), __entry->status)
+);
+
+TRACE_EVENT(sync_pt,
+	TP_PROTO(struct sync_pt *pt),
+
+	TP_ARGS(pt),
+
+	TP_STRUCT__entry(
+		__string(timeline, pt->parent->name)
+		__array(char, value, 32)
+	),
+
+	TP_fast_assign(
+		__assign_str(timeline, pt->parent->name);
+		if (pt->parent->ops->pt_value_str) {
+			pt->parent->ops->pt_value_str(pt, __entry->value,
+							sizeof(__entry->value));
+		} else {
+			__entry->value[0] = '\0';
+		}
+	),
+
+	TP_printk("name=%s value=%s", __get_str(timeline), __entry->value)
+);
+
+#endif /* if !defined(_TRACE_SYNC_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.10.4

