Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FDT2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:28:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52411 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3FDTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:25:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/12] msm_sdcc: Convert to clk_prepare/unprepare
Date: Tue,  4 Jun 2013 12:25:30 -0700
Message-Id: <1370373938-32417-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to clk_prepare and unprepare so that MSM can migrate to
the common clock framework.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 0ee4a57..b900de4 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1268,10 +1268,18 @@ msmsdcc_probe(struct platform_device *pdev)
 		goto clk_put;
 	}
 
+	ret = clk_prepare(host->pclk);
+	if (ret)
+		goto clk_put;
+
+	ret = clk_prepare(host->clk);
+	if (ret)
+		goto clk_unprepare_p;
+
 	/* Enable clocks */
 	ret = msmsdcc_enable_clocks(host);
 	if (ret)
-		goto clk_put;
+		goto clk_unprepare;
 
 	host->pclk_rate = clk_get_rate(host->pclk);
 	host->clk_rate = clk_get_rate(host->clk);
@@ -1386,6 +1394,10 @@ msmsdcc_probe(struct platform_device *pdev)
 		free_irq(host->stat_irq, host);
  clk_disable:
 	msmsdcc_disable_clocks(host, 0);
+ clk_unprepare:
+	clk_unprepare(host->clk);
+ clk_unprepare_p:
+	clk_unprepare(host->pclk);
  clk_put:
 	clk_put(host->clk);
  pclk_put:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

