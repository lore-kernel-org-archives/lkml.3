Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbaCTTgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:36:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbaCTTcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:03 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 06/11] tty: serial: omap: remove some dead code
Date: Thu, 20 Mar 2014 14:30:02 -0500
Message-ID: <1395343807-21618-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nobody passes a DTR_gpio to this driver, so
this code is not necessary.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d785327..c79d3e6 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -163,10 +163,6 @@ struct uart_omap_port {
 	u8			wakeups_enabled;
 	u32			features;
 
-	int			DTR_gpio;
-	int			DTR_inverted;
-	int			DTR_active;
-
 	struct serial_rs485	rs485;
 	int			rts_gpio;
 
@@ -685,16 +681,6 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	serial_out(up, UART_MCR, up->mcr);
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
-
-	if (gpio_is_valid(up->DTR_gpio) &&
-	    !!(mctrl & TIOCM_DTR) != up->DTR_active) {
-		up->DTR_active = !up->DTR_active;
-		if (gpio_cansleep(up->DTR_gpio))
-			schedule_work(&up->qos_work);
-		else
-			gpio_set_value(up->DTR_gpio,
-				       up->DTR_active != up->DTR_inverted);
-	}
 }
 
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
@@ -838,9 +824,6 @@ static void serial_omap_uart_qos_work(struct work_struct *work)
 						qos_work);
 
 	pm_qos_update_request(&up->pm_qos_request, up->latency);
-	if (gpio_is_valid(up->DTR_gpio))
-		gpio_set_value_cansleep(up->DTR_gpio,
-					up->DTR_active != up->DTR_inverted);
 }
 
 static void
@@ -1655,28 +1638,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
-	    omap_up_info->DTR_present) {
-		ret = devm_gpio_request(&pdev->dev, omap_up_info->DTR_gpio,
-				"omap-serial");
-		if (ret < 0)
-			return ret;
-		ret = gpio_direction_output(omap_up_info->DTR_gpio,
-					    omap_up_info->DTR_inverted);
-		if (ret < 0)
-			return ret;
-	}
-
-	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
-	    omap_up_info->DTR_present) {
-		up->DTR_gpio = omap_up_info->DTR_gpio;
-		up->DTR_inverted = omap_up_info->DTR_inverted;
-	} else {
-		up->DTR_gpio = -EINVAL;
-	}
-
-	up->DTR_active = 0;
-
 	up->dev = &pdev->dev;
 	up->port.dev = &pdev->dev;
 	up->port.type = PORT_OMAP;
-- 
1.9.1.286.g5172cb3

