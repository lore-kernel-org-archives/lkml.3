Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3BJLt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:49:28 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48640 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3BJLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:49:27 -0500
From: Artem Savkov <artem.savkov@gmail.com>
To: Tejun Heo <tj@kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] drm: missing idr_preload_end in drm_gem_flink_ioctl
Date: Sun, 10 Feb 2013 15:49:05 +0400
Message-Id: <1360496945-4694-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing idr_preload_end calls in drm_gem_flink_ioctl().
Without those preemption stays disabled resulting in lots of "scheduling while
atomic" BUGs.

Introduced in 4e486fae707d9a79c76f1be6dcacffc4a721cc1b (linux-next.git)

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/gpu/drm/drm_gem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 6577514..f1700ef 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -456,6 +456,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
 		obj->name = ret;
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 
 		if (ret < 0)
 			goto err;
@@ -465,6 +466,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
 	} else {
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 		ret = 0;
 	}
 
-- 
1.8.1.1

