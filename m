Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaCXIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11547 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Mar 2014 01:40:35 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 11/12] drm/nouveau: support GK20A in nouveau_accel_init()
Date: Mon, 24 Mar 2014 17:42:33 +0900
Message-ID: <1395650554-31925-12-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GK20A does not embed a dedicated COPY engine and thus cannot allocate
the copy channel that nouveau_accel_init() attempts to create. It also
lacks any display hardware, so the creation of a software channel does
not apply neither.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index ef27949057c3..f2394e84eae6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -171,6 +171,11 @@ nouveau_accel_init(struct nouveau_drm *drm)
 		return;
 	}
 
+	if (device->chipset == 0xea) {
+		/* gk20a does not have CE0/CE1 */
+		arg0 = NVE0_CHANNEL_IND_ENGINE_GR;
+		arg1 = 1;
+	} else
 	if (device->card_type >= NV_E0) {
 		ret = nouveau_channel_new(drm, &drm->client, NVDRM_DEVICE,
 					  NVDRM_CHAN + 1,
@@ -207,6 +212,10 @@ nouveau_accel_init(struct nouveau_drm *drm)
 		return;
 	}
 
+	/* Need to figure out how to handle sw for gk20a */
+	if (device->chipset == 0xea)
+		goto skip_sw_init;
+
 	ret = nouveau_object_new(nv_object(drm), NVDRM_CHAN, NVDRM_NVSW,
 				 nouveau_abi16_swclass(drm), NULL, 0, &object);
 	if (ret == 0) {
@@ -233,6 +242,7 @@ nouveau_accel_init(struct nouveau_drm *drm)
 		return;
 	}
 
+skip_sw_init:
 	if (device->card_type < NV_C0) {
 		ret = nouveau_gpuobj_new(drm->device, NULL, 32, 0, 0,
 					&drm->notify);
-- 
1.9.1

