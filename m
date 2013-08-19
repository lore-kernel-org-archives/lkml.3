Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3HSVk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:40:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34896 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3HSVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:40:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 3/4] msm_serial: Add support for non-GSBI UARTDM devices
Date: Mon, 19 Aug 2013 14:39:56 -0700
Message-Id: <1376948397-6882-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
References: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all UARTDM hardware is part of a GSBI complex. Add support
for these devices and fix a bug where we assumed uartdm meant the
hardware was part of a GSBI complex.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 7631313..f42c805 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -670,7 +670,7 @@ static void msm_config_port(struct uart_port *port, int flags)
 		if (ret)
 			return;
 	}
-	if (msm_port->is_uartdm)
+	if (msm_port->gsbi_base)
 		writel_relaxed(GSBI_PROTOCOL_UART,
 				msm_port->gsbi_base + GSBI_CONTROL);
 }
@@ -860,6 +860,11 @@ static struct uart_driver msm_uart_driver = {
 
 static atomic_t msm_uart_next_id = ATOMIC_INIT(0);
 
+static const struct of_device_id msm_uartdm_table[] = {
+	{ .compatible = "qcom,msm-uartdm" },
+	{ }
+};
+
 static int __init msm_serial_probe(struct platform_device *pdev)
 {
 	struct msm_port *msm_port;
@@ -879,7 +884,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	port->dev = &pdev->dev;
 	msm_port = UART_TO_MSM(port);
 
-	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
+	if (of_match_device(msm_uartdm_table, &pdev->dev))
 		msm_port->is_uartdm = 1;
 	else
 		msm_port->is_uartdm = 0;
@@ -926,6 +931,7 @@ static int msm_serial_remove(struct platform_device *pdev)
 
 static struct of_device_id msm_match_table[] = {
 	{ .compatible = "qcom,msm-uart" },
+	{ .compatible = "qcom,msm-uartdm" },
 	{}
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

