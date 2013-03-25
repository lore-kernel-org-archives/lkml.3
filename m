Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3CYBaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:30:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33953 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967Ab3CYBP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:56 -0400
Message-Id: <20130325010531.384661104@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 072/104] usb: gadget: udc-core: fix a regression during gadget driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 unbinding
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 511f3c5326eabe1ece35202a404c24c0aeacc246 upstream.

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -213,7 +213,7 @@ static void usb_gadget_remove_driver(str
 		udc->driver->disconnect(udc->gadget);
 		usb_gadget_disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
+		usb_gadget_udc_stop(udc->gadget, NULL);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}


