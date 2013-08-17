Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3HQU7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:59:01 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63884 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3HQU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:58:59 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 3/8] watchdog: w83627hf: Enable watchdog device only if not already enabled
Date: Sat, 17 Aug 2013 13:58:41 -0700
Message-Id: <1376773126-2717-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to enable the watchdog device if it is already enabled.
Also, when enabling the watchdog device, only set the watchdog device
enable bit and do not touch other bits; depending on the chip type,
those bits may enable other functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/w83627hf_wdt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index bb19368..13bad31 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -101,7 +101,9 @@ static void w83627hf_init(struct watchdog_device *wdog)
 	}
 
 	outb_p(0x30, WDT_EFER); /* select CR30 */
-	outb_p(0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+	t = inb(WDT_EFDR);
+	if (!(t & 0x01))
+		outb_p(t | 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
 
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
-- 
1.7.9.7

