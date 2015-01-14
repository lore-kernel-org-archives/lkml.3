Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbbANGpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:45:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65183 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANGpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:45:45 -0500
X-AuditID: cbfee61a-f79c06d000004e71-fd-54b61097e684
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@opensource.altera.com,
        yousaf.kaukab@intel.com, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under spinlock
Date: Wed, 14 Jan 2015 07:45:31 +0100
Message-id: <1421217931-23722-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgO50gW0hBmcXc1kcvF9vserTGmaL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdotNm34yO3B6LN7zkslj/9w17B791yax
	e/RtWcXosWX/Z0aP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlXHr2SPGgh7OipvTD7I0MB5k
	72Lk4JAQMJFo/qbexcgJZIpJXLi3nq2LkYtDSGARo8StndeYIJx2JolFF9YxgVSxCehIbPk+
	gRGkWQSo4/sHTpAaZoFnjBJrHx9hB6kRFvCV2PjxEhuIzSKgKnFt6QSwZbwCrhL3/gVALJOT
	OHlsMusERu4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYID6ZnUDsaVDRaHGAU4GJV4
	eB2ObA0RYk0sK67MPcQowcGsJMK7nmlbiBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB
	9MSS1OzU1ILUIpgsEwenVAPjokWqv07sPKD0et+tzCmfW68l7p360SHPJqZ4k4hjPOOSI/Zm
	5+643NyjImalMHMVv9OVs9K3J5Qa2EyRvXuDZ52Ow2kjcbPGLfYnOGwvRjLbWazgmaJ60PzY
	lMO5d+W+8Hb+Uj1x9ZbS7It1UR/kHIrPtDZuP3x2zUmp7SLKx59LZuU2vCqLVGIpzkg01GIu
	Kk4EAOcGmEAgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug described here:
https://lkml.org/lkml/2014/12/22/185

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Changelog:

v2:
- fixed comment from Paul Zimmerman

v1: https://lkml.org/lkml/2015/1/13/186

 drivers/usb/dwc2/core_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index ad43c5b..02e3e2d 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 	u32 gintsts;
 	irqreturn_t retval = IRQ_NONE;
 
+	spin_lock(&hsotg->lock);
+
 	if (!dwc2_is_controller_alive(hsotg)) {
 		dev_warn(hsotg->dev, "Controller is dead\n");
 		goto out;
 	}
 
-	spin_lock(&hsotg->lock);
-
 	gintsts = dwc2_read_common_intr(hsotg);
 	if (gintsts & ~GINTSTS_PRTINT)
 		retval = IRQ_HANDLED;
@@ -515,8 +515,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 		}
 	}
 
-	spin_unlock(&hsotg->lock);
 out:
+	spin_unlock(&hsotg->lock);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(dwc2_handle_common_intr);
-- 
1.9.1

