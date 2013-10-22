Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3JVTQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:16:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab3JVTQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:16:01 -0400
Message-ID: <5266CEEC.2010606@suse.com>
Date: Tue, 22 Oct 2013 15:15:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] nouveau: Fix race with fence signaling
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists a tight race between the call to nouveau_fence_done from
nouveau_fence_wait and the call to nouveau_fence_wait_uevent.

nouveau_fence_done checks to see if fence->channel is NULL before calling
nouveau_fence_wait_uevent, but it's not good enough since the dereference
in nouveau_fence_wait_uevent is done outside the lock. Another thread
may have signaled the fence in that tight window and then we Oops
while dereferencing fence->channel->drm at the beginning of
nouveau_fence_wait_uevent.

The good news is that nouveau_fence_wait_uevent only uses fence->channel
directly to grab the chan->drm pointer. If we pass that in directly as
a known good pointer, we can avoid the race. Passing the nouveau_fence_done
check in the caller ensures that the chan pointer is valid.

Original bug report at: https://bugzilla.novell.com/show_bug.cgi?id=844177

Cc: <stable@vger.kernel.org> # 3.9+
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -180,12 +180,11 @@ nouveau_fence_wait_uevent_handler(struct
 }
 
 static int
-nouveau_fence_wait_uevent(struct nouveau_fence *fence, bool intr)
-
+nouveau_fence_wait_uevent(struct nouveau_fence *fence,
+			  struct nouveau_drm *drm, bool intr)
 {
-	struct nouveau_channel *chan = fence->channel;
-	struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);
-	struct nouveau_fence_priv *priv = chan->drm->fence;
+	struct nouveau_fifo *pfifo = nouveau_fifo(drm->device);
+	struct nouveau_fence_priv *priv = drm->fence;
 	struct nouveau_fence_uevent uevent = {
 		.handler.func = nouveau_fence_wait_uevent_handler,
 		.priv = priv,
@@ -241,7 +240,7 @@ nouveau_fence_wait(struct nouveau_fence
 	int ret = 0;
 
 	while (priv && priv->uevent && lazy && !nouveau_fence_done(fence)) {
-		ret = nouveau_fence_wait_uevent(fence, intr);
+		ret = nouveau_fence_wait_uevent(fence, chan->drm, intr);
 		if (ret < 0)
 			return ret;
 	}


-- 
Jeff Mahoney
SUSE Labs
