Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437Ab3DBLdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46564 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760243Ab3DBLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 13/16] extcon: arizona: Time out if MICDET fails to report
Date: Tue,  2 Apr 2013 12:32:45 +0100
Message-Id: <1364902368-1123-13-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pathological cases the microphone detection may fail to report, for
example due to a failure to get a stable measurement. Provide a timeout
to cover such cases.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index a83ca27a..e2d881a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -42,6 +42,7 @@
 #define ARIZONA_HPDET_MAX 10000
 
 #define HPDET_DEBOUNCE 500
+#define MICD_TIMEOUT 2000
 
 struct arizona_extcon_info {
 	struct device *dev;
@@ -63,6 +64,7 @@ struct arizona_extcon_info {
 	bool micd_clamp;
 
 	struct delayed_work hpdet_work;
+	struct delayed_work micd_timeout_work;
 
 	bool hpdet_active;
 	bool hpdet_done;
@@ -730,6 +732,24 @@ err:
 	info->hpdet_active = false;
 }
 
+static void arizona_micd_timeout_work(struct work_struct *work)
+{
+	struct arizona_extcon_info *info = container_of(work,
+							struct arizona_extcon_info,
+							micd_timeout_work.work);
+
+	mutex_lock(&info->lock);
+
+	dev_dbg(info->arizona->dev, "MICD timed out, reporting HP\n");
+	arizona_identify_headphone(info);
+
+	info->detecting = false;
+
+	arizona_stop_mic(info);
+
+	mutex_unlock(&info->lock);
+}
+
 static irqreturn_t arizona_micdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
@@ -737,6 +757,8 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	unsigned int val = 0, lvl;
 	int ret, i, key;
 
+	cancel_delayed_work_sync(&info->micd_timeout_work);
+
 	mutex_lock(&info->lock);
 
 	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
@@ -858,6 +880,10 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	}
 
 handled:
+	if (info->detecting)
+		schedule_delayed_work(&info->micd_timeout_work,
+				      msecs_to_jiffies(MICD_TIMEOUT));
+
 	pm_runtime_mark_last_busy(info->dev);
 	mutex_unlock(&info->lock);
 
@@ -880,10 +906,11 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
 	unsigned int val, present, mask;
-	bool cancelled;
+	bool cancelled_hp, cancelled_mic;
 	int ret, i;
 
-	cancelled = cancel_delayed_work_sync(&info->hpdet_work);
+	cancelled_hp = cancel_delayed_work_sync(&info->hpdet_work);
+	cancelled_mic = cancel_delayed_work_sync(&info->micd_timeout_work);
 
 	pm_runtime_get_sync(info->dev);
 
@@ -909,10 +936,14 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	val &= mask;
 	if (val == info->last_jackdet) {
 		dev_dbg(arizona->dev, "Suppressing duplicate JACKDET\n");
-		if (cancelled)
+		if (cancelled_hp)
 			schedule_delayed_work(&info->hpdet_work,
 					      msecs_to_jiffies(HPDET_DEBOUNCE));
 
+		if (cancelled_mic)
+			schedule_delayed_work(&info->micd_timeout_work,
+					      msecs_to_jiffies(MICD_TIMEOUT));
+
 		goto out;
 	}
 	info->last_jackdet = val;
@@ -1037,6 +1068,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->last_jackdet = ~(ARIZONA_MICD_CLAMP_STS | ARIZONA_JD1_STS);
 	INIT_DELAYED_WORK(&info->hpdet_work, arizona_hpdet_work);
+	INIT_DELAYED_WORK(&info->micd_timeout_work, arizona_micd_timeout_work);
 	platform_set_drvdata(pdev, info);
 
 	switch (arizona->type) {
-- 
1.7.10.4

