Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3KNO2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:28:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab3KNO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:27:02 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2 2/7] extcon: arizona: Fix reset of HPDET after race with removal
Date: Thu, 14 Nov 2013 14:11:32 +0000
Message-Id: <1384438297-27851-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure we reset back to our starting state, especially
making sure that we have disabled poll in the register cache.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index d611420..61f9d6e 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -605,9 +605,15 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
 			ret);
 
+done:
+	/* Reset back to starting range */
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_HEADPHONE_DETECT_1,
+			   ARIZONA_HP_IMPEDANCE_RANGE_MASK | ARIZONA_HP_POLL,
+			   0);
+
 	arizona_extcon_do_magic(info, 0);
 
-done:
 	if (id_gpio)
 		gpio_set_value_cansleep(id_gpio, 0);
 
-- 
1.7.2.5

