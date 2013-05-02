Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3EBKwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:52:12 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48632 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab3EBKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:50:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-crypto@vger.kernel.org
Subject: [PATCH 1/8] crypto: ux500/hash - Prepare clock before enabling it
Date: Thu,  2 May 2013 11:49:43 +0100
Message-Id: <1367491790-9727-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
References: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to prepare the ux500-hash clock before enabling it the
platform will fail to boot. Here we insure this happens.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-crypto@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 632c333..1e8b2f3 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1727,11 +1727,17 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_regulator;
 	}
 
+	ret = clk_prepare(device_data->clk);
+	if (ret) {
+		dev_err(dev, "[%s] clk_prepare() failed!", __func__);
+		goto out_clk;
+	}
+
 	/* Enable device power (and clock) */
 	ret = hash_enable_power(device_data, false);
 	if (ret) {
 		dev_err(dev, "[%s]: hash_enable_power() failed!", __func__);
-		goto out_clk;
+		goto out_clk_unprepare;
 	}
 
 	ret = hash_check_hw(device_data);
@@ -1763,6 +1769,9 @@ static int ux500_hash_probe(struct platform_device *pdev)
 out_power:
 	hash_disable_power(device_data, false);
 
+out_clk_unprepare:
+	clk_unprepare(device_data->clk);
+
 out_clk:
 	clk_put(device_data->clk);
 
@@ -1827,6 +1836,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
 		dev_err(dev, "[%s]: hash_disable_power() failed",
 			__func__);
 
+	clk_unprepare(device_data->clk);
 	clk_put(device_data->clk);
 	regulator_put(device_data->regulator);
 
-- 
1.7.10.4

