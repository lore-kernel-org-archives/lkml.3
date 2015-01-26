Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbbAZX10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:27:26 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42030 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbbAZX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:27:23 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Stuebner <heiko@sntech.de>, Lunxue Dai <lunxue.dai@rock-chips.com>,
        Jisheng Zhang <jszhang@marvell.com>, Dinh Nguyen <dinguyen@altera.com>,
        Doug Anderson <dianders@chromium.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] watchdog: dw_wdt: pat the watchdog before enabling it
Date: Mon, 26 Jan 2015 15:27:15 -0800
Message-Id: <1422314836-30516-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some dw_wdt implementations the "top" register may be initted to 0
at bootup.  In such a case, each "pat" of the watchdog will reset the
timer to 0xffff.  That's pretty short.

The input clock of the wdt can be any of a wide range of values.  On
an rk3288 system, I've seen the wdt clock be 24.75 MHz.  That means
each tick is ~40ns and we'll count to 0xffff in ~2.6ms.

Because of the above two facts, it's a really good idea to pat the
watchdog after initting the "top" register properly and before
enabling the watchdog.  If you don't then there's no way we'll get the
next heartbeat in time.

Jisheng Zhang fixed this problem on some dw_mmc versions by using the
TOP_INIT feature.  However, the dw_wdt on rk3288 doesn't have TOP_INIT
so it's a good idea to also pat the watchdog manually.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Add comment about why TOP_INIT doesn't work on rk3288; move pat
  to right next to the attempt to use TOP_INIT.

 drivers/watchdog/dw_wdt.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index b34a2e4..2c24882 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -96,6 +96,12 @@ static inline void dw_wdt_set_next_heartbeat(void)
 	dw_wdt.next_heartbeat = jiffies + dw_wdt_get_top() * HZ;
 }
 
+static void dw_wdt_keepalive(void)
+{
+	writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
+	       WDOG_COUNTER_RESTART_REG_OFFSET);
+}
+
 static int dw_wdt_set_top(unsigned top_s)
 {
 	int i, top_val = DW_WDT_MAX_TOP;
@@ -114,17 +120,18 @@ static int dw_wdt_set_top(unsigned top_s)
 	writel(top_val | top_val << WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT,
 		dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
 
+	/*
+	 * On some versions of dw_wdt writing to TOPINIT counts as a pat
+	 * (kick) of the watchdog; for other version of dw_wdt bits 4-7
+	 * are reserved and we need to pat the watchdog dog manually.
+	 */
+	dw_wdt_keepalive();
+
 	dw_wdt_set_next_heartbeat();
 
 	return dw_wdt_top_in_seconds(top_val);
 }
 
-static void dw_wdt_keepalive(void)
-{
-	writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
-	       WDOG_COUNTER_RESTART_REG_OFFSET);
-}
-
 static int dw_wdt_restart_handle(struct notifier_block *this,
 				unsigned long mode, void *cmd)
 {
-- 
2.2.0.rc0.207.ga3a616c

