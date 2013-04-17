Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966230Ab3DQLgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:36:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36900 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966099Ab3DQLfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:35:07 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 3/6] driver: serial: omap: add prepare/complete callback for "no_console_suspend" case
Date: Wed, 17 Apr 2013 17:04:24 +0530
Message-ID: <1366198467-6757-4-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adapt the serial core/driver to take care of the case when "no_console_suspend"
is used in the bootargs. The patch will remove dependency to set od->flags to
"OMAP_DEVICE_NO_IDLE_ON_SUSPEND" in serial.c(non dt case) and omap_device.c(dt case).

Prepare and complete callbacks will ensure that clocks remain active for the console
uart when "no_console_suspend" is used in the bootargs.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/tty/serial/omap-serial.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 08332f3..9ef80cf 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1278,6 +1278,24 @@ static struct uart_driver serial_omap_reg = {
 };
 
 #ifdef CONFIG_PM_SLEEP
+static int serial_omap_prepare(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	if (!console_suspend_enabled && uart_console(&up->port))
+		pm_runtime_disable(dev);
+
+	return 0;
+}
+
+static void serial_omap_complete(struct device *dev)
+{
+	struct uart_omap_port *up = dev_get_drvdata(dev);
+
+	if (!console_suspend_enabled && uart_console(&up->port))
+		pm_runtime_enable(dev);
+}
+
 static int serial_omap_suspend(struct device *dev)
 {
 	struct uart_omap_port *up = dev_get_drvdata(dev);
@@ -1632,6 +1650,8 @@ static const struct dev_pm_ops serial_omap_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
 	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
 				serial_omap_runtime_resume, NULL)
+	.prepare        = serial_omap_prepare,
+	.complete       = serial_omap_complete,
 };
 
 #if defined(CONFIG_OF)
-- 
1.7.1

