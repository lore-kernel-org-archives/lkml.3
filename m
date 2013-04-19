Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab3DSMWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:22:33 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53872 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968238Ab3DSMWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:22:32 -0400
Date: Fri, 19 Apr 2013 13:22:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 4/9 v2] crypto: ux500/cryp - Prepare clock before enabling it
Message-ID: <20130419122226.GB3432@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366280825-31136-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slight change of plan for v2.

Now we're doing a seperate clk_prepare(), as the clk_enable() in the
previous patch turned out to be called inside a spin_lock().

Arnd, can you confirm your Ack please?

----

crypto: ux500/cryp - Prepare clock before enabling it
    
If we fail to prepare the ux500-cryp clock before enabling it the
platform will fail to boot. Here we insure this happens.
    
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 22c9063..bf78d60 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1459,11 +1459,17 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_regulator;
 	}
 
+	ret = clk_prepare(device_data->clk);
+	if (ret) {
+		dev_err(dev, "[%s]: clk_prepare() failed!", __func__);
+		goto out_clk;
+	}
+
 	/* Enable device power (and clock) */
 	ret = cryp_enable_power(device_data->dev, device_data, false);
 	if (ret) {
 		dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
-		goto out_clk;
+		goto out_clk_unprepare;
 	}
 
 	cryp_error = cryp_check(device_data);
@@ -1524,6 +1530,9 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 out_power:
 	cryp_disable_power(device_data->dev, device_data, false);
 
+out_clk_unprepare:
+	clk_unprepare(device_data->clk);
+
 out_clk:
 	clk_put(device_data->clk);
 
@@ -1594,6 +1603,7 @@ static int ux500_cryp_remove(struct platform_device *pdev)
 		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
 			__func__);
 
+	clk_unprepare(device_data->clk);
 	clk_put(device_data->clk);
 	regulator_put(device_data->pwr_regulator);
