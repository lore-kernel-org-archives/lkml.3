Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab3KFFRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:17:37 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49931 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3KFFRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:17:35 -0500
From: Tim Harvey <tharvey@gateworks.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/2] regulator: pfuze100: allow misprogrammed ID
Date: Tue,  5 Nov 2013 21:17:25 -0800
Message-Id: <1383715045-15341-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prior to week 08 of 2013 Freescale misprogrammed between 1 and 3% of
PFUZE1000 parts with a ID=0x8 instead of the expected ID=0x0

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/regulator/pfuze100-regulator.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index ba67b2c..032df37 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -308,9 +308,15 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
 	if (ret)
 		return ret;
 
-	if (value & 0x0f) {
-		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
-		return -ENODEV;
+	switch (value & 0x0f) {
+		/* Freescale misprogrammed 1-3% of parts prior to week 8 of 2013 as ID=8 */
+		case 0x8:
+			dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");
+		case 0x0:
+			break;
+		default:
+			dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
+			return -ENODEV;
 	}
 
 	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
-- 
1.7.9.5

