Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350AbaFQVPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:15:54 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:53584 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964907AbaFQVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:15:53 -0400
Date: Tue, 17 Jun 2014 23:15:49 +0200
From: Josef Gajdusek <atx@atx.name>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/battery: fix wrong value of capacity_now reported
 by few battery types when fully charged (resend)
Message-ID: <20140617211549.GB6988@dashie>
References: <20140612145813.GB14085@dashie>
 <4697863.VH2Gj7n1J0@vostro.rjw.lan>
 <20140617201359.GA6988@dashie>
 <2828453.ZgdXeiReHi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2828453.ZgdXeiReHi@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that some batteries (noticed on DELL JYPJ136) assume 
capacity_now = design_capacity when fully charged. This causes 
reported capacity to suddenly jump to >full_charge_capacity (and that 
means capacity reported to userspace is >100% and incorrect) 
values after 99%. This patch detects capacity_now > full_charge_capacity, 
notifies userspace (unless it is the known bug where capacity_now == 
design_capacity) and trims the value to full_charge_capacity.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
> Thinking more about the printk_once().  Perhaps it only needs to be printed
> when battery->capacity_now != battery->design_capacity (it's a known issue
> otherwise).
Changed. That was actually what I wanted to do originally, but I was unsure 
about the kernel policy on this sort of messages.

>> +      printk_once(KERN_WARNING FW_BUG
>> +         "battery: reported current charge level (%d) "
>> +         "is higher than reported maximum charge level (%d)."
>> +         "This is normal on some systems.\n",
>
> Also I think that the line above doesn't add any real value. :-)
Removed, now it really is not needed as there is not any known system for which 
capacity_now > full_charge_capacity && capacity_now != design_capacity would be 
considered "normal"

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index e48fc98..9cacabd 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -532,6 +532,19 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 			" invalid.\n");
 	}
 
+	/* When fully charged, some batteries wrongly report
+	 * capacity_now = design_capacity instead of = full_charge_capacity
+	 */
+	if (battery->capacity_now > battery->full_charge_capacity &&
+		battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN) {
+		battery->capacity_now = battery->full_charge_capacity;
+		if (battery->capacity_now != battery->design_capacity)
+			printk_once(KERN_WARNING FW_BUG
+				"battery: reported current charge level (%d) "
+				"is higher than reported maximum charge level (%d).\n",
+				battery->capacity_now, battery->full_charge_capacity);
+	}
+
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
 	    && battery->capacity_now >= 0 && battery->capacity_now <= 100)
 		battery->capacity_now = (battery->capacity_now *
