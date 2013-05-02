Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3EBHkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:40:08 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46620 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3EBHkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:40:06 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        stable@vger.kernel.org
Subject: [PATCH] drm: don't check modeset locks in panic handler
Date: Thu,  2 May 2013 09:43:05 +0200
Message-Id: <1367480585-22814-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAPM=9tw-Ssu7ZYBZX7ipGt9w7zYG91tKbWZguM5DLPaqTakJPA@mail.gmail.com>
References: <CAPM=9tw-Ssu7ZYBZX7ipGt9w7zYG91tKbWZguM5DLPaqTakJPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we know that locking is broken in that case and it's more
important to not flood the dmesg with random gunk.

Cc: Dave Airlie <airlied@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
References: https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/QFzFxSUeV4I
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_crtc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 792c3e3..3be0802 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -78,6 +78,10 @@ void drm_warn_on_modeset_not_all_locked(struct drm_device *dev)
 {
 	struct drm_crtc *crtc;
 
+	/* Locking is currently fubar in the panic handler. */
+	if (oops_in_progress)
+		return;
+
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
 		WARN_ON(!mutex_is_locked(&crtc->mutex));
 
-- 
1.7.10.4

