Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3AKGVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:21:01 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:55425 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3AKGU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:20:59 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/4] serial/arc-uart: split probe from probe_earlyprintk
Date: Fri, 11 Jan 2013 11:50:21 +0530
Message-ID: <1357885223-19243-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for devicetree based probing, where earlyprintk
won't have access to DT serial aliases which the normal probe would
absolutely rely on.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/arc_uart.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 8089dc3..9de26ba 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -651,7 +651,7 @@ static struct __initdata console arc_early_serial_console = {
 	.index = -1
 };
 
-static int arc_serial_probe_earlyprintk(struct platform_device *pdev)
+static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
 {
 	int dev_id = pdev->id < 0 ? 0 : pdev->id;
 	int rc;
@@ -667,20 +667,12 @@ static int arc_serial_probe_earlyprintk(struct platform_device *pdev)
 	register_console(&arc_early_serial_console);
 	return 0;
 }
-#else
-static int arc_serial_probe_earlyprintk(struct platform_device *pdev)
-{
-	return -ENODEV;
-}
 #endif	/* CONFIG_SERIAL_ARC_CONSOLE */
 
 static int arc_serial_probe(struct platform_device *pdev)
 {
 	int rc, dev_id;
 
-	if (is_early_platform_device(pdev))
-		return arc_serial_probe_earlyprintk(pdev);
-
 	dev_id = pdev->id < 0 ? 0 : pdev->id;
 	rc = arc_uart_init_one(pdev, dev_id);
 	if (rc)
@@ -706,6 +698,15 @@ static struct platform_driver arc_platform_driver = {
 };
 
 #ifdef CONFIG_SERIAL_ARC_CONSOLE
+
+static struct platform_driver early_arc_platform_driver = {
+	.probe = arc_serial_probe_earlyprintk,
+	.remove = arc_serial_remove,
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	 },
+};
 /*
  * Register an early platform driver of "earlyprintk" class.
  * ARCH platform code installs the driver and probes the early devices
@@ -713,7 +714,7 @@ static struct platform_driver arc_platform_driver = {
  * or it could be done independently, for all "earlyprintk" class drivers.
  * [see arch/arc/plat-arcfpga/platform.c]
  */
-early_platform_init("earlyprintk", &arc_platform_driver);
+early_platform_init("earlyprintk", &early_arc_platform_driver);
 
 #endif  /* CONFIG_SERIAL_ARC_CONSOLE */
 
-- 
1.7.4.1

