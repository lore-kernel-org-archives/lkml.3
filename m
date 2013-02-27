Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3B0OKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:10:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2778 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760046Ab3B0OKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:10:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 27 Feb 2013 06:08:23 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <gg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <ian@slimlogic.co.uk>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] mfd: palmas: get rid of of_platform_populate() in DT registration
Date: Wed, 27 Feb 2013 19:38:40 +0530
Message-ID: <1361974120-18134-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1361974120-18134-1-git-send-email-ldewangan@nvidia.com>
References: <1361974120-18134-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If driver is getting registered through DT then it look for
population of platform data which is not possible if platform
completely support the DT.

In this case, if device is registered through DT then just ignore
platform data population and continue the further registration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 25f0eab..6771d9b 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -465,18 +465,6 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret)
 		goto err_irq;
 
-	/*
-	 * If we are probing with DT do this the DT way and return here
-	 * otherwise continue and add devices using mfd helpers.
-	 */
-	if (node) {
-		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
-		if (ret < 0)
-			goto err_irq;
-		else
-			return ret;
-	}
-
 	children = kmemdup(palmas_children, sizeof(palmas_children),
 			   GFP_KERNEL);
 	if (!children) {
@@ -484,6 +472,14 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		goto err_irq;
 	}
 
+	/*
+	 * If we are probing with DT then skip the platform data initialisation
+	 * for children.
+	 */
+	if (node)
+		goto skip_platform_data_init;
+
+
 	children[PALMAS_PMIC_ID].platform_data = pdata->pmic_pdata;
 	children[PALMAS_PMIC_ID].pdata_size = sizeof(*pdata->pmic_pdata);
 
@@ -500,6 +496,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	children[PALMAS_CLK_ID].platform_data = pdata->clk_pdata;
 	children[PALMAS_CLK_ID].pdata_size = sizeof(*pdata->clk_pdata);
 
+skip_platform_data_init:
 	ret = mfd_add_devices(palmas->dev, -1,
 			      children, ARRAY_SIZE(palmas_children),
 			      NULL, 0,
-- 
1.7.1.1

