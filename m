Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765274Ab3DDW2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:28:09 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52400 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765209Ab3DDW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:28:07 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] regulator: core: don't require a supply when supply_name is specified
Date: Thu,  4 Apr 2013 15:27:47 -0700
Message-Id: <1365114467-16357-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator drivers may specify regulator_desc->supply_name which
regulator_register() will use to find the supply node for a regulator.
If no supply was specified in the device tree or the supply has yet
to be registered regulator_register() will fail, deferring the probe
of the regulator.  In the case where no supply node was specified in the
device tree, there is no supply and it is pointless to try and find one
later, so go ahead and add the regulator without the supply.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/regulator/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a95096e..6267f1c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3476,7 +3476,14 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 		r = regulator_dev_lookup(dev, supply, &ret);
 
-		if (!r) {
+		if (ret == -ENODEV) {
+			/*
+			 * No supply was specified for this regulator and
+			 * there will never be one.
+			 */
+			ret = 0;
+			goto add_dev;
+		} else if (!r) {
 			dev_err(dev, "Failed to find supply %s\n", supply);
 			ret = -EPROBE_DEFER;
 			goto scrub;
@@ -3494,6 +3501,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		}
 	}
 
+add_dev:
 	/* add consumers devices */
 	if (init_data) {
 		for (i = 0; i < init_data->num_consumer_supplies; i++) {
-- 
1.8.1.3

