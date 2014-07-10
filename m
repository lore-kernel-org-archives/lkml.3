Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaGJHfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:35:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15338 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaGJHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:34:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 00:23:59 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/3] drm/nouveau/clk: support for non-BIOS pstates
Date: Thu, 10 Jul 2014 16:34:36 +0900
Message-ID: <1404977677-22248-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make nouveau_clock_create() take new two optional arguments: an array
of pstates and its size. When these are specified,
nouveau_clock_create() will use the provided pstates instead of
probing them using the BIOS.

This is useful for platforms which do not provide a BIOS, like Tegra.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/include/subdev/clock.h |  8 +++++---
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c    | 16 ++++++++++++----
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c    |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c    |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c    |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c    |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c    |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c    |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c    |  4 ++--
 9 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
index c01e29c9f89a..c0fe191c9787 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
@@ -108,8 +108,9 @@ struct nouveau_clocks {
 	int mdiv;
 };
 
-#define nouveau_clock_create(p,e,o,i,r,d)                                      \
-	nouveau_clock_create_((p), (e), (o), (i), (r), sizeof(**d), (void **)d)
+#define nouveau_clock_create(p,e,o,i,r,s,n,d)                                  \
+	nouveau_clock_create_((p), (e), (o), (i), (r), (s), (n), sizeof(**d),  \
+			      (void **)d)
 #define nouveau_clock_destroy(p) ({                                            \
 	struct nouveau_clock *clk = (p);                                       \
 	_nouveau_clock_dtor(nv_object(clk));                                   \
@@ -123,7 +124,8 @@ struct nouveau_clocks {
 
 int  nouveau_clock_create_(struct nouveau_object *, struct nouveau_object *,
 			   struct nouveau_oclass *,
-			   struct nouveau_clocks *, bool, int, void **);
+			   struct nouveau_clocks *, struct nouveau_pstate *,
+			   int, bool, int, void **);
 void _nouveau_clock_dtor(struct nouveau_object *);
 int _nouveau_clock_init(struct nouveau_object *);
 #define _nouveau_clock_fini _nouveau_subdev_fini
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
index 63b314a033cb..e5798e74d616 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
@@ -464,6 +464,7 @@ nouveau_clock_create_(struct nouveau_object *parent,
 		      struct nouveau_object *engine,
 		      struct nouveau_oclass *oclass,
 		      struct nouveau_clocks *clocks,
+		      struct nouveau_pstate *pstates, int nb_pstates,
 		      bool allow_reclock,
 		      int length, void **object)
 {
@@ -482,10 +483,17 @@ nouveau_clock_create_(struct nouveau_object *parent,
 	clk->domains = clocks;
 	clk->ustate = -1;
 
-	idx = 0;
-	do {
-		ret = nouveau_pstate_new(clk, idx++);
-	} while (ret == 0);
+	/* If no pstates are provided, try and fetch them from the BIOS */
+	if (!pstates) {
+		idx = 0;
+		do {
+			ret = nouveau_pstate_new(clk, idx++);
+		} while (ret == 0);
+	} else {
+		for (idx = 0; idx < nb_pstates; idx++)
+			list_add_tail(&pstates[idx].head, &clk->states);
+		clk->state_nr = nb_pstates;
+	}
 
 	clk->allow_reclock = allow_reclock;
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c
index eb2d4425a49e..4c48232686be 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c
@@ -82,8 +82,8 @@ nv04_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nv04_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nv04_domain, false,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nv04_domain, NULL, 0,
+				   false, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c
index 8a9e16839791..08368fe97029 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c
@@ -213,8 +213,8 @@ nv40_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nv40_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nv40_domain, true,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nv40_domain, NULL, 0,
+				   true, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c
index 8c132772ba9e..5070ebc260f8 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c
@@ -507,7 +507,7 @@ nv50_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	int ret;
 
 	ret = nouveau_clock_create(parent, engine, oclass, pclass->domains,
-				   false, &priv);
+				   NULL, 0, false, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c
index 9fb58354a80b..087012b18956 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c
@@ -302,8 +302,8 @@ nva3_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nva3_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nva3_domain, false,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nva3_domain, NULL, 0,
+				   false, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c
index 6a65fc9e9663..74e19731b1b7 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c
@@ -421,8 +421,8 @@ nvaa_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nvaa_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nvaa_domains, true,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nvaa_domains, NULL,
+				   0, true, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
index dbf8517f54da..1234abaab2db 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
@@ -437,8 +437,8 @@ nvc0_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nvc0_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nvc0_domain, false,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nvc0_domain, NULL, 0,
+				   false, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c b/drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c
index 0e62a3240144..7eccad57512e 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c
@@ -475,8 +475,8 @@ nve0_clock_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nve0_clock_priv *priv;
 	int ret;
 
-	ret = nouveau_clock_create(parent, engine, oclass, nve0_domain, true,
-				   &priv);
+	ret = nouveau_clock_create(parent, engine, oclass, nve0_domain, NULL, 0,
+				   true, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
-- 
2.0.0

