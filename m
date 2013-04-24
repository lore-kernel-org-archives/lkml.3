Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3DXNQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:16:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43107 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab3DXNQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:16:30 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv3 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
Date: Wed, 24 Apr 2013 18:45:50 +0530
Message-ID: <1366809353-19435-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366809353-19435-1-git-send-email-sourav.poddar@ti.com>
References: <1366809353-19435-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver manages "no_console_suspend" by preventing runtime PM
during the suspend path, which forces the console UART to stay awake.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/tty/serial/omap-serial.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 08332f3..468e7ad 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -161,6 +161,7 @@ struct uart_omap_port {
 	u32			calc_latency;
 	struct work_struct	qos_work;
 	struct pinctrl		*pins;
+	bool			is_suspending;
 };
 
 #define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
@@ -1278,6 +1279,24 @@ static struct uart_driver serial_omap_reg = {
 };
 
 #ifdef CONFIG_PM_SLEEP
+static int serial_omap_prepare(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	if (!console_suspend_enabled && uart_console(&up->port))
+		up->is_suspending = true;
+
+	return 0;
+}
+
+static void serial_omap_complete(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	if (!console_suspend_enabled && uart_console(&up->port))
+		up->is_suspending = false;
+}
+
 static int serial_omap_suspend(struct device *dev)
 {
 	struct uart_omap_port *up = dev_get_drvdata(dev);
@@ -1296,7 +1315,10 @@ static int serial_omap_resume(struct device *dev)
 
 	return 0;
 }
-#endif
+#else
+#define serial_omap_prepare NULL
+#define serial_omap_prepare NULL
+#endif /* CONFIG_PM_SLEEP */
 
 static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 {
@@ -1582,6 +1604,9 @@ static int serial_omap_runtime_suspend(struct device *dev)
 	struct uart_omap_port *up = dev_get_drvdata(dev);
 	struct omap_uart_port_info *pdata = dev->platform_data;
 
+	if (up->is_suspending)
+		return -EBUSY;
+
 	if (!up)
 		return -EINVAL;
 
@@ -1632,6 +1657,8 @@ static const struct dev_pm_ops serial_omap_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
 	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
 				serial_omap_runtime_resume, NULL)
+	.prepare        = serial_omap_prepare,
+	.complete       = serial_omap_complete,
 };
 
 #if defined(CONFIG_OF)
-- 
1.7.1

