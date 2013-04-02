Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534Ab3DBN2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:28:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761505Ab3DBN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:28:50 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <tony@atomide.com>, <khilman@linaro.org>, <rmk+kernel@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        <michael@amarulasolutions.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv2] arm: mach-omap2: prevent UART console idle on suspend while using "no_console_suspend"
Date: Tue, 2 Apr 2013 18:58:22 +0530
Message-ID: <1364909302-27970-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dt boot, uart wakeup after suspend is non functional while using
"no_console_suspend" in the bootargs. With "no_console_suspend" used, od->flags
should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not allowing the console
to idle in the suspend path.

Tested on omap5430evm, omap4430sdp.

Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
Cc: Felipe Balbi<balbi@ti.com>
Cc: Rajendra nayak<rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
v1->v2
These patches were sent before as a series[1], but realised
"core_initcall(omap_serial_early_init)" in serial.c get executed
irrespective of dt or non dt boot and it will do most of the stuff
for us.
As suggested by Kevin Hilman in the previous version, this patch will
also prevent creating dependency between omap_device
(generic device-independent code) and a specific driver (UART).

[1]: http://lkml.org/lkml/2013/3/18/294

 arch/arm/mach-omap2/omap_device.c |    5 +++--
 arch/arm/mach-omap2/omap_hwmod.h  |    5 +++++
 arch/arm/mach-omap2/serial.c      |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index 381be7a..89be64d 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -170,8 +170,9 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 			r->name = dev_name(&pdev->dev);
 	}
 
-	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
-		omap_device_disable_idle_on_suspend(pdev);
+	if (oh->flags & HWMOD_DISABLE_IDLE_ON_SUSPEND ||
+		of_get_property(node, "ti,no_idle_on_suspend", NULL))
+			omap_device_disable_idle_on_suspend(pdev);
 
 	pdev->dev.pm_domain = &omap_device_pm_domain;
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.h b/arch/arm/mach-omap2/omap_hwmod.h
index d43d9b6..50e6145 100644
--- a/arch/arm/mach-omap2/omap_hwmod.h
+++ b/arch/arm/mach-omap2/omap_hwmod.h
@@ -459,6 +459,10 @@ struct omap_hwmod_omap4_prcm {
  *     correctly, or this is being abused to deal with some PM latency
  *     issues -- but we're currently suffering from a shortage of
  *     folks who are able to track these issues down properly.
+ * HWMOD_DISABLE_IDLE_ON_SUSPEND: don't idle this module on suspend. This is
+ *     needed for uart controller, which requires its clock not to be cut
+ *     during suspend while using "no_console_suspend" in bootargs with
+ *     device tree boot.
  */
 #define HWMOD_SWSUP_SIDLE			(1 << 0)
 #define HWMOD_SWSUP_MSTANDBY			(1 << 1)
@@ -471,6 +475,7 @@ struct omap_hwmod_omap4_prcm {
 #define HWMOD_16BIT_REG				(1 << 8)
 #define HWMOD_EXT_OPT_MAIN_CLK			(1 << 9)
 #define HWMOD_BLOCK_WFI				(1 << 10)
+#define HWMOD_DISABLE_IDLE_ON_SUSPEND		(1 << 12)
 
 /*
  * omap_hwmod._int_flags definitions
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 8396b5b..adbafbd 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -236,8 +236,10 @@ static int __init omap_serial_early_init(void)
 					uart_name, uart->num);
 			}
 
-			if (cmdline_find_option("no_console_suspend"))
+			if (cmdline_find_option("no_console_suspend")) {
 				no_console_suspend = true;
+				oh->flags |= HWMOD_DISABLE_IDLE_ON_SUSPEND;
+			}
 
 			/*
 			 * omap-uart can be used for earlyprintk logs
-- 
1.7.1

