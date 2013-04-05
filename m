Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161245Ab3DEEWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:22:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44824 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765499Ab3DEEWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:22:01 -0400
From: Nishanth Menon <nm@ti.com>
To: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] regulator: core: return err value for regulator_get if there is no DT binding
Date: Thu, 4 Apr 2013 23:21:47 -0500
Message-ID: <1365135708-23886-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365135708-23886-1-git-send-email-nm@ti.com>
References: <1365135708-23886-1-git-send-email-nm@ti.com>
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

In cases where a driver, such as cpufreq driver, need to handle (based
on platform) DT nodes which may or may not have regulator supply
binding, it is necessary to differentiate the return value. When there
is regulator supply node, defering the probe is beneficial
as sequence of dependent regulator probe may not be predictable.
However, where is no regulator supply binding, it can operate without
the same as needed.

So, to provide an appropriate return result, when we cannot find an
regulator in regulator_dev_lookup and we run out of options,
use the regulator_dev_lookup result. This helps the caller to help make
informed decision.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..139d86a 100644
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
@@ -1266,7 +1266,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 #endif
 
 	mutex_unlock(&regulator_list_mutex);
-	return regulator;
+	return ret ? ERR_PTR(ret) : regulator;
 
 found:
 	if (rdev->exclusive) {
-- 
1.7.9.5

