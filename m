Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312Ab3BNMqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:46:40 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44214 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106Ab3BNMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:46:39 -0500
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] regulator: Fix memory garbage dev_err printout.
Date: Thu, 14 Feb 2013 04:46:33 -0800
Message-Id: <1360845993-693-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dd8004af: 'regulator: core: Log when a device causes a voltage
constraint fail', tried to print out some information about the
check consumer min/max uV fixup, however, it uses a garbage pointer
left over from list_for_each_entry leading to boot messages in the
form:

'[    2.079890] <RANDOM ASCII>: Restricting voltage, 3735899821-4294967295uV'

Because it references regulator->dev, it could potentially read memory from
anywhere causing a panic.

This patch instead uses rdev and the updated min/max uV values.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..5a0f54a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -200,8 +200,8 @@ static int regulator_check_consumers(struct regulator_dev *rdev,
 	}
 
 	if (*min_uV > *max_uV) {
-		dev_err(regulator->dev, "Restricting voltage, %u-%uuV\n",
-			regulator->min_uV, regulator->max_uV);
+		rdev_err(rdev, "Restricting voltage, %u-%uuV\n",
+			*min_uV, *max_uV);
 		return -EINVAL;
 	}
 
-- 
1.8.1.2

