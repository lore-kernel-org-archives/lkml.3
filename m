Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab3KIFQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:16:15 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55561 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3KIFQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:16:07 -0500
From: Len Brown <lenb@kernel.org>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 1/1] ACPI: delete CONFIG_ACPI_BLACKLIST_YEAR
Date: Sat,  9 Nov 2013 00:13:16 -0500
Message-Id: <eb2dbc3278cded2b5386dee1a371025ba8590cfb.1383973958.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.4
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

About 10 years ago, this option was created to help
distros enable ACPI and not get distracted by ACPI
BIOS issues in machines which were deemed old
at that time, eg 1999 and earlier.

After a couple of years, the high volume distros
stopped bothering to set this option, and instead
simply ran in ACPI mode on all systems with an
ACPI BIOS -- regardless of BIOS DMI year.

Recently there have been some ACPI-enabled systems
with no DMI, mandating that CONFIG_ACPI_BLACKLIST_YEAR=0.

So it seems vanishingly unlikely that this option
is helping anybody run a 2013 kernel on a 1998 system,
and now more systems mandate this option be disabled,
so we simplify by deleting it entirely.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/Kconfig     | 11 -----------
 drivers/acpi/blacklist.c | 35 -----------------------------------
 2 files changed, 46 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 22327e6..ce818e7 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -251,17 +251,6 @@ config ACPI_INITRD_TABLE_OVERRIDE
 	  initrd, therefore it's safe to say Y.
 	  See Documentation/acpi/initrd_table_override.txt for details
 
-config ACPI_BLACKLIST_YEAR
-	int "Disable ACPI for systems before Jan 1st this year" if X86_32
-	default 0
-	help
-	  Enter a 4-digit year, e.g., 2001, to disable ACPI by default
-	  on platforms with DMI BIOS date before January 1st that year.
-	  "acpi=force" can be used to override this mechanism.
-
-	  Enter 0 to disable this mechanism and allow ACPI to
-	  run by default no matter what the year.  (default)
-
 config ACPI_DEBUG
 	bool "Debug Statements"
 	default n
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 9515f18..a879588 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -75,39 +75,6 @@ static struct acpi_blacklist_item acpi_blacklist[] __initdata = {
 	{""}
 };
 
-#if	CONFIG_ACPI_BLACKLIST_YEAR
-
-static int __init blacklist_by_year(void)
-{
-	int year;
-
-	/* Doesn't exist? Likely an old system */
-	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
-		printk(KERN_ERR PREFIX "no DMI BIOS year, "
-			"acpi=force is required to enable ACPI\n" );
-		return 1;
-	}
-	/* 0? Likely a buggy new BIOS */
-	if (year == 0) {
-		printk(KERN_ERR PREFIX "DMI BIOS year==0, "
-			"assuming ACPI-capable machine\n" );
-		return 0;
-	}
-	if (year < CONFIG_ACPI_BLACKLIST_YEAR) {
-		printk(KERN_ERR PREFIX "BIOS age (%d) fails cutoff (%d), "
-		       "acpi=force is required to enable ACPI\n",
-		       year, CONFIG_ACPI_BLACKLIST_YEAR);
-		return 1;
-	}
-	return 0;
-}
-#else
-static inline int blacklist_by_year(void)
-{
-	return 0;
-}
-#endif
-
 int __init acpi_blacklisted(void)
 {
 	int i = 0;
@@ -166,8 +133,6 @@ int __init acpi_blacklisted(void)
 		}
 	}
 
-	blacklisted += blacklist_by_year();
-
 	dmi_check_system(acpi_osi_dmi_table);
 
 	return blacklisted;
-- 
1.8.4

