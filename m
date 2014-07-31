Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaGaPez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57095 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaGaPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:51 -0400
Subject: [PATCH 18/19] drm/vmwgfx: use rcu in vmw_user_dmabuf_synccpu_grab
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:38 +0200
Message-ID: <20140731153438.15061.37829.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index f0a689ba9685..a43930162eb6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -567,13 +567,16 @@ static int vmw_user_dmabuf_synccpu_grab(struct vmw_user_dma_buffer *user_bo,
 	int ret;
 
 	if (flags & drm_vmw_synccpu_allow_cs) {
-		ret = ttm_bo_reserve(bo, true, !!(flags & drm_vmw_synccpu_dontblock), false, 0);
-		if (!ret) {
-			ret = ttm_bo_wait(bo, false, true,
-					  !!(flags & drm_vmw_synccpu_dontblock));
-			ttm_bo_unreserve(bo);
-		}
-		return ret;
+		long lret;
+		if (flags & drm_vmw_synccpu_dontblock)
+			return reservation_object_test_signaled_rcu(bo->resv, true) ? 0 : -EBUSY;
+
+		lret = reservation_object_wait_timeout_rcu(bo->resv, true, true, MAX_SCHEDULE_TIMEOUT);
+		if (!lret)
+			return -EBUSY;
+		else if (lret < 0)
+			return lret;
+		return 0;
 	}
 
 	ret = ttm_bo_synccpu_write_grab

