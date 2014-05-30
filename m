Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaE3M06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:26:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33883 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196AbaE3M0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:26:55 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] extcon: arizona: Update manual headphone detection calculation
Date: Fri, 30 May 2014 13:19:17 +0100
Message-Id: <1401452357-7823-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The higher levels of impedance have a higher minimum value than the
first level. As the same value was used for all levels, higher impedances
were reported with a very low level of accuracy. This patch applies the
approriate lower threshold for each level, whilst we are changing things
add a define for the maximum value at each level to improve readability.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Changes since v1:
 - Added define for range maximum as per review comments

 drivers/extcon/extcon-arizona.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c634796..c2eed30 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -329,14 +329,17 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
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
 
+#define ARIZONA_HPDET_B_RANGE_MAX 0x3fb
+
 static struct {
 	int min;
 	int max;
@@ -391,7 +394,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
 		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
-		    (val < 100 || val >= 0x3fb)) {
+		    (val < arizona_hpdet_b_ranges[range].threshold ||
+		     val >= ARIZONA_HPDET_B_RANGE_MAX)) {
 			range++;
 			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
 				range);
@@ -404,7 +408,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		}
 
 		/* If we go out of range report top of range */
-		if (val < 100 || val >= 0x3fb) {
+		if (val < arizona_hpdet_b_ranges[range].threshold ||
+		    val >= ARIZONA_HPDET_B_RANGE_MAX) {
 			dev_dbg(arizona->dev, "Measurement out of range\n");
 			return ARIZONA_HPDET_MAX;
 		}
-- 
1.7.2.5

