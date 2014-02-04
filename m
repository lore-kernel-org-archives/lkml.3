Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaBDMVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:21:06 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37125 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaBDMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:19:20 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] i2c: bcm-kona: register with subsys_initcall
Date: Tue,  4 Feb 2014 07:19:07 -0500
Message-Id: <1391516352-32359-2-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391516352-32359-1-git-send-email-mporter@linaro.org>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voltage regulators are needed very early due to deferred probe
being incompatible with built-in USB gadget drivers. In order to
have the PMU driver available before USB UDC, make i2c available
during subsys_initcall.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/i2c/busses/i2c-bcm-kona.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index 18a74a6..bfd4056 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -901,7 +901,19 @@ static struct platform_driver bcm_kona_i2c_driver = {
 	.probe = bcm_kona_i2c_probe,
 	.remove = bcm_kona_i2c_remove,
 };
-module_platform_driver(bcm_kona_i2c_driver);
+
+static int __init bcm_kona_i2c_init_driver(void)
+{
+	return platform_driver_register(&bcm_kona_i2c_driver);
+}
+/* PMU access is needed early so use subsys init */
+subsys_initcall(bcm_kona_i2c_init_driver);
+
+static void __exit bcm_kona_i2c_exit_driver(void)
+{
+	platform_driver_unregister(&bcm_kona_i2c_driver);
+}
+module_exit(bcm_kona_i2c_exit_driver);
 
 MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");
 MODULE_DESCRIPTION("Broadcom Kona I2C Driver");
-- 
1.8.4

