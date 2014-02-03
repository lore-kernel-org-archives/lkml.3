Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaBCSV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:21:28 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44151 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaBCSQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alistair Strachan <alistair.strachan@imgtec.com>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 07/16] staging: sync: Fix a race condition between release_obj and print_obj
Date: Mon,  3 Feb 2014 10:16:19 -0800
Message-Id: <1391451388-23906-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alistair Strachan <alistair.strachan@imgtec.com>

Before this change, a timeline would only be removed from the timeline
list *after* the sync driver had its release_obj() called. However, the
driver's release_obj() may free resources needed by print_obj().

Although the timeline list is locked when print_obj() is called, it is
not locked when release_obj() is called. If one CPU was in print_obj()
when another was in release_obj(), the print_obj() may make unsafe
accesses.

It is not actually necessary to hold the timeline list lock when calling
release_obj() if the call is made after the timeline is unlinked from
the list, since there is no possibility another thread could be in --
or enter -- print_obj() for that timeline.

This change moves the release_obj() call to after the timeline is
unlinked, preventing the above race from occurring.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Alistair Strachan <alistair.strachan@imgtec.com>
[jstultz: minor commit subject tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index fec2d1c..3d05f662 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -79,13 +79,13 @@ static void sync_timeline_free(struct kref *kref)
 		container_of(kref, struct sync_timeline, kref);
 	unsigned long flags;
 
-	if (obj->ops->release_obj)
-		obj->ops->release_obj(obj);
-
 	spin_lock_irqsave(&sync_timeline_list_lock, flags);
 	list_del(&obj->sync_timeline_list);
 	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
 
+	if (obj->ops->release_obj)
+		obj->ops->release_obj(obj);
+
 	kfree(obj);
 }
 
-- 
1.8.3.2

