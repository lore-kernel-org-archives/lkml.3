Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaFBI6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:58:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbaFBI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] mfd: arizona: Disable DCVDD before we destroy the MFD
Date: Mon,  2 Jun 2014 09:50:40 +0100
Message-Id: <1401699043-16835-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As DCVDD is probably supplied by a child of the MFD device move its
disable to before we destroy the MFD children as the regulator likely
won't exist after that.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 7bdc0f5..48acac6 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1026,6 +1026,8 @@ int arizona_dev_exit(struct arizona *arizona)
 {
 	pm_runtime_disable(arizona->dev);
 
+	regulator_disable(arizona->dcvdd);
+
 	mfd_remove_devices(arizona->dev);
 	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
 	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
@@ -1033,7 +1035,7 @@ int arizona_dev_exit(struct arizona *arizona)
 	arizona_irq_exit(arizona);
 	if (arizona->pdata.reset)
 		gpio_set_value_cansleep(arizona->pdata.reset, 0);
-	regulator_disable(arizona->dcvdd);
+
 	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
 			       arizona->core_supplies);
 	return 0;
-- 
1.7.2.5

