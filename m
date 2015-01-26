Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbbAZQyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:54:14 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:59786 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAZQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:54:09 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] watchdog: w83627hf_wdt: Add support for NCT6791 and NCT6792
Date: Mon, 26 Jan 2015 08:53:56 -0800
Message-Id: <1422291236-13326-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C67131.005F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog functionality in both chips is almost identical to NCT6779.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Tested on system with NCT6792.

 drivers/watchdog/Kconfig        |  2 ++
 drivers/watchdog/w83627hf_wdt.c | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 08f41ad..97ac488 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1005,6 +1005,8 @@ config W83627HF_WDT
 		NCT6775
 		NCT6776
 		NCT6779
+		NCT6791
+		NCT6792
 
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 7165704..5824e25 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -50,7 +50,7 @@ static int cr_wdt_control;	/* WDT control register */
 
 enum chips { w83627hf, w83627s, w83697hf, w83697ug, w83637hf, w83627thf,
 	     w83687thf, w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p,
-	     w83667hg_b, nct6775, nct6776, nct6779 };
+	     w83667hg_b, nct6775, nct6776, nct6779, nct6791, nct6792 };
 
 static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
@@ -95,6 +95,8 @@ MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=0)");
 #define NCT6775_ID		0xb4
 #define NCT6776_ID		0xc3
 #define NCT6779_ID		0xc5
+#define NCT6791_ID		0xc8
+#define NCT6792_ID		0xc9
 
 #define W83627HF_WDT_TIMEOUT	0xf6
 #define W83697HF_WDT_TIMEOUT	0xf4
@@ -195,6 +197,8 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 	case nct6775:
 	case nct6776:
 	case nct6779:
+	case nct6791:
+	case nct6792:
 		/*
 		 * These chips have a fixed WDTO# output pin (W83627UHG),
 		 * or support more than one WDTO# output pin.
@@ -395,6 +399,12 @@ static int wdt_find(int addr)
 	case NCT6779_ID:
 		ret = nct6779;
 		break;
+	case NCT6791_ID:
+		ret = nct6791;
+		break;
+	case NCT6792_ID:
+		ret = nct6792;
+		break;
 	case 0xff:
 		ret = -ENODEV;
 		break;
@@ -428,6 +438,8 @@ static int __init wdt_init(void)
 		"NCT6775",
 		"NCT6776",
 		"NCT6779",
+		"NCT6791",
+		"NCT6792",
 	};
 
 	wdt_io = 0x2e;
-- 
2.1.0

