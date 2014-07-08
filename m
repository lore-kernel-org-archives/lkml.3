Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaGHTT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54239 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gabor Juhos" <juhosg@openwrt.org>,
        "Wim Van Sebroeck" <wim@iguana.be>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.265133886@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/125] watchdog: ath79_wdt: avoid spurious restarts
 on AR934x
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/watchdog/ath79_wdt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -73,6 +74,15 @@ static inline void ath79_wdt_keepalive(v
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
 }
 

