Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaKAWlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:41:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60335 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbaKAWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.454164569@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 026/102] usb: dwc3: core: fix order of PM runtime calls
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -427,9 +427,6 @@ static int __devexit dwc3_remove(struct
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
 	dwc3_debugfs_exit(dwc);
 
 	if (features & DWC3_HAS_PERIPHERAL)
@@ -440,6 +437,9 @@ static int __devexit dwc3_remove(struct
 	iounmap(dwc->regs);
 	kfree(dwc->mem);
 
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 

