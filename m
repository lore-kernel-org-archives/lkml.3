Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3CEEzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:55:52 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52528 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274Ab3CEEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:54:38 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 04 Mar 2013 22:54:33 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6/8] watchdog: w83627hf: Add support for additional chips
Date: Mon,  4 Mar 2013 20:54:17 -0800
Message-Id: <1362459259-9733-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
References: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W83667HG-B, NCT6775, NCT6776 have the same watchdog registers as the
other supported chips but require a slightly different initialization.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig        |   18 ++++++++++++++----
 drivers/watchdog/w83627hf_wdt.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index dd462af..346bc70 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -854,13 +854,23 @@ config VIA_WDT
 	Most people will say N.
 
 config W83627HF_WDT
-	tristate "W83627HF/W83627DHG Watchdog Timer"
+	tristate "Watchdog timer for W83627HF/W83627DHG and compatibles"
 	depends on X86
 	select WATCHDOG_CORE
 	---help---
-	  This is the driver for the hardware watchdog on the W83627HF chipset
-	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
-	  (and likely others). The driver also supports the W83627DHG chip.
+	  This is the driver for the hardware watchdog on the following
+	  Super I/O chips.
+		W83627DHG
+	  	W83627HF
+		W83627EHF
+		W83627THF
+		W83627UHG
+		W83637HF
+		W83667HG-B
+		W83687THF
+		NCT6775
+		NCT6776
+
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 3a2ba30..b23f296 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -47,7 +47,7 @@
 static int wdt_io;
 
 enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
-	     w83627uhg };
+	     w83627uhg, w83667hg_b, nct6775, nct6776 };
 
 /*
  *	Kernel methods.
@@ -67,6 +67,9 @@ enum chips { w83627hf, w83637hf, w83627thf, w83687thf, w83627ehf, w83627dhg,
 #define W83627EHF_ID		0x88
 #define W83627DHG_ID		0xa0
 #define W83627UHG_ID		0xa2
+#define W83667HG_B_ID		0xb3
+#define NCT6775_ID		0xb4
+#define NCT6776_ID		0xc3
 
 static void superio_outb(int reg, int val)
 {
@@ -130,6 +133,18 @@ static void w83627hf_init(enum chips chip)
 	case w83637hf:
 	case w83687thf:
 		break;
+	case w83667hg_b:
+	case nct6775:
+	case nct6776:
+		/*
+		 * These chips support more than one WDTO# output pin.
+		 * Don't touch it, and hope the BIOS does the right thing.
+		 */
+		t = superio_inb(0xF5);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(0xF5, t);
+		break;
 	default:
 		break;
 	}
@@ -268,6 +283,15 @@ static int wdt_find(int addr)
 	case W83627UHG_ID:
 		ret = w83627uhg;
 		break;
+	case W83667HG_B_ID:
+		ret = w83667hg_b;
+		break;
+	case NCT6775_ID:
+		ret = nct6775;
+		break;
+	case NCT6776_ID:
+		ret = nct6776;
+		break;
 	case 0xff:
 		break;
 	default:
@@ -291,6 +315,9 @@ static int __init wdt_init(void)
 		"W83627EHF",
 		"W83627DHG",
 		"W83627UHG",
+		"W83667HG-B",
+		"NCT6775",
+		"NCT6776",
 	};
 
 	wdt_io = 0x2e;
-- 
1.7.9.7

