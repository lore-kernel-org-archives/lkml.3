Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3G2TY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:24:27 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51401 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3G2TYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:24:24 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
Date: Mon, 29 Jul 2013 14:20:58 -0500
Message-Id: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.7 the acpi backlight driver doesn't work at all on this machine
because presumably the ACPI code contains stub code when Windows 8 OSI is
reported.

The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
backlight driver, however, on this machine it turns the backlight completely
off when it reaches level 0%, after which the user might have a lot trouble
trying to bring it back.

This patch fixes both regressions by blacklisting the win8 OSI, so we are back
to v3.6 behavior, and it should remain that way until the intel backlight
driver is fixed.

Since v3.7, users have been forced to fix the initial regression by modifying
the boot arguments [1].

[1] https://wiki.archlinux.org/index.php/ASUS_Zenbook_Prime_UX31A

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/blacklist.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index cb96296..a404127 100644
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
@@ -267,6 +273,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "ASUS Zenbook Prime UX31A",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "UX31A"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.8.3.4

