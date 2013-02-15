Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161655Ab3BOMuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:50:40 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56079 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161311Ab3BOMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rabin Vincent <rabin.vincent@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/40] ab8500-charger: Run detect workaround only on AB8500
Date: Fri, 15 Feb 2013 12:44:59 +0000
Message-Id: <1360932310-30065-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Only AB8500 has this hardware bug, so these works only need to be run
there.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 64accb2..8530028 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -441,7 +441,8 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 			mutex_lock(&di->charger_attached_mutex);
 			mutex_unlock(&di->charger_attached_mutex);
 
-			queue_delayed_work(di->charger_wq,
+			if (is_ab8500(di->parent))
+				queue_delayed_work(di->charger_wq,
 					   &di->usb_charger_attached_work,
 					   HZ);
 		} else {
@@ -2622,7 +2623,9 @@ static irqreturn_t ab8500_charger_mainchplugdet_handler(int irq, void *_di)
 
 	mutex_lock(&di->charger_attached_mutex);
 	mutex_unlock(&di->charger_attached_mutex);
-	queue_delayed_work(di->charger_wq,
+
+	if (is_ab8500(di->parent))
+		queue_delayed_work(di->charger_wq,
 			   &di->ac_charger_attached_work,
 			   HZ);
 	return IRQ_HANDLED;
@@ -3690,14 +3693,16 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	ch_stat = ab8500_charger_detect_chargers(di, false);
 
 	if ((ch_stat & AC_PW_CONN) == AC_PW_CONN) {
-		queue_delayed_work(di->charger_wq,
-				   &di->ac_charger_attached_work,
-				   HZ);
+		if (is_ab8500(di->parent))
+			queue_delayed_work(di->charger_wq,
+					   &di->ac_charger_attached_work,
+					   HZ);
 	}
 	if ((ch_stat & USB_PW_CONN) == USB_PW_CONN) {
-		queue_delayed_work(di->charger_wq,
-				   &di->usb_charger_attached_work,
-				   HZ);
+		if (is_ab8500(di->parent))
+			queue_delayed_work(di->charger_wq,
+					   &di->usb_charger_attached_work,
+					   HZ);
 	}
 
 	mutex_unlock(&di->charger_attached_mutex);
-- 
1.7.10.4

