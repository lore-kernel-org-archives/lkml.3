Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3LNRbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34312 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3LNRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:51 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 12/14] i8k: Use driver_data field of dmi_system_id to override fan multiplier
Date: Sat, 14 Dec 2013 09:30:19 -0800
Message-Id: <1387042221-3671-13-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on Studio 1555 and XPS M140, the fan speed is reported directly,
not with the default speed multiplier of 30. Information on the web
suggests that this may be true for other models as well, though it is
unknown at this time which systems may be affected.

Use the driver_data field of dmi_system_id to override the default fan
multiplier value for the two systems known to use a multiplier of 1.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index bd11dac..67e4256 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -65,6 +65,7 @@ static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
+static int i8k_fan_mult;
 
 #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
 #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
@@ -275,7 +276,7 @@ static int i8k_get_fan_speed(int fan)
 	struct smm_regs regs = { .eax = I8K_SMM_GET_SPEED, };
 
 	regs.ebx = fan & 0xff;
-	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * fan_mult;
+	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * i8k_fan_mult;
 }
 
 /*
@@ -691,6 +692,7 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio"),
 		},
+		.driver_data = (void *)1,	/* fan multiplier override */
 	},
 	{
 		.ident = "Dell XPS M140",
@@ -698,6 +700,7 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
 		},
+		.driver_data = (void *)1,	/* fan multiplier override */
 	},
 	{ }
 };
@@ -709,6 +712,7 @@ static int __init i8k_probe(void)
 {
 	char buff[4];
 	int version;
+	const struct dmi_system_id *id;
 
 	/*
 	 * Get DMI information
@@ -762,6 +766,11 @@ static int __init i8k_probe(void)
 				buff, bios_version);
 	}
 
+	i8k_fan_mult = fan_mult;
+	id = dmi_first_match(i8k_dmi_table);
+	if (id && fan_mult == I8K_FAN_MULT && id->driver_data)
+		i8k_fan_mult = (unsigned long)id->driver_data;
+
 	return 0;
 }
 
-- 
1.7.9.7

