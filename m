Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaBAD31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:27 -0500
Received: from gnurou.org ([207.192.72.5]:51794 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaBAD2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:24 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 15/16] drm/nouveau: support GK20A in nouveau_accel_init()
Date: Sat,  1 Feb 2014 12:16:57 +0900
Message-Id: <1391224618-3794-16-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
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
index 8d55a50..87bdf04 100644
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
1.8.5.3

