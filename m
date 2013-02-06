Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3BFUFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:05:06 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45841 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab3BFTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 35/77] drm/via: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:07 -0800
Message-Id: <1360179649-22465-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/via/via_mm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/via/via_mm.c b/drivers/gpu/drm/via/via_mm.c
index 0d55432..0ab93ff 100644
--- a/drivers/gpu/drm/via/via_mm.c
+++ b/drivers/gpu/drm/via/via_mm.c
@@ -148,17 +148,10 @@ int via_mem_alloc(struct drm_device *dev, void *data,
 	if (retval)
 		goto fail_alloc;
 
-again:
-	if (idr_pre_get(&dev_priv->object_idr, GFP_KERNEL) == 0) {
-		retval = -ENOMEM;
-		goto fail_idr;
-	}
-
-	retval = idr_get_new_above(&dev_priv->object_idr, item, 1, &user_key);
-	if (retval == -EAGAIN)
-		goto again;
-	if (retval)
+	retval = idr_alloc(&dev_priv->object_idr, item, 1, 0, GFP_KERNEL);
+	if (retval < 0)
 		goto fail_idr;
+	user_key = retval;
 
 	list_add(&item->owner_list, &file_priv->obj_list);
 	mutex_unlock(&dev->struct_mutex);
-- 
1.8.1

