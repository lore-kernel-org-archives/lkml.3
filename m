Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaEWLzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:55:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55590 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbaEWLzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:55:08 -0400
Date: Fri, 23 May 2014 12:54:57 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: sameo@linux.intel.com, broonie@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH V2] extcon: arizona: support inverted jack detect switch
Message-ID: <20140523115446.GA20451@opensource.wolfsonmicro.com>
References: <20140520115632.GA13900@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520115632.GA13900@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config option for inverted jack detect switch that
opens when jack is inserted.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   34 ++++++++++++++++++++++++++--------
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..4c73d25 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -39,6 +39,11 @@
 #define ARIZONA_ACCDET_MODE_HPL 1
 #define ARIZONA_ACCDET_MODE_HPR 2
 
+#define ARIZONA_MICD_CLAMP_MODE_JDL      0x4
+#define ARIZONA_MICD_CLAMP_MODE_JDH      0x5
+#define ARIZONA_MICD_CLAMP_MODE_JDL_GP5H 0x9
+#define ARIZONA_MICD_CLAMP_MODE_JDH_GP5H 0xb
+
 #define ARIZONA_HPDET_MAX 10000
 
 #define HPDET_DEBOUNCE 500
@@ -962,10 +967,16 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 	if (arizona->pdata.jd_gpio5) {
 		mask = ARIZONA_MICD_CLAMP_STS;
-		present = 0;
+		if (arizona->pdata.jd_invert)
+			present = ARIZONA_MICD_CLAMP_STS;
+		else
+			present = 0;
 	} else {
 		mask = ARIZONA_JD1_STS;
-		present = ARIZONA_JD1_STS;
+		if (arizona->pdata.jd_invert)
+			present = 0;
+		else
+			present = ARIZONA_JD1_STS;
 	}
 
 	ret = regmap_read(arizona->regmap, ARIZONA_AOD_IRQ_RAW_STATUS, &val);
@@ -1096,6 +1107,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	struct arizona_pdata *pdata = &arizona->pdata;
 	struct arizona_extcon_info *info;
 	unsigned int val;
+	unsigned int clamp_mode;
 	int jack_irq_fall, jack_irq_rise;
 	int ret, mode, i, j;
 
@@ -1302,16 +1314,22 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 			regmap_write(arizona->regmap, ARIZONA_GPIO5_CTRL,
 				     val);
 
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_MICD_CLAMP_CONTROL,
-					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x9);
+			if (arizona->pdata.jd_invert)
+				clamp_mode = ARIZONA_MICD_CLAMP_MODE_JDH_GP5H;
+			else
+				clamp_mode = ARIZONA_MICD_CLAMP_MODE_JDL_GP5H;
 		} else {
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_MICD_CLAMP_CONTROL,
-					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x4);
+			if (arizona->pdata.jd_invert)
+				clamp_mode = ARIZONA_MICD_CLAMP_MODE_JDH;
+			else
+				clamp_mode = ARIZONA_MICD_CLAMP_MODE_JDL;
 		}
 
 		regmap_update_bits(arizona->regmap,
+				   ARIZONA_MICD_CLAMP_CONTROL,
+				   ARIZONA_MICD_CLAMP_MODE_MASK, clamp_mode);
+
+		regmap_update_bits(arizona->regmap,
 				   ARIZONA_JACK_DETECT_DEBOUNCE,
 				   ARIZONA_MICD_CLAMP_DB,
 				   ARIZONA_MICD_CLAMP_DB);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 12a5c13..4578c72 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -127,6 +127,9 @@ struct arizona_pdata {
 	/** Internal pull on GPIO5 is disabled when used for jack detection */
 	bool jd_gpio5_nopull;
 
+	/** set to true if jackdet contact opens on insert */
+	bool jd_invert;
+
 	/** Use the headphone detect circuit to identify the accessory */
 	bool hpdet_acc_id;
 
-- 
1.7.2.5

