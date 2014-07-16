Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaGPTqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:46:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaGPTqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:46:09 -0400
Date: Wed, 16 Jul 2014 12:45:57 -0700
From: tip-bot for Vivien Didelot <tipbot@zytor.com>
Message-ID: <tip-832fcc899a90cce54eb5e47c7fd099eacc0130da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vivien.didelot@savoirfairelinux.com,
        hpa@zytor.com, mingo@kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, vivien.didelot@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
In-Reply-To: <1404860269-11837-4-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1404860269-11837-4-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/ts5500:
  Add support for TS-5400 boards
Git-Commit-ID: 832fcc899a90cce54eb5e47c7fd099eacc0130da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  832fcc899a90cce54eb5e47c7fd099eacc0130da
Gitweb:     http://git.kernel.org/tip/832fcc899a90cce54eb5e47c7fd099eacc0130da
Author:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>
AuthorDate: Tue, 8 Jul 2014 18:57:49 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 21:17:42 +0200

x86/platform/ts5500: Add support for TS-5400 boards

This patch extends the TS-5500 platform driver to support the
similar Technologic Systems TS-5400 Single Board Computer:

  http://wiki.embeddedarm.com/wiki/TS-5400

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
Link: http://lkml.kernel.org/r/1404860269-11837-4-git-send-email-vivien.didelot@savoirfairelinux.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
