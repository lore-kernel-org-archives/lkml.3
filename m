Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJPHlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:41:32 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61180 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaJPHla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:41:30 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context imbalance
Date: Thu, 16 Oct 2014 13:11:10 +0530
Message-Id: <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse was giving the following warning:
        warning: context imbalance in 's3c_hsotg_ep_enable'
	        - different lock contexts for basic block

we were returning ENOMEM while still holding the spinlock.
The sparse warning was fixed by releasing the spinlock before return.

This patch depends on the previous patch of the series.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/dwc2/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index af5517f..05a9a23 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2564,7 +2564,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 		}
 		if (i == 8) {
 			ret = -ENOMEM;
-			goto error1;
+			goto error2;
 		}
 	}
 
@@ -2582,6 +2582,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	/* enable the endpoint interrupt */
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
+error2:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
 error1:
-- 
1.8.1.2

