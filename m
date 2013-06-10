Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3FJLus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:48 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33856 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3FJLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:43 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 12/15] ASoC: spear: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:10 +0530
Message-Id: <1370864113-17895-13-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: alsa-devel@alsa-project.org
CC: Liam Girdwood <lgirdwood@gmail.com>
CC: Mark Brown <broonie@kernel.org>
---
 sound/soc/spear/spdif_out.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/sound/soc/spear/spdif_out.c b/sound/soc/spear/spdif_out.c
index 4bde512..896ee7f 100644
--- a/sound/soc/spear/spdif_out.c
+++ b/sound/soc/spear/spdif_out.c
@@ -282,27 +282,17 @@ static int spdif_out_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				resource_size(res), pdev->name)) {
-		dev_warn(&pdev->dev, "Failed to get memory resourse\n");
-		return -ENOENT;
-	}
-
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
 	if (!host) {
 		dev_warn(&pdev->dev, "kzalloc fail\n");
 		return -ENOMEM;
 	}
 
-	host->io_base = devm_request_and_ioremap(&pdev->dev, res->start,
-				resource_size(res));
-	if (!host->io_base) {
-		dev_warn(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	host->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->io_base)) {
+		dev_warn(&pdev->dev, "devm_ioremap_resource failed\n");
+		return PTR_ERR(host->io_base);
 	}
 
 	host->clk = devm_clk_get(&pdev->dev, NULL);
-- 
1.7.9.5

