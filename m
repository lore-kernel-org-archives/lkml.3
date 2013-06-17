Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3FQKzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:55:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42723 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3FQKzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:55:44 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, sachin.kamat@linaro.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH V3 12/15] ASoC: spear: Convert to use devm_ioremap_resource
Date: Mon, 17 Jun 2013 16:10:57 +0530
Message-Id: <1371465657-22981-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130617102000.GB1403@sirena.org.uk>
References: <20130617102000.GB1403@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

devm_request_mem_region is called in devm_ioremap_resource(). Hence that
part can also be removed.

Since devm_ioremap_resource prints error message on failure, there is
no need to print an explicit warning message.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: alsa-devel@alsa-project.org
CC: Liam Girdwood <lgirdwood@gmail.com>
CC: Mark Brown <broonie@kernel.org>
---
Changes for V3:
* Rebased on for-next branch of sound/soc git tree
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git

Changes for V2:
* Removed redundant print of error message from devm_ioremap_resource
exit path
* Call to devm_request_mem_region is removed.

 sound/soc/spear/spdif_out.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/sound/soc/spear/spdif_out.c b/sound/soc/spear/spdif_out.c
index a4a8748..2fdf68c 100644
--- a/sound/soc/spear/spdif_out.c
+++ b/sound/soc/spear/spdif_out.c
@@ -282,27 +282,16 @@ static int spdif_out_probe(struct platform_device *pdev)
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
 
-	host->io_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->io_base) {
-		dev_warn(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	host->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->io_base))
+		return PTR_ERR(host->io_base);
 
 	host->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(host->clk))
-- 
1.7.9.5

