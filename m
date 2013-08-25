Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3HYRmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 13:42:08 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60461 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3HYRmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 13:42:06 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] acpi: blacklist win8 OSI for buggy laptops
Date: Sun, 25 Aug 2013 12:37:33 -0500
Message-Id: <1377452253-15882-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4-fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.7 the acpi backlight driver doesn't work correctly in several
machines because ACPI code has different code for Windows 8, and the
rest.

The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the
intel backlight driver, however it introduced several other issues in
different machines.

This patch fixes both regressions by blacklisting the win8 OSI, so we
are back to v3.6 behavior, and it should remain that way until the intel
backlight driver is fixed.

Since v3.7, users have been forced to fix the initial regression by
modifying the boot arguments (acpi_osi="!Windows 2012").

Once the Intel backlight driver works correctly for all machines, this
blacklist can be removed and that driver can be used instead.

https://bugzilla.kernel.org/show_bug.cgi?id=60682

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/blacklist.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index cb96296..42cccbe 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -192,6 +192,12 @@ static int __init dmi_disable_osi_win7(const struct dmi_system_id *d)
 	acpi_osi_setup("!Windows 2009");
 	return 0;
 }
+static int __init dmi_disable_osi_win8(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
+	acpi_osi_setup("!Windows 2012");
+	return 0;
+}
 
 static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	{
@@ -269,6 +275,35 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	},
 
 	/*
+	 * The following machines have broken backlight support when reporting
+	 * the Windows 2012 OSI, so disable it until their support is fixed.
+	 */
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "ASUS Zenbook Prime UX31A",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "UX31A"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "Dell Inspiron 15R SE",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7520"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "Lenovo ThinkPad Edge E530",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "3259A2G"),
+		},
+	},
+
+	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
 	 * Linux ignores it, except for the machines enumerated below.
 	 */
-- 
1.8.4-fc

