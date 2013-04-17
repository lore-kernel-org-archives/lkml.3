Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966941Ab3DQP6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:58:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50373 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966899Ab3DQP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:58:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] mfd: arizona: Add missing cleanup on remove
Date: Wed, 17 Apr 2013 16:58:34 +0100
Message-Id: <1366214315-29032-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366214315-29032-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130417155815.GA13687@opensource.wolfsonmicro.com>
 <1366214315-29032-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd forgotten to disable /RESET or the regulators. Practically speaking
this code is unlikely to ever be run.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index f713a1d..1d20ce0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -837,6 +837,11 @@ int arizona_dev_exit(struct arizona *arizona)
 	arizona_free_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, arizona);
 	pm_runtime_disable(arizona->dev);
 	arizona_irq_exit(arizona);
+	if (arizona->pdata.reset)
+		gpio_set_value_cansleep(arizona->pdata.reset, 0);
+	regulator_disable(arizona->dcvdd);
+	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
+			       arizona->core_supplies);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(arizona_dev_exit);
-- 
1.7.10.4

