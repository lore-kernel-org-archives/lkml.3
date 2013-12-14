Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3LNRbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:33 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39125 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3LNRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:52 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 13/14] i8k: Stop reading SMM BIOS version during driver probe
Date: Sat, 14 Dec 2013 09:30:20 -0800
Message-Id: <1387042221-3671-14-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't work on Studio, XPS, Vostro, and Precision laptops,
and it doesn't provide any value except to cause confusion when
it does not work. Drop it and always use DMI BIOS version instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |   42 ++----------------------------------------
 1 file changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 67e4256..ce826d9 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -44,7 +44,6 @@
 #define I8K_SMM_GET_TEMP	0x10a3
 #define I8K_SMM_GET_DELL_SIG1	0xfea3
 #define I8K_SMM_GET_DELL_SIG2	0xffa3
-#define I8K_SMM_BIOS_VERSION	0x00a6
 
 #define I8K_FAN_MULT		30
 #define I8K_MAX_TEMP		127
@@ -208,17 +207,6 @@ out:
 }
 
 /*
- * Read the bios version. Return the version as an integer corresponding
- * to the ascii value, for example "A17" is returned as 0x00413137.
- */
-static int i8k_get_bios_version(void)
-{
-	struct smm_regs regs = { .eax = I8K_SMM_BIOS_VERSION, };
-
-	return i8k_smm(&regs) ? : regs.eax;
-}
-
-/*
  * Read the Fn key status.
  */
 static int i8k_get_fn_status(void)
@@ -355,7 +343,8 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
-		val = i8k_get_bios_version();
+		val = (bios_version[0] << 16) |
+				(bios_version[1] << 8) | bios_version[2];
 		break;
 
 	case I8K_MACHINE_ID:
@@ -710,8 +699,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
  */
 static int __init i8k_probe(void)
 {
-	char buff[4];
-	int version;
 	const struct dmi_system_id *id;
 
 	/*
@@ -741,31 +728,6 @@ static int __init i8k_probe(void)
 			return -ENODEV;
 	}
 
-	/*
-	 * Get SMM BIOS version.
-	 */
-	version = i8k_get_bios_version();
-	if (version <= 0) {
-		pr_warn("unable to get SMM BIOS version\n");
-	} else {
-		buff[0] = (version >> 16) & 0xff;
-		buff[1] = (version >> 8) & 0xff;
-		buff[2] = (version) & 0xff;
-		buff[3] = '\0';
-		/*
-		 * If DMI BIOS version is unknown use SMM BIOS version.
-		 */
-		if (!dmi_get_system_info(DMI_BIOS_VERSION))
-			strlcpy(bios_version, buff, sizeof(bios_version));
-
-		/*
-		 * Check if the two versions match.
-		 */
-		if (strncmp(buff, bios_version, sizeof(bios_version)) != 0)
-			pr_warn("BIOS version mismatch: %s != %s\n",
-				buff, bios_version);
-	}
-
 	i8k_fan_mult = fan_mult;
 	id = dmi_first_match(i8k_dmi_table);
 	if (id && fan_mult == I8K_FAN_MULT && id->driver_data)
-- 
1.7.9.7

