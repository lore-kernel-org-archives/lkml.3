Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803Ab3DBLfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:35:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46557 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760183Ab3DBLdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/16] extcon: arizona: Check we report a valid impedance
Date: Tue,  2 Apr 2013 12:32:40 +0100
Message-Id: <1364902368-1123-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Occasionally we can trigger an interrupt before we have completed
impedance measurement, although the valid bit will still be set. This
patch spins reading the impedance value until a valid value is seen.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 9e4bffe..4022fe2 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -737,22 +737,30 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
-	unsigned int val, lvl;
+	unsigned int val = 0, lvl;
 	int ret, i, key;
 
 	mutex_lock(&info->lock);
 
-	ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
-		mutex_unlock(&info->lock);
-		return IRQ_NONE;
-	}
+	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
+		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
+			mutex_unlock(&info->lock);
+			return IRQ_NONE;
+		}
+
+		dev_dbg(arizona->dev, "MICDET: %x\n", val);
 
-	dev_dbg(arizona->dev, "MICDET: %x\n", val);
+		if (!(val & ARIZONA_MICD_VALID)) {
+			dev_warn(arizona->dev, "Microphone detection state invalid\n");
+			mutex_unlock(&info->lock);
+			return IRQ_NONE;
+		}
+	}
 
-	if (!(val & ARIZONA_MICD_VALID)) {
-		dev_warn(arizona->dev, "Microphone detection state invalid\n");
+	if (i == 10 && !(val & 0x7fc)) {
+		dev_err(arizona->dev, "Failed to get valid MICDET value\n");
 		mutex_unlock(&info->lock);
 		return IRQ_NONE;
 	}
-- 
1.7.10.4

