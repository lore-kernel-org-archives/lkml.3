Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3GMA61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:58:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:27989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab3GMA6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,656,1367996400"; 
   d="scan'208";a="369464358"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/3] pch_uart: Use DMI interface for board detection
Date: Fri, 12 Jul 2013 17:58:05 -0700
Message-Id: <ce5dd365d05f8747d269aa74e0bb929935d9cdee.1373676797.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
References: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the DMI interface rather than manually matching DMI strings.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Michael Brunner <mibru@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c | 71 +++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 572d481..271cc73 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -373,35 +373,62 @@ static const struct file_operations port_regs_ops = {
 };
 #endif	/* CONFIG_DEBUG_FS */
 
+static struct dmi_system_id __initdata pch_uart_dmi_table[] = {
+	{
+		.ident = "CM-iTC",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "CM-iTC"),
+		},
+		(void *)CMITC_UARTCLK,
+	},
+	{
+		.ident = "FRI2",
+		{
+			DMI_MATCH(DMI_BIOS_VERSION, "FRI2"),
+		},
+		(void *)FRI2_64_UARTCLK,
+	},
+	{
+		.ident = "Fish River Island II",
+		{
+			DMI_MATCH(DMI_PRODUCT_NAME, "Fish River Island II"),
+		},
+		(void *)FRI2_48_UARTCLK,
+	},
+	{
+		.ident = "COMe-mTT",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mTT"),
+		},
+		(void *)NTC1_UARTCLK,
+	},
+	{
+		.ident = "nanoETXexpress-TT",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-TT"),
+		},
+		(void *)NTC1_UARTCLK,
+	},
+	{
+		.ident = "MinnowBoard",
+		{
+			DMI_MATCH(DMI_BOARD_NAME, "MinnowBoard"),
+		},
+		(void *)MINNOW_UARTCLK,
+	},
+};
+
 /* Return UART clock, checking for board specific clocks. */
 static int pch_uart_get_uartclk(void)
 {
-	const char *cmp;
+	const struct dmi_system_id *d;
 
 	if (user_uartclk)
 		return user_uartclk;
 
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && strstr(cmp, "CM-iTC"))
-		return CMITC_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
-	if (cmp && strnstr(cmp, "FRI2", 4))
-		return FRI2_64_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (cmp && strstr(cmp, "Fish River Island II"))
-		return FRI2_48_UARTCLK;
-
-	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && (strstr(cmp, "COMe-mTT") ||
-		    strstr(cmp, "nanoETXexpress-TT")))
-		return NTC1_UARTCLK;
-
-	cmp = dmi_get_system_info(DMI_BOARD_NAME);
-	if (cmp && strstr(cmp, "MinnowBoard"))
-		return MINNOW_UARTCLK;
+	d = dmi_first_match(pch_uart_dmi_table);
+	if (d)
+		return (int)d->driver_data;
 
 	return DEFAULT_UARTCLK;
 }
-- 
1.8.3.1

