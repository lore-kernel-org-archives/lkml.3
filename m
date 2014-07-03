Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbaGCKY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:24:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbaGCJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:20:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 002/198] usb: dwc3: gadget: clear stall when disabling endpoint
Date: Thu,  3 Jul 2014 10:17:25 +0100
Message-Id: <1404379241-8590-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 687ef9817df7ed960d14575b9033dde3d04631fe upstream.

so it seems like DWC3 IP doesn't clear stalls
automatically when we disable an endpoint, because
of that, we _must_ make sure stalls are cleared
before clearing the proper bit in DALEPENA register.

Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 69948ad39837..d868b62c1a16 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -604,6 +604,10 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	dwc3_remove_requests(dwc, dep);
 
+	/* make sure HW endpoint isn't stalled */
+	if (dep->flags & DWC3_EP_STALL)
+		__dwc3_gadget_ep_set_halt(dep, 0);
+
 	reg = dwc3_readl(dwc->regs, DWC3_DALEPENA);
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
-- 
1.9.1

