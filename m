Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3JANKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:10:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:39132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3JANKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:10:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="368222978"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv4 1/9] Thermal: Check for validity before doing kfree
Date: Wed,  2 Oct 2013 00:08:00 +0530
Message-Id: <1380652688-5787-2-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal_release function is called whenever
any device belonging to 'thermal' class unregisters.
This function performs kfree(cdev) without any check.
In cases where there are more device registrations
other than just 'thermal_zone' and 'cooling_device'
this might accidently free memory allocated them
silently; and cause memory errors.

This patch changes this behavior by doing
kfree(cdev) only when the device pointer belongs
to a real cdev i.e. cooling_device.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 1f02e8e..8c5131d 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1280,7 +1280,8 @@ static void thermal_release(struct device *dev)
 		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
-	} else {
+	} else if(!strncmp(dev_name(dev), "cooling_device",
+			sizeof("cooling_device") - 1)){
 		cdev = to_cooling_device(dev);
 		kfree(cdev);
 	}
-- 
1.7.9.5

