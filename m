Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3AOWeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:34:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:43245 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab3AOWer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:34:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 167/221] drm/nouveau: add locking around instobj list operations
Date: Tue, 15 Jan 2013 10:51:34 -0800
Message-Id: <20130115185010.093399757@linuxfoundation.org>
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

commit 4c4101d29fb6c63f78791d02c437702b11e1d4f0 upstream.

Fixes memory corruptions, oopses, etc. when multiple gpuobjs are
simultaneously created or destroyed.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c |   35 ++++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/instmem/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/instmem/base.c
@@ -40,15 +40,21 @@ nouveau_instobj_create_(struct nouveau_o
 	if (ret)
 		return ret;
 
+	mutex_lock(&imem->base.mutex);
 	list_add(&iobj->head, &imem->list);
+	mutex_unlock(&imem->base.mutex);
 	return 0;
 }
 
 void
 nouveau_instobj_destroy(struct nouveau_instobj *iobj)
 {
-	if (iobj->head.prev)
-		list_del(&iobj->head);
+	struct nouveau_subdev *subdev = nv_subdev(iobj->base.engine);
+
+	mutex_lock(&subdev->mutex);
+	list_del(&iobj->head);
+	mutex_unlock(&subdev->mutex);
+
 	return nouveau_object_destroy(&iobj->base);
 }
 
@@ -88,6 +94,8 @@ nouveau_instmem_init(struct nouveau_inst
 	if (ret)
 		return ret;
 
+	mutex_lock(&imem->base.mutex);
+
 	list_for_each_entry(iobj, &imem->list, head) {
 		if (iobj->suspend) {
 			for (i = 0; i < iobj->size; i += 4)
@@ -97,6 +105,8 @@ nouveau_instmem_init(struct nouveau_inst
 		}
 	}
 
+	mutex_unlock(&imem->base.mutex);
+
 	return 0;
 }
 
@@ -104,17 +114,26 @@ int
 nouveau_instmem_fini(struct nouveau_instmem *imem, bool suspend)
 {
 	struct nouveau_instobj *iobj;
-	int i;
+	int i, ret = 0;
 
 	if (suspend) {
+		mutex_lock(&imem->base.mutex);
+
 		list_for_each_entry(iobj, &imem->list, head) {
 			iobj->suspend = vmalloc(iobj->size);
-			if (iobj->suspend) {
-				for (i = 0; i < iobj->size; i += 4)
-					iobj->suspend[i / 4] = nv_ro32(iobj, i);
-			} else
-				return -ENOMEM;
+			if (!iobj->suspend) {
+				ret = -ENOMEM;
+				break;
+			}
+
+			for (i = 0; i < iobj->size; i += 4)
+				iobj->suspend[i / 4] = nv_ro32(iobj, i);
 		}
+
+		mutex_unlock(&imem->base.mutex);
+
+		if (ret)
+			return ret;
 	}
 
 	return nouveau_subdev_fini(&imem->base, suspend);


