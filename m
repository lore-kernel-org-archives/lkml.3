Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3JRKDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:03:38 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7986 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3JRKDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:03:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 02:59:05 -0700
From: Wei Ni <wni@nvidia.com>
To: <rui.zhang@intel.com>, <durgadoss.r@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>
Subject: [PATCH] thermal: Fix binding problem when there is thermal zone params
Date: Fri, 18 Oct 2013 18:03:06 +0800
Message-ID: <1382090587-9602-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal zone params can be used to set governor
to specific thermal governor for thermal zone device.
But if the thermal zone params has only governor name
without thermal bind params, then the thermal zone device
will not be binding to cooling device. Because tz->ops->bind
operator is not invoked in bind_tz() and bind_cdev() when
there is thermal zone params.

Signed-off-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
---
 drivers/thermal/thermal_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 4962a6a..2ea41d3 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -247,7 +247,7 @@ static void bind_cdev(struct thermal_cooling_device *cdev)
 		if (!pos->tzp && !pos->ops->bind)
 			continue;
 
-		if (!pos->tzp && pos->ops->bind) {
+		if (pos->ops->bind) {
 			ret = pos->ops->bind(pos, cdev);
 			if (ret)
 				print_bind_err_msg(pos, cdev, ret);
@@ -282,8 +282,8 @@ static void bind_tz(struct thermal_zone_device *tz)
 
 	mutex_lock(&thermal_list_lock);
 
-	/* If there is no platform data, try to use ops->bind */
-	if (!tzp && tz->ops->bind) {
+	/* If there is ops->bind, try to use ops->bind */
+	if (tz->ops->bind) {
 		list_for_each_entry(pos, &thermal_cdev_list, node) {
 			ret = tz->ops->bind(tz, pos);
 			if (ret)
-- 
1.7.9.5

