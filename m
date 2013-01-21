Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3AUMEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:32 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57223 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3AUME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Bergstrom <martin.bergstrom@stericsson.com>
Subject: [PATCH 03/24] ab8500-fg: Adjust for RF bursts voltage drops
Date: Mon, 21 Jan 2013 12:03:39 +0000
Message-Id: <1358769840-4763-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Changed conditions for restarting low battery measurements counter
and adjusted the interval between measurements to avoid RF burst
induced voltage drops, and to shorten time to decide to shut down.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_fg.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index cd03549..a0cbbd3 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -43,7 +43,7 @@
 
 #define NBR_AVG_SAMPLES			20
 
-#define LOW_BAT_CHECK_INTERVAL		(2 * HZ)
+#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
 
 #define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
 #define BATT_OK_MIN			2360 /* mV */
@@ -169,6 +169,7 @@ struct inst_curr_result_list {
  * @recovery_cnt:	Counter for recovery mode
  * @high_curr_cnt:	Counter for high current mode
  * @init_cnt:		Counter for init mode
+ * @low_bat_cnt		Counter for number of consecutive low battery measures
  * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
  * @recovery_needed:	Indicate if recovery is needed
  * @high_curr_mode:	Indicate if we're in high current mode
@@ -210,6 +211,7 @@ struct ab8500_fg {
 	int recovery_cnt;
 	int high_curr_cnt;
 	int init_cnt;
+	int low_bat_cnt;
 	int nbr_cceoc_irq_cnt;
 	bool recovery_needed;
 	bool high_curr_mode;
@@ -1879,25 +1881,29 @@ static void ab8500_fg_low_bat_work(struct work_struct *work)
 
 	/* Check if LOW_BAT still fulfilled */
 	if (vbat < di->bm->fg_params->lowbat_threshold) {
-		di->flags.low_bat = true;
-		dev_warn(di->dev, "Battery voltage still LOW\n");
-
-		/*
-		 * We need to re-schedule this check to be able to detect
-		 * if the voltage increases again during charging
-		 */
-		queue_delayed_work(di->fg_wq, &di->fg_low_bat_work,
-			round_jiffies(LOW_BAT_CHECK_INTERVAL));
+		/* Is it time to shut down? */
+		if (di->low_bat_cnt < 1) {
+			di->flags.low_bat = true;
+			dev_warn(di->dev, "Shut down pending...\n");
+		} else {
+			/*
+			* Else we need to re-schedule this check to be able to detect
+			* if the voltage increases again during charging or
+			* due to decreasing load.
+			*/
+			di->low_bat_cnt--;
+			dev_warn(di->dev, "Battery voltage still LOW\n");
+			queue_delayed_work(di->fg_wq, &di->fg_low_bat_work,
+				round_jiffies(LOW_BAT_CHECK_INTERVAL));
+		}
 	} else {
-		di->flags.low_bat = false;
+		di->flags.low_bat_delay = false;
+		di->low_bat_cnt = 10;
 		dev_warn(di->dev, "Battery voltage OK again\n");
 	}
 
 	/* This is needed to dispatch LOW_BAT */
 	ab8500_fg_check_capacity_limits(di, false);
-
-	/* Set this flag to check if LOW_BAT IRQ still occurs */
-	di->flags.low_bat_delay = false;
 }
 
 /**
@@ -2056,6 +2062,7 @@ static irqreturn_t ab8500_fg_lowbatf_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
 
+	/* Initiate handling in ab8500_fg_low_bat_work() if not already initiated. */
 	if (!di->flags.low_bat_delay) {
 		dev_warn(di->dev, "Battery voltage is below LOW threshold\n");
 		di->flags.low_bat_delay = true;
@@ -2698,6 +2705,12 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	INIT_DEFERRABLE_WORK(&di->fg_check_hw_failure_work,
 		ab8500_fg_check_hw_failure_work);
 
+	/* Reset battery low voltage flag */
+	di->flags.low_bat = false;
+
+	/* Initialize low battery counter */
+	di->low_bat_cnt = 10;
+
 	/* Initialize OVV, and other registers */
 	ret = ab8500_fg_init_hw_registers(di);
 	if (ret) {
-- 
1.7.9.5

