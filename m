Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab3CZPo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:44:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128Ab3CZPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/150] usb: gadget: udc-core: fix a regression during gadget driver unbinding
Date: Tue, 26 Mar 2013 15:19:47 +0000
Message-Id: <1364311249-14454-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/udc-core.c | 2 +-
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
1.8.1.2

