Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaANSpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:45:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46924 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaANSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:45:54 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: Wei Ni <wni@nvidia.com>, Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] thermal: fix default governor assignment
Date: Tue, 14 Jan 2014 14:45:37 -0400
Message-ID: <1389725137-16147-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering a thermal zone, passing an invalid
.governor_name via struct thermal_zone_params may
create a thermal zone without a governor, when it
is supposed to be the default governor.

This patch fixes this issue by assigning the
default governor, whenever the zone has a governor
set to NULL.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index a621e90..967d980 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -89,7 +89,7 @@ int thermal_register_governor(struct thermal_governor *governor)
 	list_for_each_entry(pos, &thermal_tz_list, node) {
 		if (pos->governor)
 			continue;
-		if (pos->tzp)
+		if (pos->tzp && pos->tzp->governor_name)
 			name = pos->tzp->governor_name;
 		else
 			name = DEFAULT_THERMAL_GOVERNOR;
@@ -1527,9 +1527,10 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	/* Update 'this' zone's governor information */
 	mutex_lock(&thermal_governor_lock);
 
-	if (tz->tzp)
+	if (tz->tzp && tz->tzp->governor_name)
 		tz->governor = __find_governor(tz->tzp->governor_name);
-	else
+
+	if (!tz->governor)
 		tz->governor = __find_governor(DEFAULT_THERMAL_GOVERNOR);
 
 	mutex_unlock(&thermal_governor_lock);
-- 
1.8.2.1.342.gfa7285d

