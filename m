Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3HWCVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 22:21:23 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53667 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3HWCVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 22:21:22 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 10:21:21 +0800
Message-ID: <CAPgLHd9g4DPmTnj1bNcUQigUd3pWKfkbAoFFsig5_UR_w0vcAg@mail.gmail.com>
Subject: [PATCH -next] drm/rcar-du: fix return value check in rcar_du_lvdsenc_get_resources()
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
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
index a0f6a17..f59cbc4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
@@ -151,11 +151,8 @@ static int rcar_du_lvdsenc_get_resources(struct rcar_du_lvdsenc *lvds,
 	}
 
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

