Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJJNJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:09:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42894 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaJJNJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:09:51 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc2: gadget: sparse warning of context imbalance
Date: Fri, 10 Oct 2014 18:39:39 +0530
Message-Id: <1412946579-6805-1-git-send-email-sudipm.mukherjee@gmail.com>
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
 drivers/usb/dwc2/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7b5856f..046e90d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 			hs_ep->fifo_size = val;
 			break;
 		}
-		if (i == 8)
+		if (i == 8) {
+			spin_unlock_irqrestore(&hsotg->lock, flags);
 			return -ENOMEM;
+		}
 	}
 
 	/* for non control endpoints, set PID to D0 */
-- 
1.8.1.2

