Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbbA2KPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:15:19 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757220AbbA2JBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 119/176] Input: i8042 - reset keyboard to fix Elantech touchpad detection
Date: Wed, 28 Jan 2015 15:29:09 +0100
Message-Id: <8f8a12f052bfcf00d952c0854e79aeeca2752e1b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 148e9a711e034e06310a8c36b64957934ebe30f2 upstream.

On some laptops, keyboard needs to be reset in order to successfully detect
touchpad (e.g., some Gigabyte laptop models with Elantech touchpads).
Without resettin keyboard touchpad pretends to be completely dead.

Based on the original patch by Mateusz Jończyk this version has been
expanded to include DMI based detection & application of the fix
automatically on the affected models of laptops. This has been confirmed to
fix problem by three users already on three different models of laptops.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81331
Signed-off-by: Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Tested-by: Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
Tested by: Zakariya Dehlawi <zdehlawi@gmail.com>
Tested-by: Guillaum Bouchard <guillaum.bouchard@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/kernel-parameters.txt   |  1 +
 drivers/input/serio/i8042-x86ia64io.h | 32 ++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042.c           | 14 ++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 789b8941a0c6..64c6734da6d8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1119,6 +1119,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	i8042.notimeout	[HW] Ignore timeout condition signalled by controller
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
+	i8042.kbdreset  [HW] Reset device connected to KBD port
 
 	i810=		[HW,DRM]
 
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index a4ac027637b9..c92612d5c6d0 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -728,6 +728,35 @@ static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
 	{ }
 };
 
+/*
+ * Some laptops need keyboard reset before probing for the trackpad to get
+ * it detected, initialised & finally work.
+ */
+static const struct dmi_system_id __initconst i8042_dmi_kbdreset_table[] = {
+	{
+		/* Gigabyte P35 v2 - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P35V2"),
+		},
+	},
+		{
+		/* Aorus branded Gigabyte X3 Plus - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X3"),
+		},
+	},
+	{
+		/* Gigabyte P34 - Elantech touchpad */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P34"),
+		},
+	},
+	{ }
+};
+
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
@@ -1023,6 +1052,9 @@ static int __init i8042_platform_init(void)
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
 
+	if (dmi_check_system(i8042_dmi_kbdreset_table))
+		i8042_kbdreset = true;
+
 	/*
 	 * A20 was already enabled during early kernel init. But some buggy
 	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 03ab163857dd..e38024cf0227 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -67,6 +67,10 @@ static bool i8042_notimeout;
 module_param_named(notimeout, i8042_notimeout, bool, 0);
 MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
 
+static bool i8042_kbdreset;
+module_param_named(kbdreset, i8042_kbdreset, bool, 0);
+MODULE_PARM_DESC(kbdreset, "Reset device connected to KBD port");
+
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -790,6 +794,16 @@ static int __init i8042_check_aux(void)
 		return -1;
 
 /*
+ * Reset keyboard (needed on some laptops to successfully detect
+ * touchpad, e.g., some Gigabyte laptop models with Elantech
+ * touchpads).
+ */
+	if (i8042_kbdreset) {
+		pr_warn("Attempting to reset device connected to KBD port\n");
+		i8042_kbd_write(NULL, (unsigned char) 0xff);
+	}
+
+/*
  * Test AUX IRQ delivery to make sure BIOS did not grab the IRQ and
  * used it for a PCI card or somethig else.
  */
-- 
2.2.2

