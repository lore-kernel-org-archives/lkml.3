Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3JZOWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:22:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59975 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab3JZOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:21:59 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] extcon: arizona: Fix reset of HPDET after race with removal
Date: Sat, 26 Oct 2013 15:10:18 +0100
Message-Id: <1382796618-19921-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure we reset back to our starting state, especially
making sure that we have disabled poll in the register cache.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 92eb486..3ce7b49 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -572,6 +572,14 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		goto out;
 	} else if (!ret) {
 		dev_dbg(arizona->dev, "Ignoring HPDET for removed cable\n");
+
+		/* Reset back to starting range */
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_HEADPHONE_DETECT_1,
+				   ARIZONA_HP_IMPEDANCE_RANGE_MASK |
+				   ARIZONA_HP_POLL,
+				   0);
+
 		goto done;
 	}
 
@@ -607,9 +615,9 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
 			ret);
 
+done:
 	arizona_extcon_do_magic(info, 0);
 
-done:
 	if (id_gpio)
 		gpio_set_value_cansleep(id_gpio, 0);
 
-- 
1.7.2.5

