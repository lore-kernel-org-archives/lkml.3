Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaK0Iqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:41407 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaK0Iqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:48 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 21/91] usb: dwc3: core: fix order of PM runtime calls
Date: Thu, 27 Nov 2014 16:42:04 +0800
Message-Id: <1417077794-9299-21-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/dwc3/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 99b58d84..6da4435 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -563,9 +563,6 @@ static int __devexit dwc3_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
 	dwc3_debugfs_exit(dwc);
 
 	switch (dwc->mode) {
@@ -586,6 +583,9 @@ static int __devexit dwc3_remove(struct platform_device *pdev)
 
 	dwc3_core_exit(dwc);
 
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
-- 
1.9.1

