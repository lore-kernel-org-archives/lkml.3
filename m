Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112Ab3FSTSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:18:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33016 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935074Ab3FSTR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:17:59 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH] regulator: core: allow consumers to request to closes step voltage
Date: Wed, 19 Jun 2013 14:17:54 -0500
Message-ID: <1371669474-24473-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator consumers are not aware of the characteristics of regulator
used to supply. For example:
consumerX requests for voltage min_uV = 500mV, max_uV = 500mV
On a regulator which has a step size of 10mV, this can be exactly
achieved.

However, on a regulator which is non-exact divider step size (example
12.66mV step size), the closest achievable would be 506.4.
regulator_set_voltage_tol does not work out either as <500mV is not an
operational voltage.

Account for step size accuracy when exact voltage requests are send for
step based regulators.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
The specific example I faced was using cpufreq-cpu0 driver with voltages
for OPPs for MPU rail and attempting the common definitions against voltages
that are non-exact multiples of stepsize of PMIC.

The alternative would be implement custom set_voltage (as againsta simpler
set_voltage_sel and using linear map/list functions) for the regulator which
will account for the same.

Yet another alternative might be to introduce yet another custom function similar
to regulator_set_voltage_tol which accounts for this. something like:
regulator_set_voltage_floor(regulator, voltage, tol) or something to that effect.

 drivers/regulator/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75a..98c96b2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2407,6 +2407,9 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		}
 
 	} else if (rdev->desc->ops->set_voltage_sel) {
+		if (min_uV == max_uV && rdev->desc->uV_step)
+			max_uV += rdev->desc->uV_step;
+
 		if (rdev->desc->ops->map_voltage) {
 			ret = rdev->desc->ops->map_voltage(rdev, min_uV,
 							   max_uV);
-- 
1.7.9.5

