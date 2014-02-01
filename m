Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaBAD3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:14 -0500
Received: from gnurou.org ([207.192.72.5]:51793 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaBAD2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:25 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 06/16] drm/nouveau/bar: only ioremap BAR3 if it exists
Date: Sat,  1 Feb 2014 12:16:48 +0900
Message-Id: <1391224618-3794-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips that use system memory exclusively (e.g. GK20A) do not
expose 2 BAR regions. For them only BAR1 exists, and it should be used
for USERD mapping. Do not map BAR3 if its resource does not exist.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
index bdf5941..d713eeb 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
@@ -110,6 +110,7 @@ nouveau_bar_create_(struct nouveau_object *parent,
 {
 	struct nouveau_device *device = nv_device(parent);
 	struct nouveau_bar *bar;
+	bool has_bar3 = nv_device_resource_len(device, 3) != 0;
 	int ret;
 
 	ret = nouveau_subdev_create_(parent, engine, oclass, 0, "BARCTL",
@@ -118,8 +119,10 @@ nouveau_bar_create_(struct nouveau_object *parent,
 	if (ret)
 		return ret;
 
-	bar->iomem = ioremap(nv_device_resource_start(device, 3),
-			     nv_device_resource_len(device, 3));
+	if (has_bar3)
+		bar->iomem = ioremap(nv_device_resource_start(device, 3),
+				     nv_device_resource_len(device, 3));
+
 	return 0;
 }
 
-- 
1.8.5.3

