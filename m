Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaGAK7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:59:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60266 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbaGAK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:58:12 -0400
Subject: [PATCH v2 6/9] reservation: add support for fences to enable
 cross-device synchronisation
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:37 +0200
Message-ID: <20140701105737.12718.54300.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 include/linux/reservation.h |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index 813dae960ebd..f3f57460a205 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -6,7 +6,7 @@
  * Copyright (C) 2012 Texas Instruments
  *
  * Authors:
- * Rob Clark <rob.clark@linaro.org>
+ * Rob Clark <robdclark@gmail.com>
  * Maarten Lankhorst <maarten.lankhorst@canonical.com>
  * Thomas Hellstrom <thellstrom-at-vmware-dot-com>
  *
@@ -40,22 +40,40 @@
 #define _LINUX_RESERVATION_H
 
 #include <linux/ww_mutex.h>
+#include <linux/fence.h>
+#include <linux/slab.h>
 
 extern struct ww_class reservation_ww_class;
 
 struct reservation_object {
 	struct ww_mutex lock;
+
+	struct fence *fence_excl;
+	struct fence **fence_shared;
+	u32 fence_shared_count, fence_shared_max;
 };
 
 static inline void
 reservation_object_init(struct reservation_object *obj)
 {
 	ww_mutex_init(&obj->lock, &reservation_ww_class);
+
+	obj->fence_shared_count = obj->fence_shared_max = 0;
+	obj->fence_shared = NULL;
+	obj->fence_excl = NULL;
 }
 
 static inline void
 reservation_object_fini(struct reservation_object *obj)
 {
+	int i;
+
+	if (obj->fence_excl)
+		fence_put(obj->fence_excl);
+	for (i = 0; i < obj->fence_shared_count; ++i)
+		fence_put(obj->fence_shared[i]);
+	kfree(obj->fence_shared);
+
 	ww_mutex_destroy(&obj->lock);
 }
 

