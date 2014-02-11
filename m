Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaBKUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:39:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaBKTF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 3.13 089/120] drm/nouveau/falcon: use vmalloc to create firwmare copies
Date: Tue, 11 Feb 2014 11:05:30 -0800
Message-Id: <20140211184826.150024123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 90d6db1635d5e225623af2e2e859feb607345287 upstream.

Some firmware images may be large (64K), so using kmalloc memory is
inappropriate for them. Use vmalloc instead, to avoid high-order
allocation failures.

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/falcon.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/engine/falcon.c
+++ b/drivers/gpu/drm/nouveau/core/engine/falcon.c
@@ -56,6 +56,16 @@ _nouveau_falcon_wr32(struct nouveau_obje
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
@@ -111,7 +121,7 @@ _nouveau_falcon_init(struct nouveau_obje
 
 		ret = request_firmware(&fw, name, &device->pdev->dev);
 		if (ret == 0) {
-			falcon->code.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+			falcon->code.data = vmemdup(fw->data, fw->size);
 			falcon->code.size = fw->size;
 			falcon->data.data = NULL;
 			falcon->data.size = 0;
@@ -134,7 +144,7 @@ _nouveau_falcon_init(struct nouveau_obje
 			return ret;
 		}
 
-		falcon->data.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		falcon->data.data = vmemdup(fw->data, fw->size);
 		falcon->data.size = fw->size;
 		release_firmware(fw);
 		if (!falcon->data.data)
@@ -149,7 +159,7 @@ _nouveau_falcon_init(struct nouveau_obje
 			return ret;
 		}
 
-		falcon->code.data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		falcon->code.data = vmemdup(fw->data, fw->size);
 		falcon->code.size = fw->size;
 		release_firmware(fw);
 		if (!falcon->code.data)
@@ -235,8 +245,8 @@ _nouveau_falcon_fini(struct nouveau_obje
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


