Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3AWQEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:04:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435Ab3AWQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:04:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] extcon: arizona: Disable debouce for accessory removal detection
Date: Thu, 24 Jan 2013 00:03:45 +0800
Message-Id: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we clamp as quickly as possible after removal by disabling the
debounce while there is an accessory present.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index de141f7..ce95f86 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -773,6 +773,10 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		} else {
 			arizona_start_hpdet_acc_id(info);
 		}
+
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_JACK_DETECT_DEBOUNCE,
+				   ARIZONA_MICD_CLAMP_DB | ARIZONA_JD1_DB, 0);
 	} else {
 		dev_dbg(arizona->dev, "Detected jack removal\n");
 
@@ -792,6 +796,11 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		if (ret != 0)
 			dev_err(arizona->dev, "Removal report failed: %d\n",
 				ret);
+
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_JACK_DETECT_DEBOUNCE,
+				   ARIZONA_MICD_CLAMP_DB | ARIZONA_JD1_DB,
+				   ARIZONA_MICD_CLAMP_DB | ARIZONA_JD1_DB);
 	}
 
 	mutex_unlock(&info->lock);
-- 
1.7.10.4

