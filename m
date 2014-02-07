Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaBGMSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:18:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaBGLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 165/233] drm/nouveau/falcon: use vmalloc to create firwmare copies
Date: Fri,  7 Feb 2014 11:46:24 +0000
Message-Id: <1391773652-25214-166-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 90d6db1635d5e225623af2e2e859feb607345287 upstream.

Some firmware images may be large (64K), so using kmalloc memory is
inappropriate for them. Use vmalloc instead, to avoid high-order
allocation failures.

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/falcon.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/falcon.c b/drivers/gpu/drm/nouveau/core/engine/falcon.c
index e03fc8e..5e077e4 100644
--- a/drivers/gpu/drm/nouveau/core/engine/falcon.c
+++ b/drivers/gpu/drm/nouveau/core/engine/falcon.c
@@ -56,6 +56,16 @@ _nouveau_falcon_wr32(struct nouveau_object *object, u64 addr, u32 data)
 	nv_wr32(falcon, falcon->addr + addr, data);
 }
 
+static void *
+vmemdup(const void *src, size_t len)
+{
+	void *p = vmalloc(len);
+
+	if (p)
+		memcpy(p, src, len);
+	return p;
+}
+
 int
 _nouveau_falcon_init(struct nouveau_object *object)
 {
@@ -111,7 +121,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 
 		ret = request_firmware(&fw, name, &device->pdev->dev);
 		if (ret == 0) {
-			falcon->code.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+			falcon->code.data = vmemdup(fw->data, fw->size);
 			falcon->code.size = fw->size;
 			falcon->data.data = NULL;
 			falcon->data.size = 0;
@@ -134,7 +144,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 			return ret;
 		}
 
-		falcon->data.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		falcon->data.data = vmemdup(fw->data, fw->size);
 		falcon->data.size = fw->size;
 		release_firmware(fw);
 		if (!falcon->data.data)
@@ -149,7 +159,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 			return ret;
 		}
 
-		falcon->code.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		falcon->code.data = vmemdup(fw->data, fw->size);
 		falcon->code.size = fw->size;
 		release_firmware(fw);
 		if (!falcon->code.data)
@@ -235,8 +245,8 @@ _nouveau_falcon_fini(struct nouveau_object *object, bool suspend)
 	if (!suspend) {
 		nouveau_gpuobj_ref(NULL, &falcon->core);
 		if (falcon->external) {
-			kfree(falcon->data.data);
-			kfree(falcon->code.data);
+			vfree(falcon->data.data);
+			vfree(falcon->code.data);
 			falcon->code.data = NULL;
 		}
 	}
-- 
1.8.3.2

