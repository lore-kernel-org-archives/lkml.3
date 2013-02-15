Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161583Ab3BOMrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:47:15 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:63275 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161570Ab3BOMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:47:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 40/40] ab8500-charger: Do not use [delayed_]work_pending()
Date: Fri, 15 Feb 2013 12:45:10 +0000
Message-Id: <1360932310-30065-41-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item is pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 81c9615..a558318 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1661,8 +1661,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 		dev_dbg(di->dev, "%s Disabled USB charging\n", __func__);
 
 		/* Cancel any pending Vbat check work */
-		if (delayed_work_pending(&di->check_vbat_work))
-			cancel_delayed_work(&di->check_vbat_work);
+		cancel_delayed_work(&di->check_vbat_work);
 
 	}
 	ab8500_power_supply_changed(di, &di->usb_chg.psy);
@@ -3335,11 +3334,8 @@ static int ab8500_charger_resume(struct platform_device *pdev)
 			dev_err(di->dev, "Failed to kick WD!\n");
 
 		/* If not already pending start a new timer */
-		if (!delayed_work_pending(
-			&di->kick_wd_work)) {
-			queue_delayed_work(di->charger_wq, &di->kick_wd_work,
-				round_jiffies(WD_KICK_INTERVAL));
-		}
+		queue_delayed_work(di->charger_wq, &di->kick_wd_work,
+				   round_jiffies(WD_KICK_INTERVAL));
 	}
 
 	/* If we still have a HW failure, schedule a new check */
@@ -3359,12 +3355,9 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
 {
 	struct ab8500_charger *di = platform_get_drvdata(pdev);
 
-	/* Cancel any pending HW failure check */
-	if (delayed_work_pending(&di->check_hw_failure_work))
-		cancel_delayed_work(&di->check_hw_failure_work);
-
-	if (delayed_work_pending(&di->vbus_drop_end_work))
-		cancel_delayed_work(&di->vbus_drop_end_work);
+	/* Cancel any pending jobs */
+	cancel_delayed_work(&di->check_hw_failure_work);
+	cancel_delayed_work(&di->vbus_drop_end_work);
 
 	flush_delayed_work(&di->attach_work);
 	flush_delayed_work(&di->usb_charger_attached_work);
-- 
1.7.10.4

