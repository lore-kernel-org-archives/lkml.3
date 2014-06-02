Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaFBI7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:59:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38648 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbaFBI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mfd: arizona: Don't use devres for DCVDD
Date: Mon,  2 Jun 2014 09:50:41 +0100
Message-Id: <1401699043-16835-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the Arizona core uses a devm_regulator_get against its own
device node to obtain DCVDD. The Arizona core is an MFD device and DCVDD
is usually supplied by a child node (arizona-ldo1) of the core. As
devres destruction for the MFD device will run after all its children
have been destroyed, the regulator will be destroyed before devres
calls regulator_put. This causes a warning from both the destruction of
the child node, as the regulator is still open, and from the put of the
regulator as the regulator device has already been destroyed.

This patch handles the regulator get and put without devres to avoid
this issue.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 48acac6..7678e84 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -676,7 +676,7 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_early;
 	}
 
-	arizona->dcvdd = devm_regulator_get(arizona->dev, "DCVDD");
+	arizona->dcvdd = regulator_get(arizona->dev, "DCVDD");
 	if (IS_ERR(arizona->dcvdd)) {
 		ret = PTR_ERR(arizona->dcvdd);
 		dev_err(dev, "Failed to request DCVDD: %d\n", ret);
@@ -690,7 +690,7 @@ int arizona_dev_init(struct arizona *arizona)
 				       "arizona /RESET");
 		if (ret != 0) {
 			dev_err(dev, "Failed to request /RESET: %d\n", ret);
-			goto err_early;
+			goto err_dcvdd;
 		}
 	}
 
@@ -699,7 +699,7 @@ int arizona_dev_init(struct arizona *arizona)
 	if (ret != 0) {
 		dev_err(dev, "Failed to enable core supplies: %d\n",
 			ret);
-		goto err_early;
+		goto err_dcvdd;
 	}
 
 	ret = regulator_enable(arizona->dcvdd);
@@ -1016,6 +1016,8 @@ err_reset:
 err_enable:
 	regulator_bulk_disable(arizona->num_core_supplies,
 			       arizona->core_supplies);
+err_dcvdd:
+	regulator_put(arizona->dcvdd);
 err_early:
 	mfd_remove_devices(dev);
 	return ret;
@@ -1027,6 +1029,7 @@ int arizona_dev_exit(struct arizona *arizona)
 	pm_runtime_disable(arizona->dev);
 
 	regulator_disable(arizona->dcvdd);
+	regulator_put(arizona->dcvdd);
 
 	mfd_remove_devices(arizona->dev);
 	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
-- 
1.7.2.5

