Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3KIRvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:51:48 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49788 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3KIRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:51:18 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/3] hwmon: (coretemp) Refine TjMax detection
Date: Sat,  9 Nov 2013 09:51:09 -0800
Message-Id: <1384019469-18666-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1384019469-18666-1-git-send-email-linux@roeck-us.net>
References: <1384019469-18666-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel's turbostat code uses only 7 bits from MSR_IA32_TEMPERATURE_TARGET to
read TjMax, and also only accepts it if the reported temperature is at least
85 degrees C. Play safe and do the same.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/coretemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index cde4e47..310ce19 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -368,12 +368,12 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 		if (cpu_has_tjmax(c))
 			dev_warn(dev, "Unable to read TjMax from CPU %u\n", id);
 	} else {
-		val = (eax >> 16) & 0xff;
+		val = (eax >> 16) & 0x7f;
 		/*
 		 * If the TjMax is not plausible, an assumption
 		 * will be used
 		 */
-		if (val) {
+		if (val >= 85) {
 			dev_dbg(dev, "TjMax is %d degrees C\n", val);
 			return val * 1000;
 		}
-- 
1.7.9.7

