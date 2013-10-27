Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3J0QbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:31:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab3J0QbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:31:04 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2 1/2] extcon: arizona: Fix reset of HPDET after race with removal
Date: Sun, 27 Oct 2013 16:19:11 +0000
Message-Id: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
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
index ec9a14e..dac8ba0 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -596,9 +596,15 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
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

