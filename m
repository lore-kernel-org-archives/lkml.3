Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaDWPEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:04:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbaDWPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:01:15 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>,
        <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/13] tty: serial: omap: remove some dead code
Date: Wed, 23 Apr 2014 09:58:34 -0500
Message-ID: <1398265117-11793-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1398265117-11793-1-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
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
index b46aaf3..6654682 100644
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
 
@@ -694,16 +690,6 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
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
@@ -847,9 +833,6 @@ static void serial_omap_uart_qos_work(struct work_struct *work)
 						qos_work);
 
 	pm_qos_update_request(&up->pm_qos_request, up->latency);
-	if (gpio_is_valid(up->DTR_gpio))
-		gpio_set_value_cansleep(up->DTR_gpio,
-					up->DTR_active != up->DTR_inverted);
 }
 
 static void
@@ -1672,28 +1655,6 @@ static int serial_omap_probe(struct platform_device *pdev)
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
1.9.2.459.g68773ac

