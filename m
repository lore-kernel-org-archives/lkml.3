Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFLTfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:35:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45723 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFLTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:45 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v2 2/3] spi: qup: Fix order of spi_register_master
Date: Thu, 12 Jun 2014 14:34:11 -0500
Message-Id: <1402601652-24641-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the devm_spi_register_master below the initialization of the
runtime_pm.  If done in the wrong order, the spi_register_master fails if any
probed slave devices issue SPI transactions.

Signed-off-by: Andy Gross <agross@codeaurora.org>
Acked-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/spi/spi-qup.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 3938c62..c08da38 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -619,16 +619,19 @@ static int spi_qup_probe(struct platform_device *pdev)
 	if (ret)
 		goto error;
 
-	ret = devm_spi_register_master(dev, master);
-	if (ret)
-		goto error;
-
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
+
+	ret = devm_spi_register_master(dev, master);
+	if (ret)
+		goto disable_pm;
+
 	return 0;
 
+disable_pm:
+	pm_runtime_disable(&pdev->dev);
 error:
 	clk_disable_unprepare(cclk);
 	clk_disable_unprepare(iclk);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

