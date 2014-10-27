Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaJ0Jtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19177 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaJ0Jtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Oct 2014 02:49:02 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 3/4] drm: allocate GPFIFOs and fences coherently
Date: Mon, 27 Oct 2014 18:49:18 +0900
Message-ID: <1414403359-22332-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
References: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify TTM_PL_FLAG_UNCACHED when allocating GPFIFOs and fences to
allow them to be safely accessed by the kernel without being synced
on non-coherent architectures.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drm/nouveau_chan.c | 2 +-
 drm/nv84_fence.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drm/nouveau_chan.c b/drm/nouveau_chan.c
index 77c81d6b45ee..0f3da86840f2 100644
--- a/drm/nouveau_chan.c
+++ b/drm/nouveau_chan.c
@@ -102,7 +102,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nvif_device *device,
 	chan->drm = drm;
 
 	/* allocate memory for dma push buffer */
-	target = TTM_PL_FLAG_TT;
+	target = TTM_PL_FLAG_TT | TTM_PL_FLAG_UNCACHED;
 	if (nouveau_vram_pushbuf)
 		target = TTM_PL_FLAG_VRAM;
 
diff --git a/drm/nv84_fence.c b/drm/nv84_fence.c
index d6c6c87c3f07..4d79be7558d8 100644
--- a/drm/nv84_fence.c
+++ b/drm/nv84_fence.c
@@ -246,8 +246,8 @@ nv84_fence_create(struct nouveau_drm *drm)
 
 	if (ret == 0)
 		ret = nouveau_bo_new(drm->dev, 16 * priv->base.contexts, 0,
-				     TTM_PL_FLAG_TT, 0, 0, NULL, NULL,
-				     &priv->bo_gart);
+				     TTM_PL_FLAG_TT | TTM_PL_FLAG_UNCACHED, 0,
+				     0, NULL, NULL, &priv->bo_gart);
 	if (ret == 0) {
 		ret = nouveau_bo_pin(priv->bo_gart, TTM_PL_FLAG_TT);
 		if (ret == 0) {
-- 
2.1.2

