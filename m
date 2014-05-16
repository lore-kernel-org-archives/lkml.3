Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992503AbaEPXIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:08:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52428 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbaEPXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:07:19 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/7] clk: qcom: Return error pointers for unimplemented clocks
Date: Fri, 16 May 2014 16:07:14 -0700
Message-Id: <1400281634-9313-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
References: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all clocks are implemented but client drivers can still
request them. Currently we will return a NULL pointer to them if
the clock isn't implemented in software but NULL pointers are
valid clock pointers. Return an error pointer so that driver's
don't proceed without a clock they may actually need.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 86b45fba5f90..9b5a1cfc6b91 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -62,8 +62,10 @@ int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
 	data->clk_num = num_clks;
 
 	for (i = 0; i < num_clks; i++) {
-		if (!rclks[i])
+		if (!rclks[i]) {
+			clks[i] = ERR_PTR(-ENOENT);
 			continue;
+		}
 		clk = devm_clk_register_regmap(dev, rclks[i]);
 		if (IS_ERR(clk))
 			return PTR_ERR(clk);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

