Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbaGRMJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:09:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933235AbaGRMJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:09:10 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] extcon: arizona: Get MICVDD against extcon device
Date: Fri, 18 Jul 2014 12:59:00 +0100
Message-Id: <1405684740-28768-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we would do a regulator get against the main Arizona device
to obtain the MICVDD regulator. Arizona is an MFD device and normally
MICVDD will be supplied by one of its children (the arizona-micsupp
regulator). As devres destruction for the MFD device will run after all
its children have been destroyed, the regulator will be destroyed before
devres calls regulator_put. This causes a warning from both the
destruction of the child node, as the regulator is still open, and from
the put of the regulator as the regulator device has already been
destroyed.

A simple fix here is to get the regulator against the extcon device
itself such that devres runs when the child is destroyed. This has the
additional benefit that if for some reason the extcon driver is unloaded
the regulator reference won't hang around until the MFD is unloaded.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 59aa513..ba51588 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1120,7 +1120,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
-	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
+	info->micvdd = devm_regulator_get(&pdev->dev, "MICVDD");
 	if (IS_ERR(info->micvdd)) {
 		ret = PTR_ERR(info->micvdd);
 		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
-- 
1.7.2.5

