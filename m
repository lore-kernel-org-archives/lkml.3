Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaBKUgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:36:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaBKTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.13 090/120] drm/nouveau: hold mutex while syncing to kernel channel
Date: Tue, 11 Feb 2014 11:05:31 -0800
Message-Id: <20140211184826.177249264@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit d5c1e84b3a130f0743b218b33ff7d9cb493ab5b4 upstream.

Not holding the mutex potentially causes corruption of the kernel
channel when page flipping.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -603,6 +603,14 @@ nouveau_crtc_page_flip(struct drm_crtc *
 	if (!s)
 		return -ENOMEM;
 
+	if (new_bo != old_bo) {
+		ret = nouveau_bo_pin(new_bo, TTM_PL_FLAG_VRAM);
+		if (ret)
+			goto fail_free;
+	}
+
+	mutex_lock(&chan->cli->mutex);
+
 	/* synchronise rendering channel with the kernel's channel */
 	spin_lock(&new_bo->bo.bdev->fence_lock);
 	fence = nouveau_fence_ref(new_bo->bo.sync_obj);
@@ -612,13 +620,6 @@ nouveau_crtc_page_flip(struct drm_crtc *
 	if (ret)
 		goto fail_free;
 
-	if (new_bo != old_bo) {
-		ret = nouveau_bo_pin(new_bo, TTM_PL_FLAG_VRAM);
-		if (ret)
-			goto fail_free;
-	}
-
-	mutex_lock(&chan->cli->mutex);
 	ret = ttm_bo_reserve(&old_bo->bo, true, false, false, NULL);
 	if (ret)
 		goto fail_unpin;


