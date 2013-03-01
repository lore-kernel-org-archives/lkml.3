Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3CAAoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3CAAoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 26/30] staging: sw_sync: Convert to use new value_str debug ops
Date: Thu, 28 Feb 2013 16:43:22 -0800
Message-Id: <1362098606-26469-27-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Switch from print_obj/print_pt to the new
timeline_value_str and pt_value_str ops.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Add commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sw_sync.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index d768893..68025a5 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -72,23 +72,6 @@ static int sw_sync_pt_compare(struct sync_pt *a, struct sync_pt *b)
 	return sw_sync_cmp(pt_a->value, pt_b->value);
 }
 
-static void sw_sync_print_obj(struct seq_file *s,
-			      struct sync_timeline *sync_timeline)
-{
-	struct sw_sync_timeline *obj = (struct sw_sync_timeline *)sync_timeline;
-
-	seq_printf(s, "%d", obj->value);
-}
-
-static void sw_sync_print_pt(struct seq_file *s, struct sync_pt *sync_pt)
-{
-	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
-	struct sw_sync_timeline *obj =
-		(struct sw_sync_timeline *)sync_pt->parent;
-
-	seq_printf(s, "%d / %d", pt->value, obj->value);
-}
-
 static int sw_sync_fill_driver_data(struct sync_pt *sync_pt,
 				    void *data, int size)
 {
@@ -102,14 +85,29 @@ static int sw_sync_fill_driver_data(struct sync_pt *sync_pt,
 	return sizeof(pt->value);
 }
 
+static void sw_sync_timeline_value_str(struct sync_timeline *sync_timeline,
+				       char *str, int size)
+{
+	struct sw_sync_timeline *timeline =
+		(struct sw_sync_timeline *)sync_timeline;
+	snprintf(str, size, "%d", timeline->value);
+}
+
+static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
+				       char *str, int size)
+{
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+	snprintf(str, size, "%d", pt->value);
+}
+
 struct sync_timeline_ops sw_sync_timeline_ops = {
 	.driver_name = "sw_sync",
 	.dup = sw_sync_pt_dup,
 	.has_signaled = sw_sync_pt_has_signaled,
 	.compare = sw_sync_pt_compare,
-	.print_obj = sw_sync_print_obj,
-	.print_pt = sw_sync_print_pt,
 	.fill_driver_data = sw_sync_fill_driver_data,
+	.timeline_value_str = sw_sync_timeline_value_str,
+	.pt_value_str = sw_sync_pt_value_str,
 };
 
 
-- 
1.7.10.4

