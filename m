Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaIOVNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:13:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaIOT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.16 032/158] mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators
Date: Mon, 15 Sep 2014 12:24:31 -0700
Message-Id: <20140915192543.845737036@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit daebabd578647440d41fc9b48d8c7a88dc2f7ab5 upstream.

Commit 43fef47f94a1 (mfd: twl4030-power: Add a configuration to turn
off oscillator during off-idle) added support for configuring the PMIC
to cut off resources during deeper idle states to save power.

This however caused regression for n900 display power that needed the
PMIC configuration to be disabled with commit d937678ab625 (ARM: dts:
Revert enabling of twl configuration for n900).

Turns out the root cause of the problem is that we must use
TWL4030_RESCONFIG_UNDEF instead of DEV_GRP_NULL to avoid disabling
regulators that may have been enabled before the init function
for twl4030-power.c runs. With TWL4030_RESCONFIG_UNDEF we let the
regulator framework control the regulators like it should. Here we
need to only configure the sys_clken and sys_off_mode triggers for
the regulators that cannot be done by the regulator framework as
it's not running at that point.

This allows us to enable the PMIC configuration for n900.

Fixes: 43fef47f94a1 (mfd: twl4030-power: Add a configuration to turn off oscillator during off-idle)

Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-n900.dts |    2 +-
 drivers/mfd/twl4030-power.c      |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -353,7 +353,7 @@
 	};
 
 	twl_power: power {
-		compatible = "ti,twl4030-power-n900";
+		compatible = "ti,twl4030-power-n900", "ti,twl4030-power-idle-osc-off";
 		ti,use_poweroff;
 	};
 };
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -724,24 +724,24 @@ static struct twl4030_script *omap3_idle
  * above.
  */
 static struct twl4030_resconfig omap3_idle_rconfig[] = {
-	TWL_REMAP_SLEEP(RES_VAUX1, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VAUX2, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VAUX3, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VAUX4, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VMMC1, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VMMC2, DEV_GRP_NULL, 0, 0),
+	TWL_REMAP_SLEEP(RES_VAUX1, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VAUX2, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VAUX3, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VAUX4, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VMMC1, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VMMC2, TWL4030_RESCONFIG_UNDEF, 0, 0),
 	TWL_REMAP_OFF(RES_VPLL1, DEV_GRP_P1, 3, 1),
 	TWL_REMAP_SLEEP(RES_VPLL2, DEV_GRP_P1, 0, 0),
-	TWL_REMAP_SLEEP(RES_VSIM, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VDAC, DEV_GRP_NULL, 0, 0),
+	TWL_REMAP_SLEEP(RES_VSIM, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VDAC, TWL4030_RESCONFIG_UNDEF, 0, 0),
 	TWL_REMAP_SLEEP(RES_VINTANA1, TWL_DEV_GRP_P123, 1, 2),
 	TWL_REMAP_SLEEP(RES_VINTANA2, TWL_DEV_GRP_P123, 0, 2),
 	TWL_REMAP_SLEEP(RES_VINTDIG, TWL_DEV_GRP_P123, 1, 2),
 	TWL_REMAP_SLEEP(RES_VIO, TWL_DEV_GRP_P123, 2, 2),
 	TWL_REMAP_OFF(RES_VDD1, DEV_GRP_P1, 4, 1),
 	TWL_REMAP_OFF(RES_VDD2, DEV_GRP_P1, 3, 1),
-	TWL_REMAP_SLEEP(RES_VUSB_1V5, DEV_GRP_NULL, 0, 0),
-	TWL_REMAP_SLEEP(RES_VUSB_1V8, DEV_GRP_NULL, 0, 0),
+	TWL_REMAP_SLEEP(RES_VUSB_1V5, TWL4030_RESCONFIG_UNDEF, 0, 0),
+	TWL_REMAP_SLEEP(RES_VUSB_1V8, TWL4030_RESCONFIG_UNDEF, 0, 0),
 	TWL_REMAP_SLEEP(RES_VUSB_3V1, TWL_DEV_GRP_P123, 0, 0),
 	/* Resource #20 USB charge pump skipped */
 	TWL_REMAP_SLEEP(RES_REGEN, TWL_DEV_GRP_P123, 2, 1),


