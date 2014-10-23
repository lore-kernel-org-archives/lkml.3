Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaJWIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:16:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5585 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaJWIQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:16:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Oct 2014 01:12:20 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/panel: ld9040: Update calls to gpiod_get*()
Date: Thu, 23 Oct 2014 17:16:17 +0900
Message-ID: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new flags argument to calls of (devm_)gpiod_get*() and
remove any direction setting code afterwards.

Currently both forms (with or without the flags argument)
are valid thanks to transitional macros in
<linux/gpio/consumer.h>. These macros will be removed once
all consumers are updated and the flags argument will become
compulsary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-ld9040.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ld9040.c b/drivers/gpu/drm/panel/panel-ld9040.c
index 42ac67b21e9f..dd1d3f2e624e 100644
--- a/drivers/gpu/drm/panel/panel-ld9040.c
+++ b/drivers/gpu/drm/panel/panel-ld9040.c
@@ -336,17 +336,12 @@ static int ld9040_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	ctx->reset_gpio = devm_gpiod_get(dev, "reset");
+	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(ctx->reset_gpio)) {
 		dev_err(dev, "cannot get reset-gpios %ld\n",
 			PTR_ERR(ctx->reset_gpio));
 		return PTR_ERR(ctx->reset_gpio);
 	}
-	ret = gpiod_direction_output(ctx->reset_gpio, 1);
-	if (ret < 0) {
-		dev_err(dev, "cannot configure reset-gpios %d\n", ret);
-		return ret;
-	}
 
 	spi->bits_per_word = 9;
 	ret = spi_setup(spi);
-- 
2.1.2

