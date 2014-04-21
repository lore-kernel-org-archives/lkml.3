Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaDUFc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:32:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44436 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaDUFbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:34 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 4/4] tty: serial: msm: Remove direct access to GSBI
Date: Mon, 21 Apr 2014 00:30:44 -0500
Message-Id: <1398058244-14099-5-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes direct access of the GSBI registers.  GSBI configuration
should be done through the GSBI driver directly.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c |   48 ++-------------------------------------
 drivers/tty/serial/msm_serial.h |    5 ----
 2 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index b5d779c..8901114 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -45,7 +45,6 @@ struct msm_port {
 	struct clk		*clk;
 	struct clk		*pclk;
 	unsigned int		imr;
-	void __iomem		*gsbi_base;
 	int			is_uartdm;
 	unsigned int		old_snap_state;
 };
@@ -586,9 +585,7 @@ static const char *msm_type(struct uart_port *port)
 static void msm_release_port(struct uart_port *port)
 {
 	struct platform_device *pdev = to_platform_device(port->dev);
-	struct msm_port *msm_port = UART_TO_MSM(port);
 	struct resource *uart_resource;
-	struct resource *gsbi_resource;
 	resource_size_t size;
 
 	uart_resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -599,28 +596,12 @@ static void msm_release_port(struct uart_port *port)
 	release_mem_region(port->mapbase, size);
 	iounmap(port->membase);
 	port->membase = NULL;
-
-	if (msm_port->gsbi_base) {
-		writel_relaxed(GSBI_PROTOCOL_IDLE,
-				msm_port->gsbi_base + GSBI_CONTROL);
-
-		gsbi_resource = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (unlikely(!gsbi_resource))
-			return;
-
-		size = resource_size(gsbi_resource);
-		release_mem_region(gsbi_resource->start, size);
-		iounmap(msm_port->gsbi_base);
-		msm_port->gsbi_base = NULL;
-	}
 }
 
 static int msm_request_port(struct uart_port *port)
 {
-	struct msm_port *msm_port = UART_TO_MSM(port);
 	struct platform_device *pdev = to_platform_device(port->dev);
 	struct resource *uart_resource;
-	struct resource *gsbi_resource;
 	resource_size_t size;
 	int ret;
 
@@ -639,30 +620,8 @@ static int msm_request_port(struct uart_port *port)
 		goto fail_release_port;
 	}
 
-	gsbi_resource = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	/* Is this a GSBI-based port? */
-	if (gsbi_resource) {
-		size = resource_size(gsbi_resource);
-
-		if (!request_mem_region(gsbi_resource->start, size,
-						 "msm_serial")) {
-			ret = -EBUSY;
-			goto fail_release_port_membase;
-		}
-
-		msm_port->gsbi_base = ioremap(gsbi_resource->start, size);
-		if (!msm_port->gsbi_base) {
-			ret = -EBUSY;
-			goto fail_release_gsbi;
-		}
-	}
-
 	return 0;
 
-fail_release_gsbi:
-	release_mem_region(gsbi_resource->start, size);
-fail_release_port_membase:
-	iounmap(port->membase);
 fail_release_port:
 	release_mem_region(port->mapbase, size);
 	return ret;
@@ -670,7 +629,6 @@ fail_release_port:
 
 static void msm_config_port(struct uart_port *port, int flags)
 {
-	struct msm_port *msm_port = UART_TO_MSM(port);
 	int ret;
 	if (flags & UART_CONFIG_TYPE) {
 		port->type = PORT_MSM;
@@ -678,9 +636,6 @@ static void msm_config_port(struct uart_port *port, int flags)
 		if (ret)
 			return;
 	}
-	if (msm_port->gsbi_base)
-		writel_relaxed(GSBI_PROTOCOL_UART,
-				msm_port->gsbi_base + GSBI_CONTROL);
 }
 
 static int msm_verify_port(struct uart_port *port, struct serial_struct *ser)
@@ -976,6 +931,7 @@ static struct of_device_id msm_match_table[] = {
 
 static struct platform_driver msm_platform_driver = {
 	.remove = msm_serial_remove,
+	.probe = msm_serial_probe,
 	.driver = {
 		.name = "msm_serial",
 		.owner = THIS_MODULE,
@@ -991,7 +947,7 @@ static int __init msm_serial_init(void)
 	if (unlikely(ret))
 		return ret;
 
-	ret = platform_driver_probe(&msm_platform_driver, msm_serial_probe);
+	ret = platform_driver_register(&msm_platform_driver);
 	if (unlikely(ret))
 		uart_unregister_driver(&msm_uart_driver);
 
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index 469fda5..a77cc76 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -108,11 +108,6 @@
 #define UART_ISR		0x0014
 #define UART_ISR_TX_READY	(1 << 7)
 
-#define GSBI_CONTROL		0x0
-#define GSBI_PROTOCOL_CODE	0x30
-#define GSBI_PROTOCOL_UART	0x40
-#define GSBI_PROTOCOL_IDLE	0x0
-
 #define UARTDM_DMRX		0x34
 #define UARTDM_NCF_TX		0x40
 #define UARTDM_RX_TOTAL_SNAP	0x38
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

