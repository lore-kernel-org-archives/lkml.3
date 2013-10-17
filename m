Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855Ab3JQVIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:08:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58058 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3JQVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:40 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 02/10] tty: xuartps: Use devm_kzalloc
Date: Thu, 17 Oct 2013 14:08:05 -0700
Message-Id: <1382044093-29905-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the device managed interface for memory allocation, simplifying
error paths.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 103ba8826d06..8c0745951605 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -949,27 +949,26 @@ static int xuartps_probe(struct platform_device *pdev)
 	struct resource *res, *res2;
 	struct xuartps *xuartps_data;
 
-	xuartps_data = kzalloc(sizeof(*xuartps_data), GFP_KERNEL);
+	xuartps_data = devm_kzalloc(&pdev->dev, sizeof(*xuartps_data),
+			GFP_KERNEL);
 	if (!xuartps_data)
 		return -ENOMEM;
 
 	xuartps_data->aperclk = devm_clk_get(&pdev->dev, "aper_clk");
 	if (IS_ERR(xuartps_data->aperclk)) {
 		dev_err(&pdev->dev, "aper_clk clock not found.\n");
-		rc = PTR_ERR(xuartps_data->aperclk);
-		goto err_out_free;
+		return PTR_ERR(xuartps_data->aperclk);
 	}
 	xuartps_data->refclk = devm_clk_get(&pdev->dev, "ref_clk");
 	if (IS_ERR(xuartps_data->refclk)) {
 		dev_err(&pdev->dev, "ref_clk clock not found.\n");
-		rc = PTR_ERR(xuartps_data->refclk);
-		goto err_out_free;
+		return PTR_ERR(xuartps_data->refclk);
 	}
 
 	rc = clk_prepare_enable(xuartps_data->aperclk);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to enable APER clock.\n");
-		goto err_out_free;
+		return rc;
 	}
 	rc = clk_prepare_enable(xuartps_data->refclk);
 	if (rc) {
@@ -1020,8 +1019,6 @@ err_out_clk_disable:
 	clk_disable_unprepare(xuartps_data->refclk);
 err_out_clk_dis_aper:
 	clk_disable_unprepare(xuartps_data->aperclk);
-err_out_free:
-	kfree(xuartps_data);
 
 	return rc;
 }
@@ -1043,7 +1040,6 @@ static int xuartps_remove(struct platform_device *pdev)
 	port->mapbase = 0;
 	clk_disable_unprepare(xuartps_data->refclk);
 	clk_disable_unprepare(xuartps_data->aperclk);
-	kfree(xuartps_data);
 	return rc;
 }
 
-- 
1.8.4.1

