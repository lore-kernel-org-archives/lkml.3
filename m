Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbaGRNVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:21:00 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17993 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030886AbaGRNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
        Wim Van Sebroeck <wim@iguana.be>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/170] watchdog: ath79_wdt: avoid spurious restarts on AR934x
Date: Fri, 18 Jul 2014 14:10:29 +0200
Message-Id: <17178d1a8770860f2ea6aa48413b77102e45edf9.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 23afeb613ec0e10aecfae7838a14d485db62ac52 upstream.

On some AR934x based systems, where the frequency of
the AHB bus is relatively high, the built-in watchdog
causes a spurious restart when it gets enabled.

The possible cause of these restarts is that the timeout
value written into the TIMER register does not reaches
the hardware in time.

Add an explicit delay into the ath79_wdt_enable function
to avoid the spurious restarts.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/watchdog/ath79_wdt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 37cb09b27b63..c97a47ca8971 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -20,6 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -91,6 +92,15 @@ static inline void ath79_wdt_keepalive(void)
 static inline void ath79_wdt_enable(void)
 {
 	ath79_wdt_keepalive();
+
+	/*
+	 * Updating the TIMER register requires a few microseconds
+	 * on the AR934x SoCs at least. Use a small delay to ensure
+	 * that the TIMER register is updated within the hardware
+	 * before enabling the watchdog.
+	 */
+	udelay(2);
+
 	ath79_wdt_wr(WDOG_REG_CTRL, WDOG_CTRL_ACTION_FCR);
 	/* flush write */
 	ath79_wdt_rr(WDOG_REG_CTRL);
-- 
2.0.0

