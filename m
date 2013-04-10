Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937044Ab3DJXPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:15:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937131Ab3DJWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 16/64] drm/nouveau: fix handling empty channel list in ioctls
Date: Wed, 10 Apr 2013 15:46:13 -0700
Message-Id: <20130410224336.802903559@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit b43decd2c513ae44a5462a1a4c2622f0fa77c9e0 upstream.

If there are no channels, chan would never end up being NULL,
and so the null pointer check would fail.

Solve this by initializing chan to NULL, and iterating over temp instead.

Fixes oops when running intel-gpu-tools/tests/kms_flip, which attempts to
do some intel ioctl's on a nouveau device.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_abi16.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -386,7 +386,7 @@ nouveau_abi16_ioctl_notifierobj_alloc(AB
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_device *device = nv_device(drm->device);
 	struct nouveau_abi16 *abi16 = nouveau_abi16_get(file_priv, dev);
-	struct nouveau_abi16_chan *chan, *temp;
+	struct nouveau_abi16_chan *chan = NULL, *temp;
 	struct nouveau_abi16_ntfy *ntfy;
 	struct nouveau_object *object;
 	struct nv_dma_class args = {};
@@ -399,10 +399,11 @@ nouveau_abi16_ioctl_notifierobj_alloc(AB
 	if (unlikely(nv_device(abi16->device)->card_type >= NV_C0))
 		return nouveau_abi16_put(abi16, -EINVAL);
 
-	list_for_each_entry_safe(chan, temp, &abi16->channels, head) {
-		if (chan->chan->handle == (NVDRM_CHAN | info->channel))
+	list_for_each_entry(temp, &abi16->channels, head) {
+		if (temp->chan->handle == (NVDRM_CHAN | info->channel)) {
+			chan = temp;
 			break;
-		chan = NULL;
+		}
 	}
 
 	if (!chan)
@@ -454,17 +455,18 @@ nouveau_abi16_ioctl_gpuobj_free(ABI16_IO
 {
 	struct drm_nouveau_gpuobj_free *fini = data;
 	struct nouveau_abi16 *abi16 = nouveau_abi16_get(file_priv, dev);
-	struct nouveau_abi16_chan *chan, *temp;
+	struct nouveau_abi16_chan *chan = NULL, *temp;
 	struct nouveau_abi16_ntfy *ntfy;
 	int ret;
 
 	if (unlikely(!abi16))
 		return -ENOMEM;
 
-	list_for_each_entry_safe(chan, temp, &abi16->channels, head) {
-		if (chan->chan->handle == (NVDRM_CHAN | fini->channel))
+	list_for_each_entry(temp, &abi16->channels, head) {
+		if (temp->chan->handle == (NVDRM_CHAN | fini->channel)) {
+			chan = temp;
 			break;
-		chan = NULL;
+		}
 	}
 
 	if (!chan)


