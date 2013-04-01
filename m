Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3DAF7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:59:49 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:56559 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab3DAF7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:59:44 -0400
From: Tony Chung <tonychung00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Chung <tonychung00@gmail.com>
Subject: [PATCH v3 2/2] watchdog: fix w83627hf_wdt  clear timeout expired
Date: Sun, 31 Mar 2013 22:59:32 -0700
Message-Id: <1364795972-8649-2-git-send-email-tonychung00@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
References: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed that the w83627hf watchdog timer start counting during reboot.
If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.
For example, fsck took more than 5 minutes to run, then the computer reboot as soon as the driver was loaded.

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

