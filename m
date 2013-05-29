Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230Ab3E2Vhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:37:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46193 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab3E2VhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:37:24 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Durgadoss R <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] thermal: consider emul_temperature while computing trend
Date: Wed, 29 May 2013 17:37:00 -0400
Message-ID: <1369863420-21913-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case emulated temperature is in use, using the trend
provided by driver layer can lead to bogus situation.
In this case, debugger user would set a temperature value,
but the trend would be from driver computation.

To avoid this situation, this patch changes the get_tz_trend()
to consider the emulated temperature whenever that is in use.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d755440..c00dc92 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -155,7 +155,8 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip)
 {
 	enum thermal_trend trend;
 
-	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
+	if (tz->emul_temperature || !tz->ops->get_trend ||
+	    tz->ops->get_trend(tz, trip, &trend)) {
 		if (tz->temperature > tz->last_temperature)
 			trend = THERMAL_TREND_RAISING;
 		else if (tz->temperature < tz->last_temperature)
-- 
1.8.2.1.342.gfa7285d

