Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbaJIVjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:39:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbaJIVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/163] usb: dwc3: core: fix order of PM runtime calls
Date: Thu,  9 Oct 2014 14:00:52 -0700
Message-Id: <1412888588-26755-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit fed33afce0eda44a46ae24d93aec1b5198c0bac4 upstream.

Currently, we disable pm_runtime before all register
accesses are done, this is dangerous and might lead
to abort exceptions due to the driver trying to access
a register which is clocked by a clock which was long
gated.

Fix that by moving pm_runtime_put_sync() and pm_runtime_disable()
as the last thing we do before returning from our ->remove()
method.

Fixes: 72246da (usb: Introduce DesignWare USB3 DRD Driver)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index a49217a..8c9c4cf 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -586,9 +586,6 @@ static int dwc3_remove(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
 	dwc3_debugfs_exit(dwc);
 
 	switch (dwc->dr_mode) {
@@ -611,6 +608,9 @@ static int dwc3_remove(struct platform_device *pdev)
 	dwc3_free_event_buffers(dwc);
 	dwc3_core_exit(dwc);
 
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
-- 
1.9.1

