Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936884Ab3DJOAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:00:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:55949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936145Ab3DJN6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281423"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 5/9] serial: 8250_dw: Enable runtime PM
Date: Wed, 10 Apr 2013 16:58:28 +0300
Message-Id: <1365602312-25436-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows ACPI to put the device to D3 when it's not used.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   61 +++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 3dedd24..d6aea85 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include "8250.h"
 
@@ -115,6 +116,18 @@ static int dw8250_handle_irq(struct uart_port *p)
 	return 0;
 }
 
+static void
+dw8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
+{
+	if (!state)
+		pm_runtime_get_sync(port->dev);
+
+	serial8250_do_pm(port, state, old);
+
+	if (state)
+		pm_runtime_put_sync_suspend(port->dev);
+}
+
 static int dw8250_probe_of(struct uart_port *p)
 {
 	struct device_node	*np = p->dev->of_node;
@@ -293,6 +306,7 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.mapbase = regs->start;
 	uart.port.irq = irq->start;
 	uart.port.handle_irq = dw8250_handle_irq;
+	uart.port.pm = dw8250_do_pm;
 	uart.port.type = PORT_8250;
 	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 	uart.port.dev = &pdev->dev;
@@ -336,6 +350,9 @@ static int dw8250_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 }
 
@@ -343,37 +360,64 @@ static int dw8250_remove(struct platform_device *pdev)
 {
 	struct dw8250_data *data = platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	serial8250_unregister_port(data->line);
 
 	if (!IS_ERR(data->clk))
 		clk_disable_unprepare(data->clk);
 
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	return 0;
 }
 
 #ifdef CONFIG_PM
-static int dw8250_suspend(struct platform_device *pdev, pm_message_t state)
+static int dw8250_suspend(struct device *dev)
 {
-	struct dw8250_data *data = platform_get_drvdata(pdev);
+	struct dw8250_data *data = dev_get_drvdata(dev);
 
 	serial8250_suspend_port(data->line);
 
 	return 0;
 }
 
-static int dw8250_resume(struct platform_device *pdev)
+static int dw8250_resume(struct device *dev)
 {
-	struct dw8250_data *data = platform_get_drvdata(pdev);
+	struct dw8250_data *data = dev_get_drvdata(dev);
 
 	serial8250_resume_port(data->line);
 
 	return 0;
 }
-#else
-#define dw8250_suspend NULL
-#define dw8250_resume NULL
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+static int dw8250_runtime_suspend(struct device *dev)
+{
+	struct dw8250_data *data = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static int dw8250_runtime_resume(struct device *dev)
+{
+	struct dw8250_data *data = dev_get_drvdata(dev);
+
+	clk_prepare_enable(data->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops dw8250_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dw8250_suspend, dw8250_resume)
+	SET_RUNTIME_PM_OPS(dw8250_runtime_suspend, dw8250_runtime_resume, NULL)
+};
+
 static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
 	{ /* Sentinel */ }
@@ -391,13 +435,12 @@ static struct platform_driver dw8250_platform_driver = {
 	.driver = {
 		.name		= "dw-apb-uart",
 		.owner		= THIS_MODULE,
+		.pm		= &dw8250_pm_ops,
 		.of_match_table	= dw8250_of_match,
 		.acpi_match_table = ACPI_PTR(dw8250_acpi_match),
 	},
 	.probe			= dw8250_probe,
 	.remove			= dw8250_remove,
-	.suspend		= dw8250_suspend,
-	.resume			= dw8250_resume,
 };
 
 module_platform_driver(dw8250_platform_driver);
-- 
1.7.10.4

