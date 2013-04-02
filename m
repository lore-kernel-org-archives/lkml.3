Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162Ab3DBLg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:36:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46547 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760138Ab3DBLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/16] extcon: arizona: Allow pull to be disabled on GPIO5 when used for JACKET
Date: Tue,  2 Apr 2013 12:32:37 +0100
Message-Id: <1364902368-1123-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some designs an external pull won't be needed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |    9 +++++++--
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 95748d3..132bc99 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -986,6 +986,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct arizona_pdata *pdata;
 	struct arizona_extcon_info *info;
+	unsigned int val;
 	int jack_irq_fall, jack_irq_rise;
 	int ret, mode, i, j;
 
@@ -1172,9 +1173,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	 */
 	if (info->micd_clamp) {
 		if (arizona->pdata.jd_gpio5) {
-			/* Put the GPIO into input mode */
+			/* Put the GPIO into input mode with optional pull */
+			val = 0xc101;
+			if (arizona->pdata.jd_gpio5_nopull)
+				val &= ~ARIZONA_GPN_PU;
+
 			regmap_write(arizona->regmap, ARIZONA_GPIO5_CTRL,
-				     0xc101);
+				     val);
 
 			regmap_update_bits(arizona->regmap,
 					   ARIZONA_MICD_CLAMP_CONTROL,
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index eb11a8a..008b8c4 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -122,6 +122,9 @@ struct arizona_pdata {
 	/** GPIO5 is used for jack detection */
 	bool jd_gpio5;
 
+	/** Internal pull on GPIO5 is disabled when used for jack detection */
+	bool jd_gpio5_nopull;
+
 	/** Use the headphone detect circuit to identify the accessory */
 	bool hpdet_acc_id;
 
-- 
1.7.10.4

