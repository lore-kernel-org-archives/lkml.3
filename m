Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3CaCHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 22:07:04 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:51785 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3CaCHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 22:07:01 -0400
From: Tony Chung <tonychung00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Chung <tonychung00@gmail.com>
Subject: [PATCHv2 2/2] watchdog: fix w83627hf_wdt reboot due to timeout expired
Date: Sat, 30 Mar 2013 18:59:08 -0700
Message-Id: <1364695148-5605-2-git-send-email-tonychung00@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1364695148-5605-1-git-send-email-tonychung00@gmail.com>
References: <1364695148-5605-1-git-send-email-tonychung00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed that the w83627hf watchdog timer start counting during reboot.
If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.
For example, fsck took more than 5 minutes to run, then reboot will occurred.

Signed-off-by: Tony Chung <tonychung00@gmail.com>
---
 drivers/watchdog/w83627hf_wdt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 8f1111d..47eb233 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -174,6 +174,11 @@ static void w83627hf_init(void)
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
 	t = inb_p(WDT_EFDR);      /* read CRF7 */
+	if (t & 0x10) {
+		pr_info("Watchdog Timer timeout occurred!");
+		t &= ~0x10; /* clear the event */
+		pr_info("Event cleared\n");
+	}
 	t &= ~0xC0;               /* disable keyboard & mouse turning off
 				    watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
-- 
1.7.0.4

