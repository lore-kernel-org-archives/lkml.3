Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbbATM6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:58:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:9183 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbbATM6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:58:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,433,1418112000"; 
   d="scan'208";a="639825525"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [PATCH] dmaengine: dw: support for clockless platforms
Date: Tue, 20 Jan 2015 14:57:57 +0200
Message-Id: <1421758677-183443-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting clock in the platform driver, leaving
chip->clk value as NULL if -ENOENT is returned, and
continue. With other errors returning failure. It makes the
driver usable on platforms that do not provide the clock.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/dma/dw/platform.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index 32ea1ac..b183bc0 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -180,8 +180,12 @@ static int dw_probe(struct platform_device *pdev)
 	chip->dev = dev;
 
 	chip->clk = devm_clk_get(chip->dev, "hclk");
-	if (IS_ERR(chip->clk))
-		return PTR_ERR(chip->clk);
+	if (IS_ERR(chip->clk)) {
+		if (PTR_ERR(chip->clk) == -ENOENT)
+			chip->clk = NULL;
+		else
+			return PTR_ERR(chip->clk);
+	}
 	err = clk_prepare_enable(chip->clk);
 	if (err)
 		return err;
-- 
2.1.4

