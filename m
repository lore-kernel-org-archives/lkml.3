Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966182Ab3DQLfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:35:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51440 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966123Ab3DQLfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:35:04 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCH 6/6] arm: mach-omap2: Remove "no_console_suspend"
Date: Wed, 17 Apr 2013 17:04:27 +0530
Message-ID: <1366198467-6757-7-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the omap serial driver is now adapted to handle the
case where you dont need to cut the clock on suspend while
using "no_console_suspend" in the bootargs.

We can get rid of the previous implementation of setting the od->flags to
"OMAP_DEVICE_NO_IDLE_ON_SUSPEND" from platform
and omap_device files.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |    3 ---
 arch/arm/mach-omap2/serial.c      |    7 -------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index d6dce8f..c226946 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -170,9 +170,6 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 			r->name = dev_name(&pdev->dev);
 	}
 
-	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
-		omap_device_disable_idle_on_suspend(pdev);
-
 	pdev->dev.pm_domain = &omap_device_pm_domain;
 
 odbfd_exit1:
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index f660156..58d5b56 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -63,7 +63,6 @@ struct omap_uart_state {
 static LIST_HEAD(uart_list);
 static u8 num_uarts;
 static u8 console_uart_id = -1;
-static u8 no_console_suspend;
 static u8 uart_debug;
 
 #define DEFAULT_RXDMA_POLLRATE		1	/* RX DMA polling rate (us) */
@@ -207,9 +206,6 @@ static int __init omap_serial_early_init(void)
 					uart_name, uart->num);
 			}
 
-			if (cmdline_find_option("no_console_suspend"))
-				no_console_suspend = true;
-
 			/*
 			 * omap-uart can be used for earlyprintk logs
 			 * So if omap-uart is used as console then prevent
@@ -292,9 +288,6 @@ void __init omap_serial_init_port(struct omap_board_data *bdata,
 		return;
 	}
 
-	if ((console_uart_id == bdata->id) && no_console_suspend)
-		omap_device_disable_idle_on_suspend(pdev);
-
 	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
 
 	if (console_uart_id == bdata->id) {
-- 
1.7.1

