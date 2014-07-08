Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaGHXHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:07:15 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:51220 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaGHXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:07:12 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
Subject: [PATCH 3/3] x86: (ts5500) add support for TS-5400
Date: Tue,  8 Jul 2014 18:57:49 -0400
Message-Id: <1404860269-11837-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the TS-5500 platform driver to support the similar
Technologic Systems TS-5400 Single Board Computer.

http://wiki.embeddedarm.com/wiki/TS-5400

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/ts5500.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 4eb8eea..baf16e7 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -15,8 +15,8 @@
  * state or available options. For further information about sysfs entries, see
  * Documentation/ABI/testing/sysfs-platform-ts5500.
  *
- * This code actually supports the TS-5500 platform, but it may be extended to
- * support similar Technologic Systems x86-based platforms, such as the TS-5600.
+ * This code may be extended to support similar x86-based platforms.
+ * Actually, the TS-5500 and TS-5400 are supported.
  */
 
 #include <linux/delay.h>
@@ -32,6 +32,7 @@
 /* Product code register */
 #define TS5500_PRODUCT_CODE_ADDR	0x74
 #define TS5500_PRODUCT_CODE		0x60	/* TS-5500 product code */
+#define TS5400_PRODUCT_CODE		0x40	/* TS-5400 product code */
 
 /* SRAM/RS-485/ADC options, and RS-485 RTS/Automatic RS-485 flags register */
 #define TS5500_SRAM_RS485_ADC_ADDR	0x75
@@ -127,6 +128,8 @@ static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
 	sbc->id = inb(TS5500_PRODUCT_CODE_ADDR);
 	if (sbc->id == TS5500_PRODUCT_CODE) {
 		sbc->name = "TS-5500";
+	} else if (sbc->id == TS5400_PRODUCT_CODE) {
+		sbc->name = "TS-5400";
 	} else {
 		pr_err("ts5500: unknown product code 0x%x\n", sbc->id);
 		ret = -ENODEV;
@@ -318,12 +321,14 @@ static int __init ts5500_init(void)
 	if (err)
 		goto error;
 
-	ts5500_dio1_pdev.dev.parent = &pdev->dev;
-	if (platform_device_register(&ts5500_dio1_pdev))
-		dev_warn(&pdev->dev, "DIO1 block registration failed\n");
-	ts5500_dio2_pdev.dev.parent = &pdev->dev;
-	if (platform_device_register(&ts5500_dio2_pdev))
-		dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+	if (sbc->id == TS5500_PRODUCT_CODE) {
+		ts5500_dio1_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_dio1_pdev))
+			dev_warn(&pdev->dev, "DIO1 block registration failed\n");
+		ts5500_dio2_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_dio2_pdev))
+			dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+	}
 
 	if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
 		dev_warn(&pdev->dev, "LED registration failed\n");
-- 
1.9.1

