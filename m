Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaJWAdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:33:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54225 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbaJWAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:33:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [PATCH] tty: serial: msm_serial: Use DT aliases
Date: Wed, 22 Oct 2014 17:33:01 -0700
Message-Id: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rely on probe order of this driver to determine the line number for
the uart port. This makes it impossible to know the line number
when these devices are populated via DT. Use the DT alias
mechanism to assign the line based on the aliases node.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 0da0b5474e98..4aba62d00a3f 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1005,17 +1005,22 @@ static int msm_serial_probe(struct platform_device *pdev)
 	struct resource *resource;
 	struct uart_port *port;
 	const struct of_device_id *id;
-	int irq;
+	int irq, line;
 
 	if (pdev->id == -1)
 		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
 
-	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
+	if (pdev->dev.of_node)
+		line = of_alias_get_id(pdev->dev.of_node, "serial");
+	else
+		line = pdev->id;
+
+	if (unlikely(line < 0 || line >= UART_NR))
 		return -ENXIO;
 
-	printk(KERN_INFO "msm_serial: detected port #%d\n", pdev->id);
+	printk(KERN_INFO "msm_serial: detected port #%d\n", line);
 
-	port = get_port_from_line(pdev->id);
+	port = get_port_from_line(line);
 	port->dev = &pdev->dev;
 	msm_port = UART_TO_MSM(port);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

