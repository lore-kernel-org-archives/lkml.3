Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbbAEJcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:32:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35184 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbAEJb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:31:58 -0500
X-AuditID: cbfee61a-f79c06d000004e71-18-54aa5a0cefa2
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com, paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/2] Revert
 "usb: dwc2: gadget: kill requests with 'force' in s3c_hsotg_udc_stop()"
Date: Mon, 05 Jan 2015 10:31:34 +0100
Message-id: <1420450295-25818-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgC5P1KoQg5t/JCwO3q+3aF68ns3i
	8q45bBaLlrUyW2yfMp3J4sHhnewObB77565h9+jbsorRY8v+z4wex29sZ/L4vEkugDWKyyYl
	NSezLLVI3y6BK+Nyp1JBN3/F2mPT2BsYz/N0MXJySAiYSJxe9YYRwhaTuHBvPVsXIxeHkMAi
	RonLC44wQzjtTBJX1sxnAqliE9CR2PJ9AliHiICKxMXn01lAipgFGhklfvyewQqSEBZIlejd
	/A3MZhFQlZi6fxNYA6+Aq8TOpvlsEOvkJE4emwxWwyngJnHh6nz2LkYOoG2uEisXhk1g5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziQnkntYFzZYHGIUYCDUYmH1+PEyhAh1sSy
	4srcQ4wSHMxKIrzrbgGFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrZt4UICaQnlqRmp6YWpBbB
	ZJk4OKUaGJlTO679jLzhrvYs4tCLzJVC0/zm3jLYlXPqi6tfIbOlzCe5yeUSnMv2Obo+991z
	VWSRlr/aR9a+V92/zD9cYhEqZDt244yE2LX+KxkSp74XTvBqV3V2Tmw0M5h57teJhY66v5fO
	F9MW3cQs3/DDuu7PpcaN4ntnxRs8zU8MWFG9L+nprcL4WiWW4oxEQy3mouJEAH3WwtMgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 62f4f0651ce8ef966a0e5b6db6a7a524c268fdd2.

This patch is incomplete solution. It won't work without changes in udc-core,
which were considered as unacceptable (discussion [1]).

[1] https://lkml.org/lkml/2014/12/12/360

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7924200..200168e 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2567,7 +2567,7 @@ error:
  * s3c_hsotg_ep_disable - disable given endpoint
  * @ep: The endpoint to disable.
  */
-static int s3c_hsotg_ep_disable_force(struct usb_ep *ep, bool force)
+static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 {
 	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
@@ -2588,7 +2588,7 @@ static int s3c_hsotg_ep_disable_force(struct usb_ep *ep, bool force)
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 	/* terminate all requests with shutdown */
-	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, force);
+	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, false);
 
 	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
 	hs_ep->fifo_index = 0;
@@ -2609,10 +2609,6 @@ static int s3c_hsotg_ep_disable_force(struct usb_ep *ep, bool force)
 	return 0;
 }
 
-static int s3c_hsotg_ep_disable(struct usb_ep *ep)
-{
-	return s3c_hsotg_ep_disable_force(ep, false);
-}
 /**
  * on_list - check request is on the given endpoint
  * @ep: The endpoint to check.
@@ -2928,7 +2924,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget)
 
 	/* all endpoints should be shutdown */
 	for (ep = 1; ep < hsotg->num_of_eps; ep++)
-		s3c_hsotg_ep_disable_force(&hsotg->eps[ep].ep, true);
+		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
-- 
1.9.1

