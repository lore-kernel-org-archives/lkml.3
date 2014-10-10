Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaJJUvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:51:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47829 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaJJUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:51:36 -0400
Date: Fri, 10 Oct 2014 13:51:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: i8042 - disable active multiplexing by default
Message-ID: <20141010205131.GA3271@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Active multiplexing is a nice feature as it allows several pointing devices
(such as touchpad and external mouse) use their native protocols at the
same time. Unfortunately many manufacturers do not implement the feature
properly even though they advertise it. The problematic implementations are
never fixed, since Windows by default does not use this mode, and move from
one BIOS/model of laptop to another. When active multiplexing is broken
turning it on usually results in touchpad, keyboard, or both unresponsive.

With PS/2 usage on decline (most of PS/2 devices in use nowadays are
internal laptop touchpads), I expect number of users who have laptops with
working MUX implementation, docking stations with external PS/2 ports, and
who are still using external PS/2 mice, to be rather small. Let's flip the
default to be OFF and allow activating it through i8042.nomux=0 kernel
option.  We'll also keep DMI table where we can record known good models.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/kernel-parameters.txt   |   2 +-
 drivers/input/serio/i8042-x86ia64io.h | 281 +---------------------------------
 drivers/input/serio/i8042.c           |   2 +-
 3 files changed, 10 insertions(+), 275 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 10d51c2..6b10543 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1237,7 +1237,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	i8042.noloop	[HW] Disable the AUX Loopback command while probing
 			     for the AUX port
 	i8042.nomux	[HW] Don't check presence of an active multiplexing
-			     controller
+			     controller. Default: true.
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
 			     controllers
 	i8042.notimeout	[HW] Ignore timeout condition signalled by controller
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 40b7d6c..75409ab 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -201,282 +201,17 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 };
 
 /*
- * Some Fujitsu notebooks are having trouble with touchpads if
- * active multiplexing mode is activated. Luckily they don't have
- * external PS/2 ports so we can safely disable it.
- * ... apparently some Toshibas don't like MUX mode either and
- * die horrible death on reboot.
+ * Some laptops do increment active multiplexing mode correctly;
+ * unfortunately they are in minority.
  */
-static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
-	{
-		/* Fujitsu Lifebook P7010/P7010D */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P7010"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook P7010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "0000000000"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook P5020D */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook P Series"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook S2000 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
-		},
-	},
-	{
-		/* Fujitsu Lifebook S6230 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S6230"),
-		},
-	},
-	{
-		/* Fujitsu T70H */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "FMVLT70H"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Lifebook T3010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T3010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Lifebook E4010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E4010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Amilo Pro 2010 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
-		},
-	},
-	{
-		/* Fujitsu-Siemens Amilo Pro 2030 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
-		},
-	},
-	{
-		/*
-		 * No data is coming from the touchscreen unless KBC
-		 * is in legacy mode.
-		 */
-		/* Panasonic CF-29 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Matsushita"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CF-29"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion DV4017EA -
-		 * errors on MUX ports are reported without raising AUXDATA
-		 * causing "spurious NAK" messages.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EA032EA#ABF)"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion ZT1000 -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Notebook PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook ZT1000"),
-		},
-	},
-	{
-		/*
-		 * HP Pavilion DV4270ca -
-		 * like DV4017EA does not raise AUXERR for errors on MUX ports.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P10"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EQUIUM A110"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C850D"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
-		},
-	},
-	{
-		/* Sharp Actius MM20 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-MM20 Series"),
-		},
-	},
-	{
-		/* Sony Vaio FS-115b */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FS115B"),
-		},
-	},
+static const struct dmi_system_id __initconst i8042_dmi_mux_table[] = {
 	{
 		/*
-		 * Sony Vaio FZ-240E -
-		 * reset and GET ID commands issued via KBD port are
-		 * sometimes being delivered to AUX3.
+		 * Panasonic CF-18 needs to be in MUX mode since the
+		 * touchscreen is on serio3 and it also has touchpad.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FZ240E"),
-		},
-	},
-	{
-		/*
-		 * Most (all?) VAIOs do not have external PS/2 ports nor
-		 * they implement active multiplexing properly, and
-		 * MUX discovery usually messes up keyboard/touchpad.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VAIO"),
-		},
-	},
-	{
-		/* Amoi M636/A737 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Amoi Electronics CO.,LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "M636/A737 platform"),
-		},
-	},
-	{
-		/* Lenovo 3000 n100 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1360"),
-		},
-	},
-	{
-		/* Acer Aspire 5710 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710"),
-		},
-	},
-	{
-		/* Gericom Bellagio */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
-		},
-	},
-	{
-		/* IBM 2656 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
-		},
-	},
-	{
-		/* Dell XPS M1530 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
-		},
-	},
-	{
-		/* Compal HEL80I */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "COMPAL"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HEL80I"),
-		},
-	},
-	{
-		/* Dell Vostro 1510 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro1510"),
-		},
-	},
-	{
-		/* Acer Aspire 5536 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5536"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
-		},
-	},
-	{
-		/* Dell Vostro V13 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
-		},
-	},
-	{
-		/* Newer HP Pavilion dv4 models */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
-		},
-	},
-	{
-		/* Asus X450LCP */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "X450LCP"),
-		},
-	},
-	{
-		/* Avatar AVIU-145A6 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
 		},
 	},
 	{ }
@@ -999,8 +734,8 @@ static int __init i8042_platform_init(void)
 	if (dmi_check_system(i8042_dmi_noloop_table))
 		i8042_noloop = true;
 
-	if (dmi_check_system(i8042_dmi_nomux_table))
-		i8042_nomux = true;
+	if (dmi_check_system(i8042_dmi_mux_table))
+		i8042_nomux = false;
 
 	if (dmi_check_system(i8042_dmi_notimeout_table))
 		i8042_notimeout = true;
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index f5a98af..9a97c2b 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -39,7 +39,7 @@ static bool i8042_noaux;
 module_param_named(noaux, i8042_noaux, bool, 0);
 MODULE_PARM_DESC(noaux, "Do not probe or use AUX (mouse) port.");
 
-static bool i8042_nomux;
+static bool i8042_nomux = true;
 module_param_named(nomux, i8042_nomux, bool, 0);
 MODULE_PARM_DESC(nomux, "Do not check whether an active multiplexing controller is present.");
 
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
