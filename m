Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbaGVWcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:32:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaGVW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gabor Juhos <juhosg@openwrt.org>, Wim Van Sebroeck <wim@iguana.be>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 074/116] watchdog: ath79_wdt: avoid spurious restarts on AR934x
Date: Tue, 22 Jul 2014 15:21:25 -0700
Message-Id: <1406067727-19683-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/watchdog/ath79_wdt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 38a999e..bb242bd 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -20,6 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -77,6 +78,15 @@ static inline void ath79_wdt_keepalive(void)
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
 	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_FCR);
 	/* flush write */
 	ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
-- 
1.9.1

