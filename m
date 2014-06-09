Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbaFIIwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:52:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58478 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/146] drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip
Date: Mon,  9 Jun 2014 10:50:14 +0200
Message-Id: <53f889b331b7aad9de592d08f80685da65e2d068.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 806cbc5026933a781b66adecf6d1658fde9138e6 upstream.

Fixes a regression introduced by 060810d7abaabca "drm/nouveau: fix locking
issues in page flipping paths".  chan->cli->mutex is unlocked a second time
in the fail_unreserve path, fix this by moving mutex_unlock down.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 7848590f5568..fb072e6a361d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -586,9 +586,9 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	}
 
 	ret = nouveau_page_flip_emit(chan, old_bo, new_bo, s, &fence);
-	mutex_unlock(&chan->cli->mutex);
 	if (ret)
 		goto fail_unreserve;
+	mutex_unlock(&chan->cli->mutex);
 
 	/* Update the crtc struct and cleanup */
 	crtc->fb = fb;
-- 
1.9.3

