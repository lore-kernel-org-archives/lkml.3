Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaCKWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:20:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52148 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaCKWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:20:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@rjwysocki.net,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 3/3] ACPI: Don't re-select SBS battery if it's already selected
Date: Tue, 11 Mar 2014 18:20:02 -0400
Message-Id: <1394576402-2910-4-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
References: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing SBS code explicitly sets the selected battery in the SBS
manager regardless of whether the battery in question is already selected.
This causes bus timeouts on Apple hardware. Check for this case and avoid
it.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/sbs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index dbd4849..c386505 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -470,17 +470,25 @@ static struct device_attribute alarm_attr = {
 static int acpi_battery_read(struct acpi_battery *battery)
 {
 	int result = 0, saved_present = battery->present;
-	u16 state;
+	u16 state, selected, desired;
 
 	if (battery->sbs->manager_present) {
 		result = acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
 				ACPI_SBS_MANAGER, 0x01, (u8 *)&state);
 		if (!result)
 			battery->present = state & (1 << battery->id);
-		state &= 0x0fff;
-		state |= 1 << (battery->id + 12);
-		acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
-				  ACPI_SBS_MANAGER, 0x01, (u8 *)&state, 2);
+		/*
+		 * Don't switch battery if the correct one is already selected
+		 */
+		selected = state & 0xf000;
+		desired = 1 << (battery->id + 12);
+		if (selected != desired) {
+			state &= 0x0fff;
+			state |= desired;
+			acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
+					 ACPI_SBS_MANAGER, 0x01,
+					 (u8 *)&state, 2);
+		}
 	} else if (battery->id == 0)
 		battery->present = 1;
 	if (result || !battery->present)
-- 
1.8.5.3

