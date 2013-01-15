Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3AOW2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:41529 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab3AOW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thomas Weber <thomas@tomweber.eu>, Tony Lindgren <tony@atomide.com>
Subject: [ 059/221] OMAP: board-files: fix i2c_bus for tfp410
Date: Tue, 15 Jan 2013 10:49:46 -0800
Message-Id: <20130115185002.318894741@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-3430sdp.c      |    1 +
 arch/arm/mach-omap2/board-am3517evm.c    |    1 +
 arch/arm/mach-omap2/board-cm-t35.c       |    1 +
 arch/arm/mach-omap2/board-devkit8000.c   |    1 +
 arch/arm/mach-omap2/board-omap3evm.c     |    1 +
 arch/arm/mach-omap2/board-omap3stalker.c |    1 +
 include/video/omap-panel-tfp410.h        |    2 +-
 7 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -157,6 +157,7 @@ static struct omap_dss_device sdp3430_lc
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device sdp3430_dvi_device = {
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -208,6 +208,7 @@ static struct omap_dss_device am3517_evm
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device am3517_evm_dvi_device = {
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -243,6 +243,7 @@ static struct omap_dss_device cm_t35_lcd
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= CM_T35_DVI_EN_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device cm_t35_dvi_device = {
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -139,6 +139,7 @@ static struct omap_dss_device devkit8000
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= 1,
 };
 
 static struct omap_dss_device devkit8000_dvi_device = {
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -236,6 +236,7 @@ static struct omap_dss_device omap3_evm_
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= OMAP3EVM_DVI_PANEL_EN_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device omap3_evm_dvi_device = {
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -119,6 +119,7 @@ static struct omap_dss_device omap3_stal
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= DSS_ENABLE_GPIO,
+	.i2c_bus_num		= -1,
 };
 
 static struct omap_dss_device omap3_stalker_dvi_device = {
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
 


