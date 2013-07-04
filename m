Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3GDQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:28:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56703 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3GDQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:28:23 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu,  4 Jul 2013 17:27:59 +0100
Message-Id: <1372955279-24640-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Make set_voltage_tol() try for mid-range first
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The expected semantic for something expressed as a tolerance is that it
should deliver the specified value with some deviation allowed but this
is not what set_voltage_tol() currently does. Instead it just passes
the maximum possible range to set_voltage() which will typically result
in a voltage aimed at lower than the target voltage.

Instead first try to set a voltage between the target voltage and the
upper limit, then fall back on the full range. This will be much more
robust against physical variation in systems and makes the API behave
more like users would expect.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/regulator/consumer.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 3a76389..3610df8 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -369,8 +369,11 @@ static inline int regulator_count_voltages(struct regulator *regulator)
 static inline int regulator_set_voltage_tol(struct regulator *regulator,
 					    int new_uV, int tol_uV)
 {
-	return regulator_set_voltage(regulator,
-				     new_uV - tol_uV, new_uV + tol_uV);
+	if (regulator_set_voltage(regulator, new_uV, new_uV + tol_uV) == 0)
+		return 0;
+	else
+		return regulator_set_voltage(regulator,
+					     new_uV - tol_uV, new_uV + tol_uV);
 }
 
 static inline int regulator_is_supported_voltage_tol(struct regulator *regulator,
-- 
1.8.3.2

