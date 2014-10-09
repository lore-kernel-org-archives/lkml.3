Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbaJIVhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:37:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbaJIVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/163] usb: dwc3: core: fix ordering for PHY suspend
Date: Thu,  9 Oct 2014 14:00:53 -0700
Message-Id: <1412888588-26755-29-git-send-email-kamal@canonical.com>
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

commit dc99f16f076559235c92d3eb66d03d1310faea08 upstream.

We can't suspend the PHYs before dwc3_core_exit_mode()
has been called, that's because the host and/or device
sides might still need to communicate with the far end
link partner.

Fixes: 8ba007a (usb: dwc3: core: enable the USB2 and USB3 phy in probe)
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 8c9c4cf..f074755 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -583,9 +583,6 @@ static int dwc3_remove(struct platform_device *pdev)
 {
 	struct dwc3	*dwc = platform_get_drvdata(pdev);
 
-	usb_phy_set_suspend(dwc->usb2_phy, 1);
-	usb_phy_set_suspend(dwc->usb3_phy, 1);
-
 	dwc3_debugfs_exit(dwc);
 
 	switch (dwc->dr_mode) {
@@ -606,6 +603,10 @@ static int dwc3_remove(struct platform_device *pdev)
 
 	dwc3_event_buffers_cleanup(dwc);
 	dwc3_free_event_buffers(dwc);
+
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+
 	dwc3_core_exit(dwc);
 
 	pm_runtime_put_sync(&pdev->dev);
-- 
1.9.1

