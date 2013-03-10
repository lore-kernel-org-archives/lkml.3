Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3CJXPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:15:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55237 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3CJXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:15:07 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 10 Mar 2013 18:15:05 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 3/7] watchdog: w83627hf: Enable watchdog device only if not already enabled
Date: Sun, 10 Mar 2013 16:14:56 -0700
Message-Id: <1362957300-18223-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to enable the watchdog device if it is already enabled.
Also, when enabling the watchdog device, only set the watchdog device
enable bit and do not touch other bits; depending on the chip type,
those bits may enable other functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: No change

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

