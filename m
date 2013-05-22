Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3EVMsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:48:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60364 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3EVMsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:48:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, linus.walleij@linaro.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] regulator: ab8500-ext: Don't register without initialisation data
Date: Wed, 22 May 2013 13:47:33 +0100
Message-Id: <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug introduced in the v3.10 merge window.

Some platforms will not want external registers. Rather than setting up
lots of different clauses in the core ab8500 regulator driver not to
call ab8500-ext init() we just won't pass the initialisation data from
platform code. This patch checks for it and if it's missing, we won't
register the external regulators.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index b4d4547..8421537 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -334,6 +334,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* have any external regulators been specified? */
+	if (pdata->num_ext_regulator == 0) {
+		dev_warn(&pdev->dev, "Not using external regulators\n");
+		return 0;
+	}
+
 	/* make sure the platform data has the correct size */
 	if (pdata->num_ext_regulator != ARRAY_SIZE(ab8500_ext_regulator_info)) {
 		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
-- 
1.7.10.4

