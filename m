Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3FGQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:12:05 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37608 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab3FGQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/10] regulator: ab8500-ext: Provide a set_voltage call-back operation
Date: Fri,  7 Jun 2013 17:11:25 +0100
Message-Id: <1370621488-18130-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering regulators which have a single voltage through Device
Tree, the framework insists that the specified voltage is actually set.
Well in order to do that we need to provide this call-back, where we
check that the value is sane and return without error. Not that the
selector isn't populated, but in our case list_voltage doesn't actually
use it, so we're good.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index b4d4547..e4975bc 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -229,6 +229,28 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_ext_set_voltage(struct regulator_dev *rdev, int min_uV,
+				  int max_uV, unsigned *selector)
+{
+	struct regulation_constraints *regu_constraints = rdev->constraints;
+
+	if (!regu_constraints) {
+		dev_err(rdev_get_dev(rdev), "No regulator constraints\n");
+		return -EINVAL;
+	}
+
+	if (regu_constraints->min_uV == min_uV &&
+	    regu_constraints->max_uV == max_uV)
+		return 0;
+
+	dev_err(rdev_get_dev(rdev),
+		"Requested min %duV max %duV != constrained min %duV max %duV\n",
+		min_uV, max_uV,
+		regu_constraints->min_uV, regu_constraints->max_uV);
+
+	return -EINVAL;
+}
+
 static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 				   unsigned selector)
 {
@@ -252,6 +274,7 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
 	.set_mode		= ab8500_ext_regulator_set_mode,
 	.get_mode		= ab8500_ext_regulator_get_mode,
+	.set_voltage		= ab8500_ext_set_voltage,
 	.list_voltage		= ab8500_ext_list_voltage,
 };
 
-- 
1.7.10.4

