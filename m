Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab3HNKn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:43:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab3HNKiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 62/75] drm/mgag200: Invalidate page tables when pinning a BO
Date: Wed, 14 Aug 2013 11:36:51 +0100
Message-Id: <1376476624-10011-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.com>

commit ecaac1c866bcda4780a963b3d18cd310d971aea3 upstream.

When a BO gets pinned the placement may get changed. If the memory is
mapped into user space and user space has already accessed the mapped
range the page tables are set up but now point to the wrong memory.
Set bo.mdev->dev_mapping in mgag200_bo_create() to make sure that
ttm_bo_unmap_virtual() called from ttm_bo_handle_move_mem() will take
care of this.

v2: Don't call ttm_bo_unmap_virtual() in mgag200_bo_pin(), fix comment.

Signed-off-by: Egbert Eich <eich@suse.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index a707394..95b5377 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.8.3.2

