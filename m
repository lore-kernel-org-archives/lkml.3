Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3DVNog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:44:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35006 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab3DVNoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:44:19 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv2 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
Date: Mon, 22 Apr 2013 19:13:54 +0530
Message-ID: <1366638237-6880-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver manages "no_console_suspend" by preventing runtime PM
during the suspend path, which forces the console UART to stay awake.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/tty/serial/omap-serial.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 08332f3..640b14e 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1582,7 +1582,7 @@ static int serial_omap_runtime_suspend(struct device *dev)
 	struct uart_omap_port *up = dev_get_drvdata(dev);
 	struct omap_uart_port_info *pdata = dev->platform_data;
 
-	if (!up)
+	if (!up || (!console_suspend_enabled && uart_console(&up->port)))
 		return -EINVAL;
 
 	if (!pdata)
@@ -1614,6 +1614,9 @@ static int serial_omap_runtime_resume(struct device *dev)
 
 	int loss_cnt = serial_omap_get_context_loss_count(up);
 
+	if (!console_suspend_enabled && uart_console(&up->port))
+		return -EINVAL;
+
 	if (loss_cnt < 0) {
 		dev_err(dev, "serial_omap_get_context_loss_count failed : %d\n",
 			loss_cnt);
-- 
1.7.1

