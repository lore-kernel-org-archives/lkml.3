Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3HWNPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:15:19 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:42363 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3HWNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:15:17 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 21:15:16 +0800
Message-ID: <CAPgLHd-LxjfpSm2U67HVn+eWFqU0P7Ku0XQrNMv0D--8+CoKvg@mail.gmail.com>
Subject: [PATCH -next v2] drm/rcar-du: remove redundant dev_err call in rcar_du_lvdsenc_get_resources()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, laurent.pinchart+renesas@ideasonboard.com
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_ioremap_resource() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should be
replaced with IS_ERR(). Also remove the dev_err call to avoid redundant
error message and check for return value of platform_get_resource_byname().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2; remove return value check of platform_get_resource_byname()
---
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
index a0f6a17..fe1f6f5 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
@@ -144,18 +144,9 @@ static int rcar_du_lvdsenc_get_resources(struct rcar_du_lvdsenc *lvds,
 	sprintf(name, "lvds.%u", lvds->index);
 
 	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
-	if (mem == NULL) {
-		dev_err(&pdev->dev, "failed to get memory resource for %s\n",
-			name);
-		return -EINVAL;
-	}
-
 	lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
-	if (lvds->mmio == NULL) {
-		dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
-			name);
-		return -ENOMEM;
-	}
+	if (IS_ERR(lvds->mmio))
+		return PTR_ERR(lvds->mmio);
 
 	lvds->clock = devm_clk_get(&pdev->dev, name);
 	if (IS_ERR(lvds->clock)) {

