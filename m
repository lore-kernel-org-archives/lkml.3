Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3AUMJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:09:53 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39898 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3AUMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:30 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/24] ab8500-charger: Kick watchdog
Date: Mon, 21 Jan 2013 12:03:41 +0000
Message-Id: <1358769840-4763-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kicks the watchdog so charging will not stop.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 78b6235..830b2dd 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -603,6 +603,8 @@ static void abx500_chargalg_hold_charging(struct abx500_chargalg *di)
 static void abx500_chargalg_start_charging(struct abx500_chargalg *di,
 	int vset, int iset)
 {
+	bool start_chargalg_wd = true;
+
 	switch (di->chg_info.charger_type) {
 	case AC_CHG:
 		dev_dbg(di->dev,
@@ -620,8 +622,12 @@ static void abx500_chargalg_start_charging(struct abx500_chargalg *di,
 
 	default:
 		dev_err(di->dev, "Unknown charger to charge from\n");
+		start_chargalg_wd = false;
 		break;
 	}
+
+	if (start_chargalg_wd && !delayed_work_pending(&di->chargalg_wd_work))
+		queue_delayed_work(di->chargalg_wq, &di->chargalg_wd_work, 0);
 }
 
 /**
-- 
1.7.9.5

