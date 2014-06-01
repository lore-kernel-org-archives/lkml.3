Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaFAQex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:34:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59934 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaFAQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:34:23 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        Matthew Garrett <matthew.garrett@nebula.com>
Date: Sun,  1 Jun 2014 12:33:55 -0400
Message-Id: <1401640436-1947-4-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
References: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-Spam-ASN: 
Subject: [PATCH 3/4] ACPI: Don't assume the existence of an SBS charger
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:54:46 +0000)
X-SA-Exim-Scanned: Yes (on cavan.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple hardware continues to expose an ACPI AC charger even when using SBS
to report battery state. The charger status byte returns all 0s in this case.
Since the spec requires that bit 4 be 1 at all times, assume that there's not
really a charger if it's set to zero.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/sbs.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 366ca40..b1df4ee 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -109,6 +109,7 @@ struct acpi_sbs {
 	u8 batteries_supported:4;
 	u8 manager_present:1;
 	u8 charger_present:1;
+	u8 charger_exists:1;
 };
 
 #define to_acpi_sbs(x) container_of(x, struct acpi_sbs, charger)
@@ -429,9 +430,19 @@ static int acpi_ac_get_present(struct acpi_sbs *sbs)
 
 	result = acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER,
 				 0x13, (u8 *) & status);
-	if (!result)
-		sbs->charger_present = (status >> 15) & 0x1;
-	return result;
+
+	if (result)
+		return result;
+
+	/*
+	 * The spec requires that bit 4 always be 1. If it's not set, assume
+	 * that the implementation doesn't support an SBS charger
+	 */
+	if (!(status >> 4) & 0x1)
+		return -ENODEV;
+
+	sbs->charger_present = (status >> 15) & 0x1;
+	return 0;
 }
 
 static ssize_t acpi_battery_alarm_show(struct device *dev,
@@ -554,6 +565,7 @@ static int acpi_charger_add(struct acpi_sbs *sbs)
 	if (result)
 		goto end;
 
+	sbs->charger_exists = 1;
 	sbs->charger.name = "sbs-charger";
 	sbs->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	sbs->charger.properties = sbs_ac_props;
@@ -580,9 +592,12 @@ static void acpi_sbs_callback(void *context)
 	struct acpi_battery *bat;
 	u8 saved_charger_state = sbs->charger_present;
 	u8 saved_battery_state;
-	acpi_ac_get_present(sbs);
-	if (sbs->charger_present != saved_charger_state)
-		kobject_uevent(&sbs->charger.dev->kobj, KOBJ_CHANGE);
+
+	if (sbs->charger_exists) {
+		acpi_ac_get_present(sbs);
+		if (sbs->charger_present != saved_charger_state)
+			kobject_uevent(&sbs->charger.dev->kobj, KOBJ_CHANGE);
+	}
 
 	if (sbs->manager_present) {
 		for (id = 0; id < MAX_SBS_BAT; ++id) {
@@ -619,7 +634,7 @@ static int acpi_sbs_add(struct acpi_device *device)
 	device->driver_data = sbs;
 
 	result = acpi_charger_add(sbs);
-	if (result)
+	if (result && result != -ENODEV)
 		goto end;
 
 	result = acpi_manager_get_info(sbs);
-- 
1.8.5.3

