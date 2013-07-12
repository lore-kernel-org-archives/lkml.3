Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3GLL5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:57:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52747 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3GLL5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:57:06 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 2/2] serial: omap: fix wrong context restoration on init
Date: Fri, 12 Jul 2013 14:55:42 +0300
Message-ID: <1373630142-21765-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373630142-21765-1-git-send-email-grygorii.strashko@ti.com>
References: <1373630142-21765-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit a630fbf "serial: omap: Fix device tree based PM runtime"
the OMAP serial driver will always try to restore its context in
serial_omap_runtime_resume(). But the problem is that during driver
initialization the UART context is not ready yet and, as result, first
call to pm_runtime_get*() will cause UART register overwriting by all
zeros. This causes Kernel boot hang in case if "earlyprintk" feature is
enabled at least [1].

Unfortunately, there is no exact place in driver now where we can
determine that UART context is ready - most of registers configured in
serial_omap_set_termios(), but some of them in other places.
More over, even if PM runtime will be disabled (blocked) during OMAP
serial driver probe() execution [2],[3] it will fix only console UART,
but context of other UARTs will be overwriting by all zeros during first
access to the corresponding UART.

To fix this issue:
- introduce additional "initialized" flag and update PM runtime callback
to do nothing if its not set. Set "initialized" at the end of probe().
- read current UART registers configuration in probe and use it by
default.

[1] http://www.spinics.net/lists/arm-kernel/msg256828.html
[2] http://www.spinics.net/lists/arm-kernel/msg258062.html
[3] http://www.spinics.net/lists/arm-kernel/msg258040.html

CC: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Kevin Hilman <khilman@linaro.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
tested on OMAP4 SDP with and without earlyprintk enabled.
 drivers/tty/serial/omap-serial.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index f39bf0c..e1e9667 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -162,6 +162,7 @@ struct uart_omap_port {
 	struct work_struct	qos_work;
 	struct pinctrl		*pins;
 	bool			is_suspending;
+	bool			initialized;
 };
 
 #define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
@@ -1395,6 +1396,19 @@ static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 	return omap_up_info;
 }
 
+static void serial_omap_save_context_def(struct uart_omap_port *up)
+{
+	up->dll = serial_in(up, UART_DLL);
+	up->dlh = serial_in(up, UART_DLM);
+	up->ier = serial_in(up, UART_IER);
+	up->fcr = serial_in(up, UART_FCR);
+	up->mcr = serial_in(up, UART_MCR);
+	up->scr = serial_in(up, UART_OMAP_SCR);
+	up->efr = serial_in(up, UART_EFR);
+	up->lcr = serial_in(up, UART_LCR);
+	up->mdr1 = serial_in(up, UART_OMAP_MDR1);
+}
+
 static int serial_omap_probe(struct platform_device *pdev)
 {
 	struct uart_omap_port	*up;
@@ -1518,10 +1532,14 @@ static int serial_omap_probe(struct platform_device *pdev)
 	ui[up->port.line] = up;
 	serial_omap_add_console_port(up);
 
+	serial_omap_save_context_def(up);
+
 	ret = uart_add_one_port(&serial_omap_reg, &up->port);
 	if (ret != 0)
 		goto err_add_port;
 
+	up->initialized = true;
+
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
 	return 0;
@@ -1619,6 +1637,9 @@ static int serial_omap_runtime_suspend(struct device *dev)
 	if (!up)
 		return -EINVAL;
 
+	if (!up->initialized)
+		return 0;
+
 	/*
 	* When using 'no_console_suspend', the console UART must not be
 	* suspended. Since driver suspend is managed by runtime suspend,
@@ -1652,8 +1673,12 @@ static int serial_omap_runtime_suspend(struct device *dev)
 static int serial_omap_runtime_resume(struct device *dev)
 {
 	struct uart_omap_port *up = dev_get_drvdata(dev);
+	int loss_cnt;
+
+	if (!up->initialized)
+		return 0;
 
-	int loss_cnt = serial_omap_get_context_loss_count(up);
+	loss_cnt = serial_omap_get_context_loss_count(up);
 
 	if (loss_cnt < 0) {
 		dev_dbg(dev, "serial_omap_get_context_loss_count failed : %d\n",
-- 
1.7.9.5

