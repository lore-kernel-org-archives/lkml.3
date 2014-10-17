Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaJQEoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 00:44:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55869 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaJQEoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:44:18 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context imbalance
Date: Fri, 17 Oct 2014 10:14:02 +0530
Message-Id: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse was giving the following warning:
        warning: context imbalance in 's3c_hsotg_ep_enable'
	                - different lock contexts for basic block

we were returning ENOMEM while still holding the spinlock.
The sparse warning was fixed by releasing the spinlock before return.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/dwc2/gadget.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7b5856f..7f25527 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 			hs_ep->fifo_size = val;
 			break;
 		}
-		if (i == 8)
-			return -ENOMEM;
+		if (i == 8) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
 
 	/* for non control endpoints, set PID to D0 */
@@ -2579,6 +2581,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	/* enable the endpoint interrupt */
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
+error:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 	return ret;
 }
-- 
1.8.1.2

