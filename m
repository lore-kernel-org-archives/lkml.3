Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3DWNVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:21:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38729 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab3DWNVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:21:10 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] i2c: omap: convert to module_platform_driver()
Date: Tue, 23 Apr 2013 16:19:09 +0300
Message-ID: <1366723151-23209-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP I2C driver has a relation to pinctrl-single driver. As result,
its probe will be deferred during system boot until late init time,
because the pinctrl-single is initizalized as moudle/device init time.
This, in turn, will delay initialization of all I2C devices (like mfd,
I2C regulators and etc.) and cause boot delay (more over, it can broken
initialization of drivers which are not ready to use deferred probe
mechanism yet, for example DSS).

There are no sense to keep OMAP I2C initialization on subsys init layer
any more, hence shift it to module/device layer where the i2c <-->
pinctrl-single dependency is resolved in drivers/Makefile now.

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4cc2f05..70d3fed 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1342,19 +1342,7 @@ static struct platform_driver omap_i2c_driver = {
 	},
 };
 
-/* I2C may be needed to bring up other drivers */
-static int __init
-omap_i2c_init_driver(void)
-{
-	return platform_driver_register(&omap_i2c_driver);
-}
-subsys_initcall(omap_i2c_init_driver);
-
-static void __exit omap_i2c_exit_driver(void)
-{
-	platform_driver_unregister(&omap_i2c_driver);
-}
-module_exit(omap_i2c_exit_driver);
+module_platform_driver(omap_i2c_driver);
 
 MODULE_AUTHOR("MontaVista Software, Inc. (and others)");
 MODULE_DESCRIPTION("TI OMAP I2C bus adapter");
-- 
1.7.9.5

