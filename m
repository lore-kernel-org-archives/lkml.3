Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3IEU2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3IEU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 01/36] drm/nouveau/mc: fix race condition between constructor and request_irq()
Date: Thu,  5 Sep 2013 13:27:30 -0700
Message-Id: <20130905202702.463603327@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 6ff8c76a566f823d796359a6c1d76b7668f1e34d upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h |    7 ++++---
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c    |    6 +++++-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c    |    3 +--
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c    |    3 +--
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c    |    3 +--
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c    |    3 +--
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c    |    3 +--
 7 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
@@ -20,8 +20,8 @@ nouveau_mc(void *obj)
 	return (void *)nv_device(obj)->subdev[NVDEV_SUBDEV_MC];
 }
 
-#define nouveau_mc_create(p,e,o,d)                                             \
-	nouveau_mc_create_((p), (e), (o), sizeof(**d), (void **)d)
+#define nouveau_mc_create(p,e,o,m,d)                                           \
+	nouveau_mc_create_((p), (e), (o), (m), sizeof(**d), (void **)d)
 #define nouveau_mc_destroy(p) ({                                               \
 	struct nouveau_mc *pmc = (p); _nouveau_mc_dtor(nv_object(pmc));        \
 })
@@ -33,7 +33,8 @@ nouveau_mc(void *obj)
 })
 
 int  nouveau_mc_create_(struct nouveau_object *, struct nouveau_object *,
-			struct nouveau_oclass *, int, void **);
+			struct nouveau_oclass *, const struct nouveau_mc_intr *,
+			int, void **);
 void _nouveau_mc_dtor(struct nouveau_object *);
 int  _nouveau_mc_init(struct nouveau_object *);
 int  _nouveau_mc_fini(struct nouveau_object *, bool);
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
@@ -80,7 +80,9 @@ _nouveau_mc_dtor(struct nouveau_object *
 
 int
 nouveau_mc_create_(struct nouveau_object *parent, struct nouveau_object *engine,
-		   struct nouveau_oclass *oclass, int length, void **pobject)
+		   struct nouveau_oclass *oclass,
+		   const struct nouveau_mc_intr *intr_map,
+		   int length, void **pobject)
 {
 	struct nouveau_device *device = nv_device(parent);
 	struct nouveau_mc *pmc;
@@ -92,6 +94,8 @@ nouveau_mc_create_(struct nouveau_object
 	if (ret)
 		return ret;
 
+	pmc->intr_map = intr_map;
+
 	ret = request_irq(device->pdev->irq, nouveau_mc_intr,
 			  IRQF_SHARED, "nouveau", pmc);
 	if (ret < 0)
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c
@@ -50,12 +50,11 @@ nv04_mc_ctor(struct nouveau_object *pare
 	struct nv04_mc_priv *priv;
 	int ret;
 
-	ret = nouveau_mc_create(parent, engine, oclass, &priv);
+	ret = nouveau_mc_create(parent, engine, oclass, nv04_mc_intr, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	priv->base.intr_map = nv04_mc_intr;
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c
@@ -36,12 +36,11 @@ nv44_mc_ctor(struct nouveau_object *pare
 	struct nv44_mc_priv *priv;
 	int ret;
 
-	ret = nouveau_mc_create(parent, engine, oclass, &priv);
+	ret = nouveau_mc_create(parent, engine, oclass, nv04_mc_intr, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	priv->base.intr_map = nv04_mc_intr;
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
@@ -52,12 +52,11 @@ nv50_mc_ctor(struct nouveau_object *pare
 	struct nv50_mc_priv *priv;
 	int ret;
 
-	ret = nouveau_mc_create(parent, engine, oclass, &priv);
+	ret = nouveau_mc_create(parent, engine, oclass, nv50_mc_intr, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	priv->base.intr_map = nv50_mc_intr;
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
@@ -54,12 +54,11 @@ nv98_mc_ctor(struct nouveau_object *pare
 	struct nv98_mc_priv *priv;
 	int ret;
 
-	ret = nouveau_mc_create(parent, engine, oclass, &priv);
+	ret = nouveau_mc_create(parent, engine, oclass, nv98_mc_intr, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	priv->base.intr_map = nv98_mc_intr;
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
@@ -56,12 +56,11 @@ nvc0_mc_ctor(struct nouveau_object *pare
 	struct nvc0_mc_priv *priv;
 	int ret;
 
-	ret = nouveau_mc_create(parent, engine, oclass, &priv);
+	ret = nouveau_mc_create(parent, engine, oclass, nvc0_mc_intr, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	priv->base.intr_map = nvc0_mc_intr;
 	return 0;
 }
 


