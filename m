Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbaGOWFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:05:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbaGOVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/198] drm/nv50-/mc: fix kms pageflip events by reordering irq handling order.
Date: Tue, 15 Jul 2014 14:29:46 -0700
Message-Id: <1405459868-15089-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit dcfb1009df3b4ad8d2e0779dd45b438629d6858a upstream.

Whenever a single nouveau_mc_intr() main gpu irq-handler invocation was
responsible for calling both, the vblank-irq handler (display engine irq)
and kms-pageflip completion handler (from fifo irq), the order of
invocation was wrong. nouveau_finish_flip() was called before
drm_handle_vblank() for the vblank of pageflip completion, so the
emitted pageflip event contained stale vblank count and timestamp
from previous vblank. This caused failure in userspace to timestamp
properly.

Reorder order of invocation of engine irq handlers: Put
NVDEV_ENGINE_DISP always on top, and thereby before NVDEV_ENGINE_FIFO,
so that drm_handle_vblank() gets called to update vblank timestamps
and count before potential pageflip events make use of that
information.

This works on nv-50 and later, where kms-pageflip completion triggers
an irq either after a separate vblank irq, or both pageflip and vblank
trigger one common irq invocation, but never before vblank irqs.

v2 (Ben):
- removed mods for nv04-nv40, it doesn't help there anyway
- this is considered a hack, and a better solution should be found

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c | 2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c | 2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c b/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
index e8822a9..90d8bf8 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
@@ -26,6 +26,7 @@
 
 const struct nouveau_mc_intr
 nv50_mc_intr[] = {
+	{ 0x04000000, NVDEV_ENGINE_DISP },  /* DISP before FIFO, so pageflip-timestamping works! */
 	{ 0x00000001, NVDEV_ENGINE_MPEG },
 	{ 0x00000100, NVDEV_ENGINE_FIFO },
 	{ 0x00001000, NVDEV_ENGINE_GR },
@@ -34,7 +35,6 @@ nv50_mc_intr[] = {
 	{ 0x00020000, NVDEV_ENGINE_VP },	/* NV84- */
 	{ 0x00100000, NVDEV_SUBDEV_TIMER },
 	{ 0x00200000, NVDEV_SUBDEV_GPIO },
-	{ 0x04000000, NVDEV_ENGINE_DISP },
 	{ 0x10000000, NVDEV_SUBDEV_BUS },
 	{ 0x80000000, NVDEV_ENGINE_SW },
 	{ 0x0002d101, NVDEV_SUBDEV_FB },
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c b/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
index f8a6f18..95b3d35 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
@@ -26,6 +26,7 @@
 
 static const struct nouveau_mc_intr
 nv98_mc_intr[] = {
+	{ 0x04000000, NVDEV_ENGINE_DISP },  /* DISP first, so pageflip timestamps work */
 	{ 0x00000001, NVDEV_ENGINE_PPP },
 	{ 0x00000100, NVDEV_ENGINE_FIFO },
 	{ 0x00001000, NVDEV_ENGINE_GR },
@@ -37,7 +38,6 @@ nv98_mc_intr[] = {
 	{ 0x00100000, NVDEV_SUBDEV_TIMER },
 	{ 0x00200000, NVDEV_SUBDEV_GPIO },
 	{ 0x00400000, NVDEV_ENGINE_COPY0 },	/* NVA3-     */
-	{ 0x04000000, NVDEV_ENGINE_DISP },
 	{ 0x10000000, NVDEV_SUBDEV_BUS },
 	{ 0x80000000, NVDEV_ENGINE_SW },
 	{ 0x0042d101, NVDEV_SUBDEV_FB },
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
index c02b476..c809743 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
@@ -26,6 +26,7 @@
 
 const struct nouveau_mc_intr
 nvc0_mc_intr[] = {
+	{ 0x04000000, NVDEV_ENGINE_DISP },  /* DISP first, so pageflip timestamps work. */
 	{ 0x00000001, NVDEV_ENGINE_PPP },
 	{ 0x00000020, NVDEV_ENGINE_COPY0 },
 	{ 0x00000040, NVDEV_ENGINE_COPY1 },
@@ -39,7 +40,6 @@ nvc0_mc_intr[] = {
 	{ 0x00200000, NVDEV_SUBDEV_GPIO },
 	{ 0x01000000, NVDEV_SUBDEV_PWR },
 	{ 0x02000000, NVDEV_SUBDEV_LTCG },
-	{ 0x04000000, NVDEV_ENGINE_DISP },
 	{ 0x10000000, NVDEV_SUBDEV_BUS },
 	{ 0x40000000, NVDEV_SUBDEV_IBUS },
 	{ 0x80000000, NVDEV_ENGINE_SW },
-- 
1.9.1

