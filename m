Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3BFDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:09:57 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:35872 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFDJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:09:54 -0500
Message-ID: <1360120188.8965.8.camel@phoenix>
Subject: [PATCH 1/2] regulator: core: Optimize _regulator_do_set_voltage if
 voltage does not change
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 11:09:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize _regulator_do_set_voltage() for the case selector is equal to
old_selector. Since the voltage does not change, we don't need to call
set_voltage_sel() and set_voltage_time_sel() in this case.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index de47880..e9df76e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2239,8 +2239,11 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			best_val = rdev->desc->ops->list_voltage(rdev, ret);
 			if (min_uV <= best_val && max_uV >= best_val) {
 				selector = ret;
-				ret = rdev->desc->ops->set_voltage_sel(rdev,
-								       ret);
+				if (old_selector == selector)
+					ret = 0;
+				else
+					ret = rdev->desc->ops->set_voltage_sel(
+								rdev, ret);
 			} else {
 				ret = -EINVAL;
 			}
@@ -2251,7 +2254,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
 	if (ret == 0 && _regulator_is_enabled(rdev) && old_selector >= 0 &&
-	    rdev->desc->ops->set_voltage_time_sel) {
+	    old_selector != selector && rdev->desc->ops->set_voltage_time_sel) {
 
 		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
 						old_selector, selector);
-- 
1.7.9.5



