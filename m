Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3DZMo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:44:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37070 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3DZMnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:43:11 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv4 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
Date: Fri, 26 Apr 2013 18:12:45 +0530
Message-ID: <1366980168-30566-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
References: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver manages "no_console_suspend" by preventing runtime PM
during the suspend path, which forces the console UART to stay awake.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 30d4f7a..eddff3c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -161,6 +161,7 @@ struct uart_omap_port {
 	u32			calc_latency;
 	struct work_struct	qos_work;
 	struct pinctrl		*pins;
+	bool			is_suspending;
 };
 
 #define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
@@ -1312,6 +1313,22 @@ static struct uart_driver serial_omap_reg = {
 };
 
 #ifdef CONFIG_PM_SLEEP
+static int serial_omap_prepare(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	up->is_suspending = true;
+
+	return 0;
+}
+
+static void serial_omap_complete(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	up->is_suspending = false;
+}
+
 static int serial_omap_suspend(struct device *dev)
 {
 	struct uart_omap_port *up = dev_get_drvdata(dev);
@@ -1330,7 +1347,10 @@ static int serial_omap_resume(struct device *dev)
 
 	return 0;
 }
-#endif
+#else
+#define serial_omap_prepare NULL
+#define serial_omap_prepare NULL
+#endif /* CONFIG_PM_SLEEP */
 
 static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 {
@@ -1616,6 +1636,10 @@ static int serial_omap_runtime_suspend(struct device *dev)
 	struct uart_omap_port *up = dev_get_drvdata(dev);
 	struct omap_uart_port_info *pdata = dev->platform_data;
 
+	if (up->is_suspending && !console_suspend_enabled
+			&& uart_console(&up->port))
+		return -EBUSY;
+
 	if (!up)
 		return -EINVAL;
 
@@ -1666,6 +1690,8 @@ static const struct dev_pm_ops serial_omap_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
 	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
 				serial_omap_runtime_resume, NULL)
+	.prepare        = serial_omap_prepare,
+	.complete       = serial_omap_complete,
 };
 
 #if defined(CONFIG_OF)
-- 
1.7.1

