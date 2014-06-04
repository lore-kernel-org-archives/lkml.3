Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaFEA03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:26:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaFDXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.14 115/228] drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip
Date: Wed,  4 Jun 2014 16:22:24 -0700
Message-Id: <20140604232351.734428042@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 806cbc5026933a781b66adecf6d1658fde9138e6 upstream.

Fixes a regression introduced by 060810d7abaabca "drm/nouveau: fix locking
issues in page flipping paths".  chan->cli->mutex is unlocked a second time
in the fail_unreserve path, fix this by moving mutex_unlock down.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -762,9 +762,9 @@ nouveau_crtc_page_flip(struct drm_crtc *
 	}
 
 	ret = nouveau_page_flip_emit(chan, old_bo, new_bo, s, &fence);
-	mutex_unlock(&chan->cli->mutex);
 	if (ret)
 		goto fail_unreserve;
+	mutex_unlock(&chan->cli->mutex);
 
 	/* Update the crtc struct and cleanup */
 	crtc->fb = fb;


