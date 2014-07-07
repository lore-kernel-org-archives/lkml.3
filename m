Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaGHAoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:44:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaGGXyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.14 24/94] drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.
Date: Mon,  7 Jul 2014 16:57:14 -0700
Message-Id: <20140707235757.486529349@linuxfoundation.org>
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

commit af4870e406126b7ac0ae7c7ce5751f25ebe60f28 upstream.

Cards with nv04 display engine can't reliably use vblank
counts and timestamps computed via drm_handle_vblank(), as
the function gets invoked after sending the pageflip events.

Fix this by defaulting to the old crtcid = -1 fallback path
on <= NV-50 cards, and only using the precise path on NV-50
and later.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -796,6 +796,7 @@ nouveau_finish_page_flip(struct nouveau_
 	struct drm_device *dev = drm->dev;
 	struct nouveau_page_flip_state *s;
 	unsigned long flags;
+	int crtcid = -1;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
@@ -806,8 +807,13 @@ nouveau_finish_page_flip(struct nouveau_
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


