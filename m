Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161916Ab3BOM6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:34 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56999 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161837Ab3BOM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/35] mfd: ab8500-core: Show turn on status at boot
Date: Fri, 15 Feb 2013 12:57:00 +0000
Message-Id: <1360933026-30325-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

Several states can be detected when a device is initially turned on.
This patch displays these states in the log. If none of the states
are true, then we report that too.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 17187c3..153e71e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1502,6 +1502,15 @@ static int ab8500_probe(struct platform_device *pdev)
 		"Battery level lower than power on reset threshold",
 		"Power on key 1 pressed longer than 10 seconds",
 		"DB8500 thermal shutdown"};
+	static char *turn_on_status[] = {
+		"Battery rising (Vbat)",
+		"Power On Key 1 dbF",
+		"Power On Key 2 dbF",
+		"RTC Alarm",
+		"Main Charger Detect",
+		"Vbus Detect (USB)",
+		"USB ID Detect",
+		"UART Factory Mode Detect"};
 	struct ab8500_platform_data *plat = dev_get_platdata(&pdev->dev);
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	enum ab8500_version version = AB8500_VERSION_UNDEFINED;
@@ -1615,9 +1624,26 @@ static int ab8500_probe(struct platform_device *pdev)
 	} else {
 		printk(KERN_CONT " None\n");
 	}
+	ret = get_register_interruptible(ab8500, AB8500_SYS_CTRL1_BLOCK,
+		AB8500_TURN_ON_STATUS, &value);
+	if (ret < 0)
+		return ret;
+	dev_info(ab8500->dev, "turn on reason(s) (%#x): ", value);
+
+	if (value) {
+		for (i = 0; i < ARRAY_SIZE(turn_on_status); i++) {
+			if (value & 1)
+				printk("\"%s\" ", turn_on_status[i]);
+			value = value >> 1;
+		}
+		printk("\n");
+	} else {
+		printk("None\n");
+	}
 
 	if (plat && plat->init)
 		plat->init(ab8500);
+
 	if (is_ab9540(ab8500)) {
 		ret = get_register_interruptible(ab8500, AB8500_CHARGER,
 			AB8500_CH_USBCH_STAT1_REG, &value);
-- 
1.7.10.4

