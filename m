Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbaGOV7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:59:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbaGOViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 150/198] drm/nouveau/kms: reference vblank for crtc during pageflip.
Date: Tue, 15 Jul 2014 14:30:20 -0700
Message-Id: <1405459868-15089-151-git-send-email-kamal@canonical.com>
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

commit ba124a41058b300a5464206d2d33803cc3dc82ec upstream.

Need to drm_vblank_get/put() the crtc involved in a
pending pageflip, or we might not get vblank irqs and
updates of vblank counts and timestamps for pageflip
events and flip completion.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index cdaee13..91999bc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -630,6 +630,9 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		  fb->bits_per_pixel, fb->pitches[0], crtc->x, crtc->y,
 		  new_bo->bo.offset };
 
+	/* Keep vblanks on during flip, for the target crtc of this flip */
+	drm_vblank_get(dev, nouveau_crtc(crtc)->index);
+
 	/* Emit a page flip */
 	if (nv_device(drm->device)->card_type >= NV_50) {
 		ret = nv50_display_flip_next(crtc, fb, chan, swap_interval);
@@ -673,6 +676,7 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	return 0;
 
 fail_unreserve:
+	drm_vblank_put(dev, nouveau_crtc(crtc)->index);
 	ttm_bo_unreserve(&old_bo->bo);
 fail_unpin:
 	mutex_unlock(&chan->cli->mutex);
@@ -711,6 +715,9 @@ nouveau_finish_page_flip(struct nouveau_channel *chan,
 		drm_send_vblank_event(dev, crtcid, s->event);
 	}
 
+	/* Give up ownership of vblank for page-flipped crtc */
+	drm_vblank_put(dev, s->crtc);
+
 	list_del(&s->head);
 	if (ps)
 		*ps = *s;
-- 
1.9.1

