Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaFBI6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:58:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38641 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbaFBI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] mfd: arizona: Disable PM runtime at start of driver removal
Date: Mon,  2 Jun 2014 09:50:39 +0100
Message-Id: <1401699043-16835-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to trigger any PM runtime operations whilst we are tearing
down the driver, as things the suspend and resume callbacks rely on
might already have been destroyed. So disable PM runtime for the device
as the first step arizona_dev_exit.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index cabe8f4..7bdc0f5 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1024,11 +1024,12 @@ EXPORT_SYMBOL_GPL(arizona_dev_init);
 
 int arizona_dev_exit(struct arizona *arizona)
 {
+	pm_runtime_disable(arizona->dev);
+
 	mfd_remove_devices(arizona->dev);
 	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
 	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
 	arizona_free_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, arizona);
-	pm_runtime_disable(arizona->dev);
 	arizona_irq_exit(arizona);
 	if (arizona->pdata.reset)
 		gpio_set_value_cansleep(arizona->pdata.reset, 0);
-- 
1.7.2.5

