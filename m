Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaJCXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:16:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbaJCWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 178/238] usb: dwc3: core: fix ordering for PHY suspend
Date: Fri,  3 Oct 2014 14:31:33 -0700
Message-Id: <20141003212919.370121773@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/dwc3/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -583,9 +583,6 @@ static int dwc3_remove(struct platform_d
 {
 	struct dwc3	*dwc = platform_get_drvdata(pdev);
 
-	usb_phy_set_suspend(dwc->usb2_phy, 1);
-	usb_phy_set_suspend(dwc->usb3_phy, 1);
-
 	dwc3_debugfs_exit(dwc);
 
 	switch (dwc->dr_mode) {
@@ -606,6 +603,10 @@ static int dwc3_remove(struct platform_d
 
 	dwc3_event_buffers_cleanup(dwc);
 	dwc3_free_event_buffers(dwc);
+
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+
 	dwc3_core_exit(dwc);
 
 	pm_runtime_put_sync(&pdev->dev);


