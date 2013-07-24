Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3GXSjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:39:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44518 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3GXShg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Subject: [PATCH 2/4] msm_serial: Fix sparse warnings
Date: Wed, 24 Jul 2013 11:37:29 -0700
Message-Id: <1374691051-28544-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/msm_serial.c:302:6: warning: symbol 'msm_set_mctrl' was
not declared. Should it be static?
drivers/tty/serial/msm_serial.c:597:17: warning: incorrect type in argument 2
(different address spaces)
drivers/tty/serial/msm_serial.c:597:17: expected void volatile [noderef] <asn:2>*addr
drivers/tty/serial/msm_serial.c:597:17: got unsigned int *
drivers/tty/serial/msm_serial.c:608:33: warning: incorrect type in argument 1
(different address spaces)
drivers/tty/serial/msm_serial.c:608:33: expected void volatile [noderef] <asn:2>*addr
drivers/tty/serial/msm_serial.c:608:33: got unsigned int *gsbi_base
drivers/tty/serial/msm_serial.c:648:37: warning: incorrect type in assignment
(different address spaces)
drivers/tty/serial/msm_serial.c:648:37: expected unsigned int *gsbi_base
drivers/tty/serial/msm_serial.c:648:37: got void [noderef] <asn:2>*

Mark the ioremapped memory as __iomem and use writel instead of
iowrite because we're not dealing with PCI devices. Also, mark
msm_set_mctrl() static because it isn't used outside this file.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index fa3fc67..cab4105 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -45,7 +45,7 @@ struct msm_port {
 	struct clk		*clk;
 	struct clk		*pclk;
 	unsigned int		imr;
-	unsigned int            *gsbi_base;
+	void __iomem		*gsbi_base;
 	int			is_uartdm;
 	unsigned int		old_snap_state;
 };
@@ -299,7 +299,7 @@ static void msm_reset(struct uart_port *port)
 	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
 }
 
-void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
+static void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	unsigned int mr;
 	mr = msm_read(port, UART_MR1);
@@ -593,12 +593,10 @@ static void msm_release_port(struct uart_port *port)
 	port->membase = NULL;
 
 	if (msm_port->gsbi_base) {
-		iowrite32(GSBI_PROTOCOL_IDLE, msm_port->gsbi_base +
-			  GSBI_CONTROL);
-
-		gsbi_resource = platform_get_resource(pdev,
-							IORESOURCE_MEM, 1);
+		writel_relaxed(GSBI_PROTOCOL_IDLE,
+				msm_port->gsbi_base + GSBI_CONTROL);
 
+		gsbi_resource = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		if (unlikely(!gsbi_resource))
 			return;
 
@@ -670,10 +668,9 @@ static void msm_config_port(struct uart_port *port, int flags)
 		if (ret)
 			return;
 	}
-
 	if (msm_port->is_uartdm)
-		iowrite32(GSBI_PROTOCOL_UART, msm_port->gsbi_base +
-			  GSBI_CONTROL);
+		writel_relaxed(GSBI_PROTOCOL_UART,
+				msm_port->gsbi_base + GSBI_CONTROL);
 }
 
 static int msm_verify_port(struct uart_port *port, struct serial_struct *ser)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

