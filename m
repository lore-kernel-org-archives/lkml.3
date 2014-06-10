Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaFJUPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:15:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbaFJTvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 141/160] drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip
Date: Tue, 10 Jun 2014 12:46:21 -0700
Message-Id: <1402429600-20477-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 806cbc5026933a781b66adecf6d1658fde9138e6 upstream.

Fixes a regression introduced by 060810d7abaabca "drm/nouveau: fix locking
issues in page flipping paths".  chan->cli->mutex is unlocked a second time
in the fail_unreserve path, fix this by moving mutex_unlock down.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 91c826c..a0b2b87 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -658,9 +658,9 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	}
 
 	ret = nouveau_page_flip_emit(chan, old_bo, new_bo, s, &fence);
-	mutex_unlock(&chan->cli->mutex);
 	if (ret)
 		goto fail_unreserve;
+	mutex_unlock(&chan->cli->mutex);
 
 	/* Update the crtc struct and cleanup */
 	crtc->fb = fb;
-- 
1.9.1

