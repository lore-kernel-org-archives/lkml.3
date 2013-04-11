Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab3DKVPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:15:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935563Ab3DKUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:00 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RZ_UQPUynuMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=F5CPKyBE5jkA:10 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202608.295363367@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 134/171 ] usb: gadget: udc-core: fix a regression during gadget driver
 unbinding
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0134-usb-gadget-udc-core-fix-a-regression-during-gadget-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 511f3c5326eabe1ece35202a404c24c0aeacc246 ]

This patch (as1666) fixes a regression in the UDC core.  The core
takes care of unbinding gadget drivers, and it does the unbinding
before telling the UDC driver to turn off the controller hardware.
When the call to the udc_stop callback is made, the gadget no longer
has a driver.  The callback routine should not be invoked with a
pointer to the old driver; doing so can cause problems (such as
use-after-free accesses in net2280).

This patch should be applied, with appropriate context changes, to all
the stable kernels going back to 3.1.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index e5e44f8..b0af333 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -265,7 +265,7 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 		udc->driver->disconnect(udc->gadget);
 		usb_gadget_disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
+		usb_gadget_udc_stop(udc->gadget, NULL);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}
-- 
1.7.10.4


