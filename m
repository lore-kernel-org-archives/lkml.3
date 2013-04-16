Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502Ab3DPVps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:45:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59773 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965371Ab3DPVpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:45:46 -0400
From: Nishanth Menon <nm@ti.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>, <rjw@sisk.pl>,
        <viresh.kumar@linaro.org>, <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] regulator: core: return err value for regulator_get if there is no DT binding
Date: Tue, 16 Apr 2013 16:45:16 -0500
Message-ID: <1366148717-12586-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130405101754.GD6597@opensource.wolfsonmicro.com>
References: <20130405101754.GD6597@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6d191a5fc7a969d972f1681e1c23781aecb06a61
(regulator: core: Don't defer probe if there's no DT binding for a supply)

Attempted to differentiate between regulator_get() with an actual
DT binding for the supply and when there is none to avoid unnecessary
deferal.
However, ret value supplied by regulator_dev_lookup() is being
ignored by regulator_get(). So, exit with the appropriate return value.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
based on v3.9-rc7
Changes in v2 (review comments update):
	- simplified commit log
	- error handling inline with rest of function
Available at: https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-regulator-fixing-v2
V1:
https://patchwork.kernel.org/patch/2396571/
(original depending cpufreq patch: https://patchwork.kernel.org/patch/2396541/
  - no change expected- so not reposting unless requested)

 drivers/regulator/core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..cfe8b84 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1229,7 +1229,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	struct regulator_dev *rdev;
 	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
 	const char *devname = NULL;
-	int ret;
+	int ret = 0;
 
 	if (id == NULL) {
 		pr_err("get() with no identifier\n");
@@ -1245,6 +1245,15 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	if (rdev)
 		goto found;
 
+	/*
+	 * If we have return value from dev_lookup fail, we do not expect to
+	 * succeed, so, quit with appropriate error value
+	 */
+	if (ret) {
+		regulator = ERR_PTR(ret);
+		goto out;
+	}
+
 	if (board_wants_dummy_regulator) {
 		rdev = dummy_regulator_rdev;
 		goto found;
-- 
1.7.9.5

