Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3JUXlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:41:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42213 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUXlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:41:17 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 3/3] tty: xuartps: Fix build error when COMMON_CLK is not set
Date: Mon, 21 Oct 2013 16:41:01 -0700
Message-Id: <1382398861-21542-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock notifiers are only available when CONFIG_COMMON_CLK is enabled.
Hence all notifier related code has to be protected by corresponsing
ifdefs.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Alternatively this could be fixed by adding a dependency on COMMON_CLK
in Kconfig. That would keep the code cleaner, but limit this driver to
platforms using the CCF.
---
 drivers/tty/serial/xilinx_uartps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index ca4a2f1fbca9..e46e9f3f19b9 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -411,6 +411,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
 	return calc_baud;
 }
 
+#ifdef CONFIG_COMMON_CLK
 /**
  * xuartps_clk_notitifer_cb - Clock notifier callback
  * @nb:		Notifier block
@@ -504,6 +505,7 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 }
+#endif
 
 /*----------------------Uart Operations---------------------------*/
 
@@ -1380,11 +1382,13 @@ static int xuartps_probe(struct platform_device *pdev)
 		goto err_out_clk_disable;
 	}
 
+#ifdef CONFIG_COMMON_CLK
 	xuartps_data->clk_rate_change_nb.notifier_call =
 			xuartps_clk_notifier_cb;
 	if (clk_notifier_register(xuartps_data->refclk,
 				&xuartps_data->clk_rate_change_nb))
 		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
+#endif
 
 	/* Initialize the port structure */
 	port = xuartps_get_port();
@@ -1415,8 +1419,10 @@ static int xuartps_probe(struct platform_device *pdev)
 	}
 
 err_out_notif_unreg:
+#ifdef CONFIG_COMMON_CLK
 	clk_notifier_unregister(xuartps_data->refclk,
 			&xuartps_data->clk_rate_change_nb);
+#endif
 err_out_clk_disable:
 	clk_disable_unprepare(xuartps_data->refclk);
 err_out_clk_dis_aper:
@@ -1438,8 +1444,10 @@ static int xuartps_remove(struct platform_device *pdev)
 	int rc;
 
 	/* Remove the xuartps port from the serial core */
+#ifdef CONFIG_COMMON_CLK
 	clk_notifier_unregister(xuartps_data->refclk,
 			&xuartps_data->clk_rate_change_nb);
+#endif
 	rc = uart_remove_one_port(&xuartps_uart_driver, port);
 	port->mapbase = 0;
 	clk_disable_unprepare(xuartps_data->refclk);
-- 
1.8.4.1

