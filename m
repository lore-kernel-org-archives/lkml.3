Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3BFUAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:00:52 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64207 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3BFUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:00:48 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 34/77] drm/sis: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:06 -0800
Message-Id: <1360179649-22465-35-git-send-email-tj@kernel.org>
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
 drivers/gpu/drm/sis/sis_mm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/sis/sis_mm.c b/drivers/gpu/drm/sis/sis_mm.c
index 2b2f78c..9a43d98 100644
--- a/drivers/gpu/drm/sis/sis_mm.c
+++ b/drivers/gpu/drm/sis/sis_mm.c
@@ -128,17 +128,10 @@ static int sis_drm_alloc(struct drm_device *dev, struct drm_file *file,
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

