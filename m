Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbaE2PgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:36:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596AbaE2Pfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:31 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] extcon: arizona: Update manual headphone detection calculation
Date: Thu, 29 May 2014 16:27:53 +0100
Message-Id: <1401377274-10249-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The higher levels of impedance have a higher minimum value than the
first level. As the same value was used for all levels, higher impedances
were reported with a very low level of accuracy. This patch applies the
approriate lower threshold for each level.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index f2c36b1..c1c8647 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -329,12 +329,13 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 }
 
 static struct {
+	unsigned int threshold;
 	unsigned int factor_a;
 	unsigned int factor_b;
 } arizona_hpdet_b_ranges[] = {
-	{  5528,   362464 },
-	{ 11084,  6186851 },
-	{ 11065, 65460395 },
+	{ 100,  5528,   362464 },
+	{ 169, 11084,  6186851 },
+	{ 169, 11065, 65460395 },
 };
 
 static struct {
@@ -391,7 +392,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
 		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
-		    (val < 100 || val >= 0x3fb)) {
+		    (val < arizona_hpdet_b_ranges[range].threshold ||
+		     val >= 0x3fb)) {
 			range++;
 			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
 				range);
@@ -404,7 +406,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		}
 
 		/* If we go out of range report top of range */
-		if (val < 100 || val >= 0x3fb) {
+		if (val < arizona_hpdet_b_ranges[range].threshold ||
+		    val >= 0x3fb) {
 			dev_dbg(arizona->dev, "Measurement out of range\n");
 			return ARIZONA_HPDET_MAX;
 		}
-- 
1.7.2.5

