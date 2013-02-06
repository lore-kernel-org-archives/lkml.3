Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3BFD76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:59:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46141 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab3BFD7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:59:53 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <hs@denx.de>, <mporter@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <mchehab@redhat.com>, <vaibhav.bedia@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <anilkumar.v@ti.com>
Subject: [PATCH V2 2/2] ARM: davinci: restart: fix wdt to machine restart with DT
Date: Wed, 6 Feb 2013 09:30:04 +0530
Message-ID: <1360123204-9978-3-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com>
References: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In non DT case da8xx_register_watchdog() is called to register platform device
"da8xx_wdt_device" by board file. But in DT case it is not called and wdt
device get registered via wdt DT node.

Currently code is passing platform device "da8xx_wdt_device" in
"davinci_watchdog_reset" function in both DT and non DT case and that
leads to crash in DT boot.

Update restart function to make it generic DaVinci machine restart
in case of DT and non DT boot.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 2d5502d... 1df68fd... M	arch/arm/mach-davinci/devices-da8xx.c
:100644 100644 700d311... ef9f70e... M	arch/arm/mach-davinci/include/mach/da8xx.h
 arch/arm/mach-davinci/devices-da8xx.c      |   14 ++++++++++++--
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 -
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 2d5502d..1df68fd 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -359,7 +359,7 @@ static struct resource da8xx_watchdog_resources[] = {
 	},
 };
 
-struct platform_device da8xx_wdt_device = {
+static struct platform_device da8xx_wdt_device = {
 	.name		= "watchdog",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(da8xx_watchdog_resources),
@@ -368,7 +368,17 @@ struct platform_device da8xx_wdt_device = {
 
 void da8xx_restart(char mode, const char *cmd)
 {
-	davinci_watchdog_reset(&da8xx_wdt_device);
+	struct device *dev = NULL;
+	struct platform_device *wdt_device = NULL;
+
+	dev = bus_find_device_by_name(&platform_bus_type, NULL, "watchdog");
+	if (!dev) {
+		pr_err("wdt device not found to machine reboot\n");
+		return;
+	}
+
+	wdt_device = to_platform_device(dev);
+	davinci_watchdog_reset(wdt_device);
 }
 
 int __init da8xx_register_watchdog(void)
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index 700d311..ef9f70e 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -112,7 +112,6 @@ extern struct da8xx_lcdc_platform_data sharp_lcd035q3dg01_pdata;
 extern struct da8xx_lcdc_platform_data sharp_lk043t1dg01_pdata;
 extern struct davinci_spi_platform_data da8xx_spi_pdata[];
 
-extern struct platform_device da8xx_wdt_device;
 
 extern const short da830_emif25_pins[];
 extern const short da830_spi0_pins[];
-- 
1.7.4.1

