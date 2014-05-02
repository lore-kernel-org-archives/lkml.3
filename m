Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaEBJeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:34:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19288 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaEBJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 May 2014 02:28:15 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 6/9] drm/nouveau/graph: enable when using external fw
Date: Fri, 2 May 2014 18:32:39 +0900
Message-ID: <1399023162-13159-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nvc0_graph_ctor() would only let the graphics engine be enabled if its
oclass has a proper microcode linked to it. This prevents GR from being
enabled at all on chips that rely exclusively on external firmware, even
though such a use-case is valid.

Relax the conditions enabling the GR engine to also include the case
where an external firmware has also been loaded.

Also switch to external firmware if the graph class has no microcode
linked to it.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index f3c7329da0a0..83dca0700ae5 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -1259,10 +1259,14 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nvc0_graph_oclass *oclass = (void *)bclass;
 	struct nouveau_device *device = nv_device(parent);
 	struct nvc0_graph_priv *priv;
+	bool use_ext_fw, enable;
 	int ret, i;
 
-	ret = nouveau_graph_create(parent, engine, bclass,
-				   (oclass->fecs.ucode != NULL), &priv);
+	use_ext_fw = nouveau_boolopt(device->cfgopt, "NvGrUseFW",
+				     oclass->fecs.ucode == NULL);
+	enable = use_ext_fw || oclass->fecs.ucode != NULL;
+
+	ret = nouveau_graph_create(parent, engine, bclass, enable, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
@@ -1272,7 +1276,7 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	priv->base.units = nvc0_graph_units;
 
-	if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", false)) {
+	if (use_ext_fw) {
 		nv_info(priv, "using external firmware\n");
 		if (nvc0_graph_ctor_fw(priv, "fuc409c", &priv->fuc409c) ||
 		    nvc0_graph_ctor_fw(priv, "fuc409d", &priv->fuc409d) ||
-- 
1.9.2

