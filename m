Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaLVSQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:16:00 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:33428 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaLVSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:15:58 -0500
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com,
        Romain.Baeriswyl@abilis.com, atull@opensource.altera.com,
        raymond.tan@intel.com, carlpeng008@gmail.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Walter Lozano <walter@vanguardiasur.com.ar>
Subject: [RFC] i2c: designware: Avoid initcall and initialize the driver like a regular one
Date: Mon, 22 Dec 2014 15:15:49 -0300
Message-Id: <1419272149-28716-1-git-send-email-walter@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the driver is relying on a subsys_initcall() to register
the platform driver struct. This is typically done to allow early uses
of the I2C bus (for instance, I2C regulators used from early machine code).

While this might work on some cases, it breaks on others. For instance,
I2C devices with GPIO-wired interrupts will fail to request the
interrupt because of this initcall usage.

This commits attempts to fix the above issue, by converting the I2C
driver into a regular kernel platform driver. This guarantees it will
probe after GPIOs drivers.

Platforms based on devicetree won't be affected by this change. Legacy
platforms, relying on the I2C being available early, might need to
implement proper defered mechanisms to overcome potential problems.

Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 2b463c3..579e65c 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -333,17 +333,7 @@ static struct platform_driver dw_i2c_driver = {
 	},
 };
 
-static int __init dw_i2c_init_driver(void)
-{
-	return platform_driver_register(&dw_i2c_driver);
-}
-subsys_initcall(dw_i2c_init_driver);
-
-static void __exit dw_i2c_exit_driver(void)
-{
-	platform_driver_unregister(&dw_i2c_driver);
-}
-module_exit(dw_i2c_exit_driver);
+module_platform_driver(dw_i2c_driver);
 
 MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
 MODULE_DESCRIPTION("Synopsys DesignWare I2C bus adapter");
-- 
1.7.10.4

