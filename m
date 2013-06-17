Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3FQRpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:45:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41496 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3FQRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:43:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH/RESEND 02/12] msm_serial: Use devm_clk_get() and properly return errors
Date: Mon, 17 Jun 2013 10:43:09 -0700
Message-Id: <1371490999-15501-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clocks are not clk_put() in this driver's error paths during
probe. The code that checks for clock errors also fails to
properly return the error code from the pclk member if it turns
out to be the failing clock, leading to potentially confusing
error values if the clk member is not an error pointer. Fix these
problems with devm_clk_get() and proper error checking.

Removing the clk_put() in msm_serial_remove() also points out
that msm_port is unused. Furthermore, msm_port is the wrong type
and so the clk_put() would be using the wrong pointer. Replace it
with the proper type and call uart_remove_one_port() to do the
proper cleanup.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 0149603..2c6cfb3 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -884,19 +884,22 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 		msm_port->is_uartdm = 0;
 
 	if (msm_port->is_uartdm) {
-		msm_port->clk = clk_get(&pdev->dev, "gsbi_uart_clk");
-		msm_port->pclk = clk_get(&pdev->dev, "gsbi_pclk");
+		msm_port->clk = devm_clk_get(&pdev->dev, "gsbi_uart_clk");
+		msm_port->pclk = devm_clk_get(&pdev->dev, "gsbi_pclk");
 	} else {
-		msm_port->clk = clk_get(&pdev->dev, "uart_clk");
+		msm_port->clk = devm_clk_get(&pdev->dev, "uart_clk");
 		msm_port->pclk = ERR_PTR(-ENOENT);
 	}
 
-	if (unlikely(IS_ERR(msm_port->clk) || (IS_ERR(msm_port->pclk) &&
-					       msm_port->is_uartdm)))
-			return PTR_ERR(msm_port->clk);
+	if (IS_ERR(msm_port->clk))
+		return PTR_ERR(msm_port->clk);
+
+	if (msm_port->is_uartdm) {
+		if (IS_ERR(msm_port->pclk))
+			return PTR_ERR(msm_port->pclk);
 
-	if (msm_port->is_uartdm)
 		clk_set_rate(msm_port->clk, 1843200);
+	}
 
 	port->uartclk = clk_get_rate(msm_port->clk);
 	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
@@ -919,9 +922,9 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 
 static int msm_serial_remove(struct platform_device *pdev)
 {
-	struct msm_port *msm_port = platform_get_drvdata(pdev);
+	struct uart_port *port = platform_get_drvdata(pdev);
 
-	clk_put(msm_port->clk);
+	uart_remove_one_port(&msm_uart_driver, port);
 
 	return 0;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

