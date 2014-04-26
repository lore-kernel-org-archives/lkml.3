Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaDZQGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:06:21 -0400
Received: from nm9-vm2.bullet.mail.ir2.yahoo.com ([212.82.96.145]:39954 "EHLO
	nm9-vm2.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbaDZQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:06:20 -0400
X-Yahoo-Newman-Id: 248367.21250.bm@smtp144.mail.ir2.yahoo.com
Message-ID: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7UQVfE0VM1l.6Gwbwk30RTolIsPr89EVENkAwq8.1hJIYe8
 CybpI1VY8bx4Tf9Mv2u6eDVFYdpcYjcZVM5Fssyv6t9XcU97IvbtnY_eAgZz
 9Q64oxXRTn04dM73UkFpAaTV0D39yptS8B1one59JbmkT4_.WIycpukPAOHN
 TdFul5cxD9ujsT3wXCKZNK3qSyOCnQOVAxBr3KjeKeswPmDNTSJiS_Eft12e
 6RZy9p0KV9Px_mDzx708yVAIUDjv_AD8.XpY01cmaaL2qloDQDIIqbCA.s9e
 ECuVcMlRMFDbS85HBK_e1ZUgcWnd4TXHgKb0eMu7a186ZkfG40ljk8iOIjW8
 mMr2343pS9VBGGws.ewSpfQhvHBjYrLhRtdRZpstgSExzuPiINbmEKOzb2p.
 X.MA8cNFmSCjNfVfhpaJxAqs5ZGfWep9HyBWalSSbnDrmhbMR3ycuoT5AE6l
 W.Cy4Fsm_4Z9taABFTtZNjvItbXlLi1HCfmeSfb7YN531XgC2nFYB0IjVd3E
 GMvNVNWaif0VRn6FnPh9ZXM3uBwo6PiZeVdtlmG4-
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-Rocket-Received: from asus2 (lionel_debroux@82.122.199.38 with plain [188.125.69.59])
        by smtp144.mail.ir2.yahoo.com with SMTP; 26 Apr 2014 16:06:18 +0000 UTC
Date: Sat, 26 Apr 2014 18:06:15 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] drm: make variable named "refcount" atomic, like most refcounts in the kernel.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on PaX.

---

>From 7c712cadd97d43d03ff3d7ca04fd85bd8c6eb34a Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sat, 26 Apr 2014 15:53:55 +0200
Subject: drm: make variable named "refcount" atomic, like most refcounts in
 the kernel.

Extracted from the PaX patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: PaX Team <pageexec@freemail.hu>
---
 drivers/gpu/drm/drm_global.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_global.c b/drivers/gpu/drm/drm_global.c
index 3d2e91c..d31c4c9 100644
--- a/drivers/gpu/drm/drm_global.c
+++ b/drivers/gpu/drm/drm_global.c
@@ -36,7 +36,7 @@
 struct drm_global_item {
 	struct mutex mutex;
 	void *object;
-	int refcount;
+	atomic_t refcount;
 };
 
 static struct drm_global_item glob[DRM_GLOBAL_NUM];
@@ -49,7 +49,7 @@ void drm_global_init(void)
 		struct drm_global_item *item = &glob[i];
 		mutex_init(&item->mutex);
 		item->object = NULL;
-		item->refcount = 0;
+		atomic_set(&item->refcount, 0);
 	}
 }
 
@@ -59,7 +59,7 @@ void drm_global_release(void)
 	for (i = 0; i < DRM_GLOBAL_NUM; ++i) {
 		struct drm_global_item *item = &glob[i];
 		BUG_ON(item->object != NULL);
-		BUG_ON(item->refcount != 0);
+		BUG_ON(atomic_read(&item->refcount) != 0);
 	}
 }
 
@@ -69,7 +69,7 @@ int drm_global_item_ref(struct drm_global_reference *ref)
 	struct drm_global_item *item = &glob[ref->global_type];
 
 	mutex_lock(&item->mutex);
-	if (item->refcount == 0) {
+	if (atomic_read(&item->refcount) == 0) {
 		item->object = kzalloc(ref->size, GFP_KERNEL);
 		if (unlikely(item->object == NULL)) {
 			ret = -ENOMEM;
@@ -82,7 +82,7 @@ int drm_global_item_ref(struct drm_global_reference *ref)
 			goto out_err;
 
 	}
-	++item->refcount;
+	atomic_inc(&item->refcount);
 	ref->object = item->object;
 	mutex_unlock(&item->mutex);
 	return 0;
@@ -98,9 +98,9 @@ void drm_global_item_unref(struct drm_global_reference *ref)
 	struct drm_global_item *item = &glob[ref->global_type];
 
 	mutex_lock(&item->mutex);
-	BUG_ON(item->refcount == 0);
+	BUG_ON(atomic_read(&item->refcount) == 0);
 	BUG_ON(ref->object != item->object);
-	if (--item->refcount == 0) {
+	if (atomic_dec_and_test(&item->refcount)) {
 		ref->release(ref);
 		item->object = NULL;
 	}
-- 
1.9.1.506.g7bf272c

