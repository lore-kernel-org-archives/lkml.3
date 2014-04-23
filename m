Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaDWXMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:12:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46789 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaDWXMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:12:13 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Markus Pargmann <mpa@pengutronix.de>, Nishanth Menon <nm@ti.com>
Subject: [RESEND PATCH] regulator: core: Disable unused regulators after deferred probing is done
Date: Wed, 23 Apr 2014 18:10:50 -0500
Message-ID: <1398294650-24821-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Saravana Kannan <skannan@codeaurora.org>

regulator_init_complete does a scan of regulators which dont have
always-on or consumers are automatically disabled as being unused.
However, with deferred probing, late_initcall() is too soon to
declare a regulator as unused as the regulator itself might not
have registered due to defferal - Example: A regulator deffered due
to i2bus not available which in turn is deffered due to pinctrl
availability.

Since deferred probing is done in late_initcall(), do the cleanup of
unused regulators by regulator_init_complete in late_initcall_sync
instead of late_initcall.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
[nm@ti.com: minor rewording]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Applies on v3.15-rc2 and on next-20140423
Original post: https://patchwork.kernel.org/patch/2545061/

I rediscovered this patch many times now :(:
Latest Example: https://patchwork.kernel.org/patch/4044811/
http://slexy.org/raw/s21MCHgeJo shows none of the unused regulators are disabled
and with this fix:
http://slexy.org/raw/s2TH36cThR (which auto disables unused regulators).

Ccying Markus as author of 66fda75f47dc (regulator: core: Replace
direct ops->disable usage) he might be interested as well.

Btw, this might open up a lot of broken boards - like we discovered
for DRA7 - so it might be a good idea for next instead of current rc
cyle giving it some time to cook and get platforms fixed.

 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3c..5a05de3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3867,4 +3867,4 @@ unlock:
 
 	return 0;
 }
-late_initcall(regulator_init_complete);
+late_initcall_sync(regulator_init_complete);
-- 
1.7.9.5

