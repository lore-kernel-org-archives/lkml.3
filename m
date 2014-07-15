Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaGOVc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:32:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202AbaGOVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 117/198] drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.
Date: Tue, 15 Jul 2014 14:29:47 -0700
Message-Id: <1405459868-15089-118-git-send-email-kamal@canonical.com>
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

commit af4870e406126b7ac0ae7c7ce5751f25ebe60f28 upstream.

Cards with nv04 display engine can't reliably use vblank
counts and timestamps computed via drm_handle_vblank(), as
the function gets invoked after sending the pageflip events.

Fix this by defaulting to the old crtcid = -1 fallback path
on <= NV-50 cards, and only using the precise path on NV-50
and later.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index a0b2b87..cdaee13 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -692,6 +692,7 @@ nouveau_finish_page_flip(struct nouveau_channel *chan,
 	struct drm_device *dev = drm->dev;
 	struct nouveau_page_flip_state *s;
 	unsigned long flags;
+	int crtcid = -1;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
@@ -702,8 +703,13 @@ nouveau_finish_page_flip(struct nouveau_channel *chan,
 	}
 
 	s = list_first_entry(&fctx->flip, struct nouveau_page_flip_state, head);
-	if (s->event)
-		drm_send_vblank_event(dev, s->crtc, s->event);
+	if (s->event) {
+		/* Vblank timestamps/counts are only correct on >= NV-50 */
+		if (nv_device(drm->device)->card_type >= NV_50)
+			crtcid = s->crtc;
+
+		drm_send_vblank_event(dev, crtcid, s->event);
+	}
 
 	list_del(&s->head);
 	if (ps)
-- 
1.9.1

