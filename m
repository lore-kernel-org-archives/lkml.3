Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3JQVLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:11:45 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37402 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762373Ab3JQVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:33 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 01/10] tty: xuartps: Use devm_clk_get()
Date: Thu, 17 Oct 2013 14:08:04 -0700
Message-Id: <1382044093-29905-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the device managed interface for clocks, simplifying error paths.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 7e4150aa69c6..103ba8826d06 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -953,23 +953,23 @@ static int xuartps_probe(struct platform_device *pdev)
 	if (!xuartps_data)
 		return -ENOMEM;
 
-	xuartps_data->aperclk = clk_get(&pdev->dev, "aper_clk");
+	xuartps_data->aperclk = devm_clk_get(&pdev->dev, "aper_clk");
 	if (IS_ERR(xuartps_data->aperclk)) {
 		dev_err(&pdev->dev, "aper_clk clock not found.\n");
 		rc = PTR_ERR(xuartps_data->aperclk);
 		goto err_out_free;
 	}
-	xuartps_data->refclk = clk_get(&pdev->dev, "ref_clk");
+	xuartps_data->refclk = devm_clk_get(&pdev->dev, "ref_clk");
 	if (IS_ERR(xuartps_data->refclk)) {
 		dev_err(&pdev->dev, "ref_clk clock not found.\n");
 		rc = PTR_ERR(xuartps_data->refclk);
-		goto err_out_clk_put_aper;
+		goto err_out_free;
 	}
 
 	rc = clk_prepare_enable(xuartps_data->aperclk);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to enable APER clock.\n");
-		goto err_out_clk_put;
+		goto err_out_free;
 	}
 	rc = clk_prepare_enable(xuartps_data->refclk);
 	if (rc) {
@@ -1020,10 +1020,6 @@ err_out_clk_disable:
 	clk_disable_unprepare(xuartps_data->refclk);
 err_out_clk_dis_aper:
 	clk_disable_unprepare(xuartps_data->aperclk);
-err_out_clk_put:
-	clk_put(xuartps_data->refclk);
-err_out_clk_put_aper:
-	clk_put(xuartps_data->aperclk);
 err_out_free:
 	kfree(xuartps_data);
 
@@ -1047,8 +1043,6 @@ static int xuartps_remove(struct platform_device *pdev)
 	port->mapbase = 0;
 	clk_disable_unprepare(xuartps_data->refclk);
 	clk_disable_unprepare(xuartps_data->aperclk);
-	clk_put(xuartps_data->refclk);
-	clk_put(xuartps_data->aperclk);
 	kfree(xuartps_data);
 	return rc;
 }
-- 
1.8.4.1

