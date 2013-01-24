Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3AXDcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AXDbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 59/74] drm/nv17-50: restore fence buffer on resume
Date: Thu, 24 Jan 2013 01:27:11 -0200
Message-Id: <1358998046-613-60-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: backport for 3.5, looks like we only need to call
  nouveau_bo_wr32 on nv10_fence_init ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nv10_fence.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
index 8a1b750..18932a6 100644
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -155,6 +155,9 @@ nv10_fence_fini(struct drm_device *dev, int engine, bool suspend)
 static int
 nv10_fence_init(struct drm_device *dev, int engine)
 {
+	struct nv10_fence_priv *priv = nv_engine(dev, engine);
+
+	nouveau_bo_wr32(priv->bo, 0, priv->sequence);
 	return 0;
 }
 
-- 
1.7.9.5

