Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3KNO2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:28:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628Ab3KNO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:27:02 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2 3/7] extcon: arizona: Fix race with microphone detection and removal
Date: Thu, 14 Nov 2013 14:11:33 +0000
Message-Id: <1384438297-27851-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microphone detection code is run as delayed work to provide
additional debounce, it is possible that the jack could have been
removed by the time we process the microphone detection. Turn this
case into a no op.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 61f9d6e..bc60e8c 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -782,6 +782,19 @@ static void arizona_micd_detect(struct work_struct *work)
 
 	mutex_lock(&info->lock);
 
+	/* If the cable was removed while measuring ignore the result */
+	ret = extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to check cable state: %d\n",
+				ret);
+		mutex_unlock(&info->lock);
+		return;
+	} else if (!ret) {
+		dev_dbg(arizona->dev, "Ignoring MICDET for removed cable\n");
+		mutex_unlock(&info->lock);
+		return;
+	}
+
 	for (i = 0; i < 10 && !(val & MICD_LVL_0_TO_8); i++) {
 		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 		if (ret != 0) {
-- 
1.7.2.5

