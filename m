Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaG2Q3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:29:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58428 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaG2Q3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:29:23 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC 2/5] regulator: core: Allow to get voltage count and list from parent
Date: Tue, 29 Jul 2014 18:28:56 +0200
Message-Id: <1406651339-28901-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load switches are modeled as regulators but they just provide
the voltage of their parent input supply. So, the drivers for
these switches usually neither provide a .list_voltage handler
not set a .n_voltages count. But there is code in the kernel
that assumes that all regulators should be able to provide this
information (e.g: cpufreq and mmc subsystems).

If the voltage count and list are not available for a regulator
and it has a parent input supply, then use the parent values.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 089cea8..a3c3785 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2186,7 +2186,13 @@ int regulator_count_voltages(struct regulator *regulator)
 {
 	struct regulator_dev	*rdev = regulator->rdev;
 
-	return rdev->desc->n_voltages ? : -EINVAL;
+	if (rdev->desc->n_voltages)
+		return rdev->desc->n_voltages;
+
+	if (!rdev->supply)
+		return -EINVAL;
+
+	return regulator_count_voltages(rdev->supply);
 }
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
@@ -2209,12 +2215,17 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 	if (rdev->desc->fixed_uV && rdev->desc->n_voltages == 1 && !selector)
 		return rdev->desc->fixed_uV;
 
-	if (!ops->list_voltage || selector >= rdev->desc->n_voltages)
+	if (ops->list_voltage) {
+		if (selector >= rdev->desc->n_voltages)
+			return -EINVAL;
+		mutex_lock(&rdev->mutex);
+		ret = ops->list_voltage(rdev, selector);
+		mutex_unlock(&rdev->mutex);
+	} else if (rdev->supply) {
+		ret = regulator_list_voltage(rdev->supply, selector);
+	} else {
 		return -EINVAL;
-
-	mutex_lock(&rdev->mutex);
-	ret = ops->list_voltage(rdev, selector);
-	mutex_unlock(&rdev->mutex);
+	}
 
 	if (ret > 0) {
 		if (ret < rdev->constraints->min_uV)
-- 
2.0.0.rc2

