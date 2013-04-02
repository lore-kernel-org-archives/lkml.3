Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474Ab3DBWZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:25:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716Ab3DBWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 32/68] usb: gadget: udc-core: fix a regression during gadget driver unbinding
Date: Tue,  2 Apr 2013 15:13:21 -0700
Message-Id: <20130402221333.655486474@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -265,7 +265,7 @@ static void usb_gadget_remove_driver(str
 		udc->driver->disconnect(udc->gadget);
 		usb_gadget_disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
+		usb_gadget_udc_stop(udc->gadget, NULL);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}


