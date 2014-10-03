Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbaJDAem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:34:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaJCVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 140/357] usb: dwc3: core: fix order of PM runtime calls
Date: Fri,  3 Oct 2014 14:28:46 -0700
Message-Id: <20141003212937.678917802@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -791,15 +791,15 @@ static int dwc3_remove(struct platform_d
 	phy_power_off(dwc->usb2_generic_phy);
 	phy_power_off(dwc->usb3_generic_phy);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
 	dwc3_debugfs_exit(dwc);
 	dwc3_core_exit_mode(dwc);
 	dwc3_event_buffers_cleanup(dwc);
 	dwc3_free_event_buffers(dwc);
 	dwc3_core_exit(dwc);
 
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 


