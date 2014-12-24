Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaLXARW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 19:17:22 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39282 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaLXARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 19:17:21 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: noldoli@gmail.com
Date: Wed, 24 Dec 2014 11:17:20 +1100
X-Google-Sender-Auth: EhwDe6PEl_YmE6aKfjcPryiCX6Q
Message-ID: <CAEK4c-_Kirwxj_Rgqn1c7x4h0Mj0r8vhSYb5qQcJvo5TbXdb0Q@mail.gmail.com>
Subject: [PATCH 1/1] Elantech touchpad detection fix for laptops
From: Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Zakariya Dehlawi <zdehlawi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks,

[Thanks for Dmitry for pointing out my error in previous attempts at
sending this email. I've fixed it now. Sorry if you've received this
email multiple times by now.]

Months ago, I raised kernel bugzilla 81331
(https://bugzilla.kernel.org/show_bug.cgi?id=81331) for Linux not
detecting my Elantech touchpad from a cold boot. As can be seen in
that bug report, besides myself, it's indeed affecting a number of
other users.

Since then, based on the original patch fix given by Mateusz Jonczyk,
I've extended it to be this (which not only fixes my problem, but
others as well) & would appreciate your review (and inputs thereof) &
if you're happy with it, then request you to kindly merge it upstream
on mainline & stable.

On behalf of all affected users, much appreciate your help in this
matter. Thank you.

PS: If gmail somehow spoils this patch when it comes through, then
please refer to the above kernel bugzilla URL, where the same patch is
available as a file attachment.

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 479f332..5ae99f3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1270,6 +1270,7 @@ bytes respectively. Such letter suffixes can
also be entirely omitted.
        i8042.notimeout [HW] Ignore timeout condition signalled by controller
        i8042.reset     [HW] Reset the controller during init and cleanup
        i8042.unlock    [HW] Unlock (ignore) the keylock
+       i8042.kbdreset  [HW] Reset keyboard to detect Elantech touchpad

        i810=           [HW,DRM]

diff --git a/drivers/input/serio/i8042-x86ia64io.h
b/drivers/input/serio/i8042-x86ia64io.h
index faeeb13..40e85ed 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -735,6 +735,29 @@ static const struct dmi_system_id __initconst
i8042_dmi_dritek_table[] = {
        { }
 };

+/*
+ * Just as per kernel bugzilla #81331, some Elantech touchpad based laptops
+ * -- e.g., Gigabyte P35 v2, Gigabyte X3 Plus -- need keyboard reset while
+ * probing for the touchpad to get detected, initialised & finally work.
+ */
+static const struct dmi_system_id __initconst
i8042_dmi_elantech_kbdreset_table[] = {
+        {
+                /* Gigabyte P35 v2 */
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "P35V2"),
+                },
+        },
+       {
+               /* Aorus branded Gigabyte X3 Plus */
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "X3"),
+               },
+       },
+       { }
+};
+
 #endif /* CONFIG_X86 */

 #ifdef CONFIG_PNP
@@ -1030,6 +1053,9 @@ static int __init i8042_platform_init(void)
        if (dmi_check_system(i8042_dmi_dritek_table))
                i8042_dritek = true;

+       if (dmi_check_system(i8042_dmi_elantech_kbdreset_table))
+               i8042_kbdreset = true;
+
        /*
         * A20 was already enabled during early kernel init. But some buggy
         * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index f5a98af..7cf42df 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -67,6 +67,10 @@ static bool i8042_notimeout;
 module_param_named(notimeout, i8042_notimeout, bool, 0);
 MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");

+static bool i8042_kbdreset;
+module_param_named(kbdreset, i8042_kbdreset, bool, 0);
+MODULE_PARM_DESC(kbdreset, "Reset keyboard to detect Elantech
touchpad on some laptops");
+
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -790,6 +794,14 @@ static int __init i8042_check_aux(void)
                return -1;

 /*
+ * Reset keyboard to detect touchpad on some laptops having Elantech touchpad
+ */
+       if (i8042_kbdreset) {
+               pr_warn("Resetting keyboard to detect Elantech
touchpad on some laptops\n");
+               i8042_kbd_write(NULL, (unsigned char) 0xff);
+       }
+
+/*
  * Test AUX IRQ delivery to make sure BIOS did not grab the IRQ and
  * used it for a PCI card or somethig else.
  */
