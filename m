Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3FZSFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:05:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45445 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3FZSFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:05:10 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 3/3] watchdog: dw_wdt: add a devicetree binding
Date: Wed, 26 Jun 2013 20:05:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
References: <201306262003.13256.heiko@sntech.de>
In-Reply-To: <201306262003.13256.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262005.05765.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_wdt does not use any platform-specific data, so no new properties
need to be introduced. The dw-apb-wdt naming follows other designware
components in the kernel and is also written like this in documentation
describing the component.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/watchdog/snps-dw-apb-wdt.txt |   18 ++++++++++++++++++
 drivers/watchdog/dw_wdt.c                            |   10 ++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt b/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
new file mode 100644
index 0000000..c20cdd1
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
@@ -0,0 +1,18 @@
+* Synosis DesignWare APB Watchdog
+
+The Watchdog controller is used for resuming system operation
+after a preset amount of time during which the WDT reset event has not
+occurred.
+
+Required properties:
+- compatible : "snps,dw-apb-wdt"
+- reg : offset and length of the register set for the device.
+- clocks : the periphal clock of the controller.
+
+Example:
+
+	watchdog@2004c000 {
+		compatible = "snps,dw-apb-wdt";
+		reg = <0x2004c000 0x100>;
+		clocks = <&wdt_clock>;
+	};
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index b922bec..829e148 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -35,6 +35,7 @@
 #include <linux/timer.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
+#include <linux/of.h>
 
 #define WDOG_CONTROL_REG_OFFSET		    0x00
 #define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
@@ -337,12 +338,21 @@ static int dw_wdt_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id dw_wdt_of_match[] = {
+	{ .compatible = "snps,dw-apb-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, dw_i2c_of_match);
+#endif
+
 static struct platform_driver dw_wdt_driver = {
 	.probe		= dw_wdt_drv_probe,
 	.remove		= dw_wdt_drv_remove,
 	.driver		= {
 		.name	= "dw_wdt",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(dw_wdt_of_match),
 		.pm	= &dw_wdt_pm_ops,
 	},
 };
-- 
1.7.10.4

