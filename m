Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3AXCcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:32:07 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42090 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3AXCcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:32:00 -0500
Message-ID: <1358994705.20257.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument for
 calling of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Date: Thu, 24 Jan 2013 10:31:45 +0800
In-Reply-To: <1358994450.20257.1.camel@phoenix>
References: <1358994450.20257.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev parameter is the device requesting the data.
In this case it should be &pdev->dev rather than pdev->dev.parent.

The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
which means this fixes a memory leak because the memory is allocated every time
probe() is called, thus it should be freed when this driver is unloaded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65910-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 59c3770..b0e4c0b 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -998,7 +998,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		return NULL;
 	}
 
-	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.9.5



