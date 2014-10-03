Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbaJDAel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:34:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaJCVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 141/357] usb: dwc3: core: fix ordering for PHY suspend
Date: Fri,  3 Oct 2014 14:28:47 -0700
Message-Id: <20141003212937.713803871@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/dwc3/core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -786,15 +786,16 @@ static int dwc3_remove(struct platform_d
 {
 	struct dwc3	*dwc = platform_get_drvdata(pdev);
 
+	dwc3_debugfs_exit(dwc);
+	dwc3_core_exit_mode(dwc);
+	dwc3_event_buffers_cleanup(dwc);
+	dwc3_free_event_buffers(dwc);
+
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 	phy_power_off(dwc->usb2_generic_phy);
 	phy_power_off(dwc->usb3_generic_phy);
 
-	dwc3_debugfs_exit(dwc);
-	dwc3_core_exit_mode(dwc);
-	dwc3_event_buffers_cleanup(dwc);
-	dwc3_free_event_buffers(dwc);
 	dwc3_core_exit(dwc);
 
 	pm_runtime_put_sync(&pdev->dev);


