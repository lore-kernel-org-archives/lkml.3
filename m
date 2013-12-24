Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3LXB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:58:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:58503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab3LXB6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:58:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,540,1384329600"; 
   d="scan'208";a="429191442"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com, bhelgaas@google.com,
        yanmin_zhang@linux.intel.com, yanmin.zhang@intel.com
Subject: [PATCH] pnp: Bypass the calling to pnp_stop_dev at suspend when there is a protocol suspend
Date: Tue, 24 Dec 2013 09:35:51 +0800
Message-Id: <1387848951-26999-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanmin <yanmin.zhang@intel.com>

pnp pnp_bus_suspend/_resume have an issue.
pnp_bus_suspend calls pnp_stop_dev to disable the device. With ACPI,
pnp_stop_dev turns off the dev usually. Then,
pnp_bus_suspend=>pnp_dev->protocol->suspend accesses the device and
suspend it again.

pnp_bus_resume has the similar issue.

Another issue is firmware might just provide _DIS, but no_STS method.

The patch fixes it by adding a checking. If there is
pnp_dev->protocol->suspend, pnp_bus_suspend doesn't call pnp_stop_dev.
Do the similar thing for _resume.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 drivers/pnp/driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index f748cc8..2512e47 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -176,7 +176,7 @@ static int __pnp_bus_suspend(struct device *dev, pm_message_t state)
 			return error;
 	}
 
-	if (pnp_can_disable(pnp_dev)) {
+	if (pnp_can_disable(pnp_dev) && !pnp_dev->protocol->suspend) {
 		error = pnp_stop_dev(pnp_dev);
 		if (error)
 			return error;
@@ -215,9 +215,7 @@ static int pnp_bus_resume(struct device *dev)
 		error = pnp_dev->protocol->resume(pnp_dev);
 		if (error)
 			return error;
-	}
-
-	if (pnp_can_write(pnp_dev)) {
+	} else if (pnp_can_write(pnp_dev)) {
 		error = pnp_start_dev(pnp_dev);
 		if (error)
 			return error;
-- 
1.8.3

