Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaDYHVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:21:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4797 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaDYHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:20:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 25 Apr 2014 00:11:52 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 6/9] drm/nouveau/graph: enable when using external firmware
Date: Fri, 25 Apr 2014 16:19:53 +0900
Message-ID: <1398410396-23338-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
References: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
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

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index f3c7329da0a0..e5b75f189988 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -1259,10 +1259,13 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	struct nvc0_graph_oclass *oclass = (void *)bclass;
 	struct nouveau_device *device = nv_device(parent);
 	struct nvc0_graph_priv *priv;
+	bool use_ext_fw, enable;
 	int ret, i;
 
-	ret = nouveau_graph_create(parent, engine, bclass,
-				   (oclass->fecs.ucode != NULL), &priv);
+	use_ext_fw = nouveau_boolopt(device->cfgopt, "NvGrUseFW", false);
+	enable = use_ext_fw || oclass->fecs.ucode != NULL;
+
+	ret = nouveau_graph_create(parent, engine, bclass, enable, &priv);
 	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
@@ -1272,7 +1275,7 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	priv->base.units = nvc0_graph_units;
 
-	if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", false)) {
+	if (use_ext_fw) {
 		nv_info(priv, "using external firmware\n");
 		if (nvc0_graph_ctor_fw(priv, "fuc409c", &priv->fuc409c) ||
 		    nvc0_graph_ctor_fw(priv, "fuc409d", &priv->fuc409d) ||
-- 
1.9.2

