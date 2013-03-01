Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CAApz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:45:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58539 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3CAAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:20 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 25/30] staging: sync: Refactor sync debug printing
Date: Thu, 28 Feb 2013 16:43:21 -0800
Message-Id: <1362098606-26469-26-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Move driver callbacks to fill strings instead of using seq_files.  This
will allow those values to be used in a future tracepoint patch.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   18 ++++++++++++++++--
 drivers/staging/android/sync.h |   19 +++++++++++++------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 811cf65..988f233 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -847,7 +847,17 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
 		seq_printf(s, "@%ld.%06ld", tv.tv_sec, tv.tv_usec);
 	}
 
-	if (pt->parent->ops->print_pt) {
+	if (pt->parent->ops->timeline_value_str &&
+	    pt->parent->ops->pt_value_str) {
+		char value[64];
+		pt->parent->ops->pt_value_str(pt, value, sizeof(value));
+		seq_printf(s, ": %s", value);
+		if (fence) {
+			pt->parent->ops->timeline_value_str(pt->parent, value,
+						    sizeof(value));
+			seq_printf(s, " / %s", value);
+		}
+	} else if (pt->parent->ops->print_pt) {
 		seq_printf(s, ": ");
 		pt->parent->ops->print_pt(s, pt);
 	}
@@ -862,7 +872,11 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	seq_printf(s, "%s %s", obj->name, obj->ops->driver_name);
 
-	if (obj->ops->print_obj) {
+	if (obj->ops->timeline_value_str) {
+		char value[64];
+		obj->ops->timeline_value_str(obj, value, sizeof(value));
+		seq_printf(s, ": %s", value);
+	} else if (obj->ops->print_obj) {
 		seq_printf(s, ": ");
 		obj->ops->print_obj(s, obj);
 	}
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 75ed5f1..38ea986 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -40,14 +40,14 @@ struct sync_fence;
  *			 -1 if a will signabl before b
  * @free_pt:		called before sync_pt is freed
  * @release_obj:	called before sync_timeline is freed
- * @print_obj:		print aditional debug information about sync_timeline.
- *			  should not print a newline
- * @print_pt:		print aditional debug information about sync_pt.
- *			  should not print a newline
+ * @print_obj:		deprecated
+ * @print_pt:		deprecated
  * @fill_driver_data:	write implmentation specific driver data to data.
  *			  should return an error if there is not enough room
  *			  as specified by size.  This information is returned
  *			  to userspace by SYNC_IOC_FENCE_INFO.
+ * @timeline_value_str: fill str with the value of the sync_timeline's counter
+ * @pt_value_str:	fill str with the value of the sync_pt
  */
 struct sync_timeline_ops {
 	const char *driver_name;
@@ -67,15 +67,22 @@ struct sync_timeline_ops {
 	/* optional */
 	void (*release_obj)(struct sync_timeline *sync_timeline);
 
-	/* optional */
+	/* deprecated */
 	void (*print_obj)(struct seq_file *s,
 			  struct sync_timeline *sync_timeline);
 
-	/* optional */
+	/* deprecated */
 	void (*print_pt)(struct seq_file *s, struct sync_pt *sync_pt);
 
 	/* optional */
 	int (*fill_driver_data)(struct sync_pt *syncpt, void *data, int size);
+
+	/* optional */
+	void (*timeline_value_str)(struct sync_timeline *timeline, char *str,
+				   int size);
+
+	/* optional */
+	void (*pt_value_str)(struct sync_pt *pt, char *str, int size);
 };
 
 /**
-- 
1.7.10.4

