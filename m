Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaGHAoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:44:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaGGXyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.14 26/94] drm/nouveau/kms: reference vblank for crtc during pageflip.
Date: Mon,  7 Jul 2014 16:57:16 -0700
Message-Id: <20140707235757.542191979@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit ba124a41058b300a5464206d2d33803cc3dc82ec upstream.

Need to drm_vblank_get/put() the crtc involved in a
pending pageflip, or we might not get vblank irqs and
updates of vblank counts and timestamps for pageflip
events and flip completion.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -734,6 +734,9 @@ nouveau_crtc_page_flip(struct drm_crtc *
 		  fb->bits_per_pixel, fb->pitches[0], crtc->x, crtc->y,
 		  new_bo->bo.offset };
 
+	/* Keep vblanks on during flip, for the target crtc of this flip */
+	drm_vblank_get(dev, nouveau_crtc(crtc)->index);
+
 	/* Emit a page flip */
 	if (nv_device(drm->device)->card_type >= NV_50) {
 		ret = nv50_display_flip_next(crtc, fb, chan, swap_interval);
@@ -777,6 +780,7 @@ nouveau_crtc_page_flip(struct drm_crtc *
 	return 0;
 
 fail_unreserve:
+	drm_vblank_put(dev, nouveau_crtc(crtc)->index);
 	ttm_bo_unreserve(&old_bo->bo);
 fail_unpin:
 	mutex_unlock(&chan->cli->mutex);
@@ -815,6 +819,9 @@ nouveau_finish_page_flip(struct nouveau_
 		drm_send_vblank_event(dev, crtcid, s->event);
 	}
 
+	/* Give up ownership of vblank for page-flipped crtc */
+	drm_vblank_put(dev, s->crtc);
+
 	list_del(&s->head);
 	if (ps)
 		*ps = *s;


