Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaBCSQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:16:44 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34804 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaBCSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Prakash Kamliya <pkamliya@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/16] staging: sync: Signal pt before sync_timeline object gets destroyed
Date: Mon,  3 Feb 2014 10:16:18 -0800
Message-Id: <1391451388-23906-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prakash Kamliya <pkamliya@codeaurora.org>

There is a race condition

Assume we have *one* sync_fence object, with *one* sync_pt
which belongs to *one* sync_timeline, given this condition,
sync_timeline->kref will have two counts, one for sync_timeline
(implicit) and another for sync_pt.

Assume following is the situation on CPU

Theead-1 : (Thread which calls sync_timeline_destroy())
  -> (some function calls)
   -> sync_timeline_destory()
    -> sync_timeline_signal() (CPU is inside this
function after putting reference to sync_timeline)

At this time Thread-2 comes and does following

Thread-2 : (fclose on fence fd)
> sync_fence_release() -> because of fclose() on fence object
 -> sync_fence_free()
  -> sync_pt_free()
   -> kref_put(&pt->parent->kref, sync_timeline_free);
    -> sync_timeline_free() (CPU is inside this because
this time kref will be zero after _put)

Thread-2 will free sync_timeline object before Thread-1
has finished its work inside sync_timeline_signal.

With this change we signals all sync_pt before putting
reference to sync_timeline object.

c: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Prakash Kamliya <pkamliya@codeaurora.org>
[jstultz: minor commit subject tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 38e5d3b..fec2d1c 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -92,14 +92,14 @@ static void sync_timeline_free(struct kref *kref)
 void sync_timeline_destroy(struct sync_timeline *obj)
 {
 	obj->destroyed = true;
+	smp_wmb();
 
 	/*
-	 * If this is not the last reference, signal any children
-	 * that their parent is going away.
+	 * signal any children that their parent is going away.
 	 */
+	sync_timeline_signal(obj);
 
-	if (!kref_put(&obj->kref, sync_timeline_free))
-		sync_timeline_signal(obj);
+	kref_put(&obj->kref, sync_timeline_free);
 }
 EXPORT_SYMBOL(sync_timeline_destroy);
 
-- 
1.8.3.2

