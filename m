Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3BKQ2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35482 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/11] extcon: arizona: Use MICDET for final microphone identification
Date: Mon, 11 Feb 2013 16:27:06 +0000
Message-Id: <1360600026-16878-11-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using HPDET to identify the accessory still run MICDET before we
report a microphone in order to ensure that the accessory identified is
compatible with the MICDET detection ranges after having confirmed that
the device is not using a headphone.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index d991842..dc357a4 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -56,6 +56,7 @@ struct arizona_extcon_info {
 	struct delayed_work hpdet_work;
 
 	bool hpdet_active;
+	bool hpdet_done;
 
 	int num_hpdet_res;
 	unsigned int hpdet_res[3];
@@ -394,7 +395,6 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 {
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
-	int ret;
 
 	/*
 	 * If we're using HPDET for accessory identification we need
@@ -463,13 +463,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		    (id_gpio && info->hpdet_res[2] > 10)) {
 			dev_dbg(arizona->dev, "Detected mic\n");
 			info->mic = true;
-			ret = extcon_set_cable_state_(&info->edev,
-						      ARIZONA_CABLE_MICROPHONE,
-						      true);
-			if (ret != 0) {
-				dev_err(arizona->dev,
-					"Failed to report mic: %d\n", ret);
-			}
+			info->detecting = true;
 		} else {
 			dev_dbg(arizona->dev, "Detected headphone\n");
 		}
@@ -586,6 +580,8 @@ done:
 		info->hpdet_active = false;
 	}
 
+	info->hpdet_done = true;
+
 out:
 	mutex_unlock(&info->lock);
 
@@ -597,6 +593,9 @@ static void arizona_identify_headphone(struct arizona_extcon_info *info)
 	struct arizona *arizona = info->arizona;
 	int ret;
 
+	if (info->hpdet_done)
+		return;
+
 	dev_dbg(arizona->dev, "Starting HPDET\n");
 
 	/* Make sure we keep the device enabled during the measurement */
@@ -923,6 +922,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		for (i = 0; i < ARRAY_SIZE(info->hpdet_res); i++)
 			info->hpdet_res[i] = 0;
 		info->mic = false;
+		info->hpdet_done = false;
 
 		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
 			input_report_key(info->input,
-- 
1.7.10.4

