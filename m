Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968115Ab3DRK1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:27:33 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33745 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968096Ab3DRK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:27:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/9] crypto: ux500/hash - Prepare clock before enabling it
Date: Thu, 18 Apr 2013 11:26:57 +0100
Message-Id: <1366280825-31136-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to prepare the ux500-hash clock before enabling it the
platform will fail to boot. Here we insure this happens.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 632c333..118386a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -308,10 +308,10 @@ static int hash_disable_power(
 		device_data->restore_dev_state = true;
 	}
 
-	clk_disable(device_data->clk);
+	clk_disable_unprepare(device_data->clk);
 	ret = regulator_disable(device_data->regulator);
 	if (ret)
-		dev_err(dev, "[%s] regulator_disable() failed!", __func__);
+		dev_err(dev, "[%s] regulator_disable_unprepare() failed!", __func__);
 
 	device_data->power_state = false;
 
@@ -344,9 +344,9 @@ static int hash_enable_power(
 					__func__);
 			goto out;
 		}
-		ret = clk_enable(device_data->clk);
+		ret = clk_prepare_enable(device_data->clk);
 		if (ret) {
-			dev_err(dev, "[%s]: clk_enable() failed!",
+			dev_err(dev, "[%s]: clk_prepare_enable() failed!",
 					__func__);
 			ret = regulator_disable(
 					device_data->regulator);
-- 
1.7.10.4

