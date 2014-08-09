Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaHIJnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:43:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51325 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaHIJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:43:08 -0400
From: Mariusz Ceier <mceier@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mariusz Ceier <mceier+kernel@gmail.com>
Subject: [PATCH] acpi/battery: capacity_now should be assigned after comparing it to design_capacity.
Date: Sat,  9 Aug 2014 11:43:31 +0200
Message-Id: <1407577411-12874-1-git-send-email-mceier@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Ceier <mceier+kernel@gmail.com>

Otherwise warning is printed even when capacity_now before assignment is
equal to design_capacity, making the check useless and "current charge level" wrong
(it should be higher than, not equal to, "maximum charge level", which is
full_charge_capacity):

"battery: reported current charge level (56410) is higher than reported
maximum charge level (56410)."

Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 48bcf38..1c162e7 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -540,12 +540,12 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	 */
 	if (battery->capacity_now > battery->full_charge_capacity
 	    && battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN) {
-		battery->capacity_now = battery->full_charge_capacity;
 		if (battery->capacity_now != battery->design_capacity)
 			printk_once(KERN_WARNING FW_BUG
 				"battery: reported current charge level (%d) "
 				"is higher than reported maximum charge level (%d).\n",
 				battery->capacity_now, battery->full_charge_capacity);
+		battery->capacity_now = battery->full_charge_capacity;
 	}
 
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
-- 
2.0.4

