Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3AOWe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:34:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:43208 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab3AOWdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 165/221] drm/nv17-50: restore fence buffer on resume
Date: Tue, 15 Jan 2013 10:51:32 -0800
Message-Id: <20130115185009.949612897@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit f20ebd034eab43fd38c58b11c5bb5fb125e5f7d7 upstream.

Since commit 5e120f6e4b3f35b741c5445dfc755f50128c3c44 "drm/nouveau/fence:
convert to exec engine, and improve channel sync" nouveau fence sync
implementation for nv17-50 and nvc0+ started to rely on state of fence buffer
left by previous sync operation. But as pinned bo's (where fence state is
stored) are not saved+restored across suspend/resume, we need to do it
manually.

nvc0+ was fixed by commit d6ba6d215a538a58f0f0026f0961b0b9125e8042
"drm/nvc0/fence: restore pre-suspend fence buffer context on resume".

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=50121

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_fence.h |    1 +
 drivers/gpu/drm/nouveau/nv10_fence.c    |    8 ++++++++
 drivers/gpu/drm/nouveau/nv50_fence.c    |    1 +
 3 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -60,6 +60,7 @@ u32  nv10_fence_read(struct nouveau_chan
 void nv10_fence_context_del(struct nouveau_channel *);
 void nv10_fence_destroy(struct nouveau_drm *);
 int  nv10_fence_create(struct nouveau_drm *);
+void nv17_fence_resume(struct nouveau_drm *drm);
 
 int nv50_fence_create(struct nouveau_drm *);
 int nv84_fence_create(struct nouveau_drm *);
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -160,6 +160,13 @@ nv10_fence_destroy(struct nouveau_drm *d
 	kfree(priv);
 }
 
+void nv17_fence_resume(struct nouveau_drm *drm)
+{
+	struct nv10_fence_priv *priv = drm->fence;
+
+	nouveau_bo_wr32(priv->bo, 0, priv->sequence);
+}
+
 int
 nv10_fence_create(struct nouveau_drm *drm)
 {
@@ -192,6 +199,7 @@ nv10_fence_create(struct nouveau_drm *dr
 		if (ret == 0) {
 			nouveau_bo_wr32(priv->bo, 0x000, 0x00000000);
 			priv->base.sync = nv17_fence_sync;
+			priv->base.resume = nv17_fence_resume;
 		}
 	}
 
--- a/drivers/gpu/drm/nouveau/nv50_fence.c
+++ b/drivers/gpu/drm/nouveau/nv50_fence.c
@@ -119,6 +119,7 @@ nv50_fence_create(struct nouveau_drm *dr
 	if (ret == 0) {
 		nouveau_bo_wr32(priv->bo, 0x000, 0x00000000);
 		priv->base.sync = nv17_fence_sync;
+		priv->base.resume = nv17_fence_resume;
 	}
 
 	if (ret)


