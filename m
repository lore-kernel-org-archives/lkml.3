Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3BLUgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3BLUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel J Blueman <daniel@quora.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 61/61] drm/nouveau: add lockdep annotations
Date: Tue, 12 Feb 2013 12:35:21 -0800
Message-Id: <20130212203426.021116247@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 5f97ab913cf0fbc378ea8ffc3ee66f4890d11c55 upstream.

1) Lockdep thinks all nouveau subdevs belong to the same class and can be
locked in arbitrary order, which is not true (at least in general case).
Tell it to distinguish subdevs by (o)class type.
2) DRM client can be locked under user client lock - tell lockdep to put
DRM client lock in a separate class.

Reported-by: Arend van Spriel <arend@broadcom.com>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
Reported-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reported-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/core/subdev.c         |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h |    7 +++++--
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    3 +++
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/core/subdev.c
+++ b/drivers/gpu/drm/nouveau/core/core/subdev.c
@@ -99,7 +99,7 @@ nouveau_subdev_create_(struct nouveau_ob
 	if (ret)
 		return ret;
 
-	mutex_init(&subdev->mutex);
+	__mutex_init(&subdev->mutex, subname, &oclass->lock_class_key);
 	subdev->name = subname;
 
 	if (parent) {
--- a/drivers/gpu/drm/nouveau/core/include/core/object.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/object.h
@@ -50,10 +50,13 @@ int  nouveau_object_fini(struct nouveau_
 
 extern struct nouveau_ofuncs nouveau_object_ofuncs;
 
+/* Don't allocate dynamically, because lockdep needs lock_class_keys to be in
+ * ".data". */
 struct nouveau_oclass {
 	u32 handle;
-	struct nouveau_ofuncs *ofuncs;
-	struct nouveau_omthds *omthds;
+	struct nouveau_ofuncs * ofuncs;
+	struct nouveau_omthds * const omthds;
+	struct lock_class_key lock_class_key;
 };
 
 #define nv_oclass(o)    nv_object(o)->oclass
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -241,6 +241,8 @@ nouveau_drm_probe(struct pci_dev *pdev,
 	return 0;
 }
 
+static struct lock_class_key drm_client_lock_class_key;
+
 static int
 nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 {
@@ -252,6 +254,7 @@ nouveau_drm_load(struct drm_device *dev,
 	ret = nouveau_cli_create(pdev, "DRM", sizeof(*drm), (void**)&drm);
 	if (ret)
 		return ret;
+	lockdep_set_class(&drm->client.mutex, &drm_client_lock_class_key);
 
 	dev->dev_private = drm;
 	drm->dev = dev;


