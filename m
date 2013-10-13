Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3JMPBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:01:17 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:37569 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3JMPBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:01:16 -0400
From: Nikita Kiryanov <nikita@compulab.co.il>
To: linux-kernel@vger.kernel.org
Cc: Nikita Kiryanov <nikita@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: [PATCH] regulator: fix use_count bug
Date: Sun, 13 Oct 2013 18:01:11 +0300
Message-Id: <1381676471-25619-1-git-send-email-nikita@compulab.co.il>
X-Mailer: git-send-email 1.8.1.2
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: nikita@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During regulator registration the regulator framework checks that the
regulator is:
a) enabled
b) has a supplier
and if both are true, it calls regulator_enable() on the supplier, which
has the side effect of incrementing its use count. This puts the
regulator framework in an inconsistent state. Consider the following
example:

regY --supplies--> regX
regX is turned on by hardware, bootloader, or driver ops (as a result of
the boot_on or always_on flag being set), so during registration both
(a) and (b) are true. regulator_enable(regY) is invoked, and now
regY.use_count == 1, regX.use_count == 0.
Later on, the regulator framework iterates over the registered
regulators and turns off unused ones using driver ops. Due to the
use_count values, regX is disabled, while regY is not. Due to the use of
driver ops, instead of regulator_disable(), the use_count of regY is not
updated when regX is disabled.
We now have a situation where regY has a minimum use_count of 1, and
will never be turned off.

The underlying issue is that we are updating regulator metadata that
exists to keep track of function invocations (regulator_enable,
regulator_disable) as a result of something that isn't said function
invocations. The state of regX is not the result of a regulator_enable
call, so use_count increments should not be propogated on the supply
dependency chain. Instead, if there's a need for regX to be enabled on
boot, the boot_on flag should be used for all the regulators on the
supply chain.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Nikita Kiryanov <nikita@compulab.co.il>
Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>

---
 drivers/regulator/core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3..7070d5c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3440,13 +3440,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		ret = set_supply(rdev, r);
 		if (ret < 0)
 			goto scrub;
-
-		/* Enable supply if rail is enabled */
-		if (_regulator_is_enabled(rdev)) {
-			ret = regulator_enable(rdev->supply);
-			if (ret < 0)
-				goto scrub;
-		}
 	}
 
 add_dev:
-- 
1.8.1.2

