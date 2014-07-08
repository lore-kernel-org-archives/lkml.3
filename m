Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaGHI0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:26:54 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12205 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaGHI0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 01:19:55 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 6/6] drm/nouveau: allocate GPFIFOs and fences coherently
Date: Tue, 8 Jul 2014 17:26:01 +0900
Message-ID: <1404807961-30530-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
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
 drivers/gpu/drm/nouveau/nouveau_chan.c | 2 +-
 drivers/gpu/drm/nouveau/nv84_fence.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index ccb6b452d6d0..155b1b192676 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -110,7 +110,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nouveau_cli *cli,
 	chan->handle = handle;
 
 	/* allocate memory for dma push buffer */
-	target = TTM_PL_FLAG_TT;
+	target = TTM_PL_FLAG_TT | TTM_PL_FLAG_UNCACHED;
 	if (nouveau_vram_pushbuf)
 		target = TTM_PL_FLAG_VRAM;
 
diff --git a/drivers/gpu/drm/nouveau/nv84_fence.c b/drivers/gpu/drm/nouveau/nv84_fence.c
index 9fd475c89820..b5d6737b6b8d 100644
--- a/drivers/gpu/drm/nouveau/nv84_fence.c
+++ b/drivers/gpu/drm/nouveau/nv84_fence.c
@@ -257,8 +257,8 @@ nv84_fence_create(struct nouveau_drm *drm)
 
 	if (ret == 0)
 		ret = nouveau_bo_new(drm->dev, 16 * (pfifo->max + 1), 0,
-				     TTM_PL_FLAG_TT, 0, 0, NULL,
-				     &priv->bo_gart);
+				     TTM_PL_FLAG_TT | TTM_PL_FLAG_UNCACHED, 0,
+				     0, NULL, &priv->bo_gart);
 	if (ret == 0) {
 		ret = nouveau_bo_pin(priv->bo_gart, TTM_PL_FLAG_TT);
 		if (ret == 0) {
-- 
2.0.0

