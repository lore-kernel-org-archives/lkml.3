Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaICGYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:24:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:41712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaICGYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:24:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,455,1406617200"; 
   d="scan'208";a="593756516"
Date: Wed, 3 Sep 2014 14:26:34 +0800
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: balbi@ti.com
Cc: david.a.cohen@intel.com, jiebing.li@intel.com, hang.yuan@intel.com,
        hao.wu@intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc3: gadget: Fix desc NULL pointer in
 dwc3_gadget_ep_queue()
Message-ID: <20140903062634.GA27870@intel.com>
Reply-To: jin.can.zhuang@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dep->endpoint.desc is checked at the beginning of
dwc3_gadget_ep_queue(), but after that it may be set to NULL
by another thread and then accessed again in dwc3_gadget_ep_queue().
This will lead to kernel oops.

Expand spinlock protection area to aviod race condition.

Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
Signed-off-by: Jiebing Li <jiebing.li@intel.com>
---
 drivers/usb/dwc3/gadget.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 349cacc..e8fb231 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1225,16 +1225,17 @@ static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,
 
 	int				ret;
 
+	spin_lock_irqsave(&dwc->lock, flags);
 	if (!dep->endpoint.desc) {
 		dev_dbg(dwc->dev, "trying to queue request %p to disabled %s\n",
 				request, ep->name);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		return -ESHUTDOWN;
 	}
 
 	dev_vdbg(dwc->dev, "queing request %p to %s length %d\n",
 			request, ep->name, request->length);
 
-	spin_lock_irqsave(&dwc->lock, flags);
 	ret = __dwc3_gadget_ep_queue(dep, req);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
1.7.9.5

