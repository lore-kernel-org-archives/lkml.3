Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3BKQ2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/11] extcon: arizona: Add some debounce time before starting HPDET identification
Date: Mon, 11 Feb 2013 16:27:02 +0000
Message-Id: <1360600026-16878-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HPDET identification method does not have the same natural debounce
built into it that the standard MICDET method does so add some extra on
top of what the jack detection does in hardware to make sure we get a
robust result.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c17a41f..2ad0e4a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -53,6 +53,8 @@ struct arizona_extcon_info {
 	bool micd_reva;
 	bool micd_clamp;
 
+	struct delayed_work hpdet_work;
+
 	bool hpdet_active;
 
 	int num_hpdet_res;
@@ -640,7 +642,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 	dev_dbg(arizona->dev, "Starting identification via HPDET\n");
 
 	/* Make sure we keep the device enabled during the measurement */
-	pm_runtime_get(info->dev);
+	pm_runtime_get_sync(info->dev);
 
 	info->hpdet_active = true;
 
@@ -813,6 +815,17 @@ handled:
 	return IRQ_HANDLED;
 }
 
+static void arizona_hpdet_work(struct work_struct *work)
+{
+	struct arizona_extcon_info *info = container_of(work,
+							struct arizona_extcon_info,
+							hpdet_work.work);
+
+	mutex_lock(&info->lock);
+	arizona_start_hpdet_acc_id(info);
+	mutex_unlock(&info->lock);
+}
+
 static irqreturn_t arizona_jackdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
@@ -822,6 +835,8 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 	pm_runtime_get_sync(info->dev);
 
+	cancel_delayed_work_sync(&info->hpdet_work);
+
 	mutex_lock(&info->lock);
 
 	if (arizona->pdata.jd_gpio5) {
@@ -857,7 +872,8 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 			arizona_start_mic(info);
 		} else {
-			arizona_start_hpdet_acc_id(info);
+			schedule_delayed_work(&info->hpdet_work,
+					      msecs_to_jiffies(250));
 		}
 
 		regmap_update_bits(arizona->regmap,
@@ -927,6 +943,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->arizona = arizona;
 	info->dev = &pdev->dev;
+	INIT_DELAYED_WORK(&info->hpdet_work, arizona_hpdet_work);
 	platform_set_drvdata(pdev, info);
 
 	switch (arizona->type) {
@@ -1173,6 +1190,7 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
 	arizona_free_irq(arizona, jack_irq_rise, info);
 	arizona_free_irq(arizona, jack_irq_fall, info);
+	cancel_delayed_work_sync(&info->hpdet_work);
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-- 
1.7.10.4

