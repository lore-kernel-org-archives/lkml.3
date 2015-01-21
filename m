Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbbAUXRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:17:47 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38770 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbbAUXRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:17:38 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Heiko Stuebner <heiko@sntech.de>, Lunxue Dai <lunxue.dai@rock-chips.com>,
        Jisheng Zhang <jszhang@marvell.com>, Dinh Nguyen <dinguyen@altera.com>,
        Doug Anderson <dianders@chromium.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling it
Date: Wed, 21 Jan 2015 15:17:22 -0800
Message-Id: <1421882243-3631-1-git-send-email-dianders@chromium.org>
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

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/watchdog/dw_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index b34a2e4..fc92bea 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -170,6 +170,7 @@ static int dw_wdt_open(struct inode *inode, struct file *filp)
 		 * the maximum and then start it.
 		 */
 		dw_wdt_set_top(DW_WDT_MAX_TOP);
+		dw_wdt_keepalive();
 		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
 		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
 	}
-- 
2.2.0.rc0.207.ga3a616c

