Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaCXIqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:09 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11516 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaCXIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Mar 2014 01:42:06 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 03/12] drm/nouveau/bar: only ioremap BAR3 if it exists
Date: Mon, 24 Mar 2014 17:42:25 +0900
Message-ID: <1395650554-31925-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
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
index bdf594116f3f..d713eeb75b13 100644
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
1.9.1

