Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab3DDEkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:40:15 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:48553 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3DDEj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:39:57 -0400
From: Tony Chung <tonychung00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Chung <tonychung00@gmail.com>
Subject: [PATCH v4 2/2] watchdog: fix w83627hf_wdt  clear timeout expired
Date: Wed,  3 Apr 2013 21:39:44 -0700
Message-Id: <1365050384-9130-2-git-send-email-tonychung00@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1365050384-9130-1-git-send-email-tonychung00@gmail.com>
References: <1365050384-9130-1-git-send-email-tonychung00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Observed that the Watchdog Timer Status bit can be set when the driver is
loaded. Reset it during initialization. The time-out value must be set to 0
explicitly in this case to prevent an immediate reset.

Depending on the motherboard and with watchdog disabled in the BIOS, this reset problem can easily be reproduced by the following steps:
1.  reboot the system 
2.  wait for 5+ minutes 
3.  don't start any watchdog server.
4.  just run "modprobe w83627hf_wdt"

If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.  For example, fsck could take more than 5 minutes to run, 
then the computer reboot as soon as the driver was loaded.

Signed-off-by: Tony Chung <tonychung00@gmail.com>
---
 drivers/watchdog/w83627hf_wdt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 8f1111d..7eaa226 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -168,14 +168,16 @@ static void w83627hf_init(void)
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
 			wdt_get_timeout_secs(timeout));
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
+	} else {
+		outb_p(0, WDT_EFDR);    /* disable to prevent reboot */
 	}
 
 	w83627hf_setup_crf5();
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
 	t = inb_p(WDT_EFDR);      /* read CRF7 */
-	t &= ~0xC0;               /* disable keyboard & mouse turning off
-				    watchdog */
+	t &= ~0xD0;               /* clear timeout occurred and disable keyboard
+				     & mouse turning off watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
 
 	w83627hf_unselect_wd_register();
-- 
1.7.0.4

