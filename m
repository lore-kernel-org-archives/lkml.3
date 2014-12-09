Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbaLINNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:07 -0500
Received: from atl4mhob01.myregisteredsite.com ([209.17.115.39]:40345 "EHLO
	atl4mhob01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756863AbaLINNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:04 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH 2/2] regulator/fixed.c: Don't report EPROBE_DEFER errors
Date: Tue,  9 Dec 2014 14:12:44 +0100
Message-Id: <1418130764-22440-2-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regulator cannot be registered because its supplier is not
available yet, don't write an error. There is no need to alert the
user of probe deferrals.
This fixes a storm of error messages at boot when a GPIO controlled
regulator is supplied by an I2C controlled supply.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/regulator/fixed.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index d21da27..ac7c874 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -189,7 +189,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
-		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"Failed to register regulator: %d\n", ret);
 		return ret;
 	}
 
-- 
1.7.9.5

