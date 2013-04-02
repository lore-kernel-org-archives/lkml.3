Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab3DBLfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:35:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760181Ab3DBLdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/16] extcon: arizona: Suppress duplicate JACKDET reports
Date: Tue,  2 Apr 2013 12:32:39 +0100
Message-Id: <1364902368-1123-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cases where we see a brief (dis)connection of the jack detection signals
we may see a noop jack insertion or removal where the jack has returned to
the original state by the time the interrupt is serviced. Suppress these
events in order to save work and avoid confusing the rest of the code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 2f0bd49..9e4bffe 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -39,6 +39,8 @@
 #define ARIZONA_ACCDET_MODE_HPL 1
 #define ARIZONA_ACCDET_MODE_HPR 2
 
+#define HPDET_DEBOUNCE 250
+
 struct arizona_extcon_info {
 	struct device *dev;
 	struct arizona *arizona;
@@ -46,6 +48,8 @@ struct arizona_extcon_info {
 	struct regulator *micvdd;
 	struct input_dev *input;
 
+	u16 last_jackdet;
+
 	int micd_mode;
 	const struct arizona_micd_config *micd_modes;
 	int micd_num_modes;
@@ -871,11 +875,12 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
 	unsigned int val, present, mask;
+	bool cancelled;
 	int ret, i;
 
-	pm_runtime_get_sync(info->dev);
+	cancelled = cancel_delayed_work_sync(&info->hpdet_work);
 
-	cancel_delayed_work_sync(&info->hpdet_work);
+	pm_runtime_get_sync(info->dev);
 
 	mutex_lock(&info->lock);
 
@@ -896,7 +901,18 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if ((val & mask) == present) {
+	val &= mask;
+	if (val == info->last_jackdet) {
+		dev_dbg(arizona->dev, "Suppressing duplicate JACKDET\n");
+		if (cancelled)
+			schedule_delayed_work(&info->hpdet_work,
+					      msecs_to_jiffies(HPDET_DEBOUNCE));
+
+		goto out;
+	}
+	info->last_jackdet = val;
+
+	if (info->last_jackdet == present) {
 		dev_dbg(arizona->dev, "Detected jack\n");
 		ret = extcon_set_cable_state_(&info->edev,
 					      ARIZONA_CABLE_MECHANICAL, true);
@@ -913,7 +929,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 			arizona_start_mic(info);
 		} else {
 			schedule_delayed_work(&info->hpdet_work,
-					      msecs_to_jiffies(250));
+					      msecs_to_jiffies(HPDET_DEBOUNCE));
 		}
 
 		regmap_update_bits(arizona->regmap,
@@ -953,6 +969,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		     ARIZONA_JD1_FALL_TRIG_STS |
 		     ARIZONA_JD1_RISE_TRIG_STS);
 
+out:
 	mutex_unlock(&info->lock);
 
 	pm_runtime_mark_last_busy(info->dev);
@@ -1012,6 +1029,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->arizona = arizona;
 	info->dev = &pdev->dev;
+	info->last_jackdet = ~(ARIZONA_MICD_CLAMP_STS | ARIZONA_JD1_STS);
 	INIT_DELAYED_WORK(&info->hpdet_work, arizona_hpdet_work);
 	platform_set_drvdata(pdev, info);
 
-- 
1.7.10.4

