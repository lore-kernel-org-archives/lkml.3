Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3APQFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab3APQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Thomas Weber <thomas@tomweber.eu>,
        Tony Lindgren <tony@atomide.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 128/222] OMAP: board-files: fix i2c_bus for tfp410
Date: Wed, 16 Jan 2013 13:55:28 -0200
Message-Id: <1358351822-7675-129-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit ca2e16faa7378878c1522a7c1b6c38211de3331d upstream.

The i2c handling in tfp410 driver, which handles converting parallel RGB
to DVI, was changed in 958f2717b84e88bf833d996997fda8f73276f2af
(OMAPDSS: TFP410: pdata rewrite). The patch changed what value the
driver considers as invalid/undefined.  Before the patch, 0 was the
invalid value, but as 0 is a valid bus number, the patch changed this to
-1.

However, the fact was missed that many board files do not define the bus
number at all, thus it's left to 0. This causes the driver to fail to
get the i2c bus, exiting from the driver's probe with an error, meaning
that the DVI output does not work for those boards.

This patch fixes the issue by changing the i2c_bus number field in the
driver's platform data from u16 to int, and setting the bus number to -1
in the board files for the boards that did not define the bus. The
exception is devkit8000, for which the bus is set to 1, which is the
correct bus for that board.

The bug exists in v3.5+ kernels.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reported-by: Thomas Weber <thomas@tomweber.eu>
Cc: Thomas Weber <thomas@tomweber.eu>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-omap2/board-3430sdp.c      |    1 +
 arch/arm/mach-omap2/board-am3517evm.c    |    1 +
 arch/arm/mach-omap2/board-cm-t35.c       |    1 +
 arch/arm/mach-omap2/board-devkit8000.c   |    1 +
 arch/arm/mach-omap2/board-omap3evm.c     |    1 +
 arch/arm/mach-omap2/board-omap3stalker.c |    1 +
 include/video/omap-panel-tfp410.h        |    2 +-
 7 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index a98c688..456fdbc 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -159,6 +159,7 @@ static struct omap_dss_device sdp3430_lcd_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device sdp3430_dvi_device = {
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 18f6010..919dd66 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -209,6 +209,7 @@ static struct omap_dss_device am3517_evm_tv_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device am3517_evm_dvi_device = {
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index ded100c..7e4cbda 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -243,6 +243,7 @@ static struct omap_dss_device cm_t35_lcd_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= CM_T35_DVI_EN_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device cm_t35_dvi_device = {
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 6567c1c..024b115 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -143,6 +143,7 @@ static struct omap_dss_device devkit8000_lcd_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= 1,
 };
 
 static struct omap_dss_device devkit8000_dvi_device = {
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 639bd07..dcae228 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -221,6 +221,7 @@ static struct omap_dss_device omap3_evm_tv_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= OMAP3EVM_DVI_PANEL_EN_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device omap3_evm_dvi_device = {
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index b318f56..5387db6 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -121,6 +121,7 @@ static struct omap_dss_device omap3_stalker_tv_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= DSS_ENABLE_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device omap3_stalker_dvi_device = {
diff --git a/include/video/omap-panel-tfp410.h b/include/video/omap-panel-tfp410.h
index 68c31d7..aef35e4 100644
--- a/include/video/omap-panel-tfp410.h
+++ b/include/video/omap-panel-tfp410.h
@@ -28,7 +28,7 @@ struct omap_dss_device;
  * @power_down_gpio: gpio number for PD pin (or -1 if not available)
  */
 struct tfp410_platform_data {
-	u16 i2c_bus_num;
+	int i2c_bus_num;
 	int power_down_gpio;
 };
 
-- 
1.7.9.5

