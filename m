Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161691Ab3BOMwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:52:00 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54186 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161441Ab3BOMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/40] abx500-chargalg: Prevent the watchdog from being kicked twice
Date: Fri, 15 Feb 2013 12:44:54 +0000
Message-Id: <1360932310-30065-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charging watchdog kicker work-thread gets started twice causing
'failed to kick watchdog' message after removing charger and
when re-inserting charger. This patch removes the superfluous
start of watchdog kicker-thread.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index a9b8efd..e23b92a 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -689,8 +689,6 @@ static void abx500_chargalg_hold_charging(struct abx500_chargalg *di)
 static void abx500_chargalg_start_charging(struct abx500_chargalg *di,
 	int vset, int iset)
 {
-	bool start_chargalg_wd = true;
-
 	switch (di->chg_info.charger_type) {
 	case AC_CHG:
 		dev_dbg(di->dev,
@@ -708,12 +706,8 @@ static void abx500_chargalg_start_charging(struct abx500_chargalg *di,
 
 	default:
 		dev_err(di->dev, "Unknown charger to charge from\n");
-		start_chargalg_wd = false;
 		break;
 	}
-
-	if (start_chargalg_wd && !delayed_work_pending(&di->chargalg_wd_work))
-		queue_delayed_work(di->chargalg_wq, &di->chargalg_wd_work, 0);
 }
 
 /**
-- 
1.7.10.4

