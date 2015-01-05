Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbbAEJcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:32:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20272 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbbAEJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:32:01 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-ae-54aa5a0f639f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com, paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/2] drivers: usb: dwc2: remove 'force' parameter from
 kill_all_requests()
Date: Mon, 05 Jan 2015 10:31:35 +0100
Message-id: <1420450295-25818-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xgC5/1KoQg58rJSwO3q+3aF68ns3i
	8q45bBaLlrUyW2yfMp3J4sHhnewObB77565h9+jbsorRY8v+z4wex29sZ/L4vEkugDWKyyYl
	NSezLLVI3y6BK6Ol4SBjQZNMxcHPz5gaGLeJdTFyckgImEj8mdTHDmGLSVy4t56ti5GLQ0hg
	EaPE8VuPwRJCAu1MEm07nUBsNgEdiS3fJzCC2CICKhIXn09nAWlgFmhklPjxewYrSEJYIEbi
	6smdbCA2i4CqxMNVq4AaODh4BVwlrm/ghFgmJ3Hy2GSwck4BN4kLV+ezg5QIAZWsXBg2gZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgMHomvYNxVYPFIUYBDkYlHl6PEytDhFgT
	y4orcw8xSnAwK4nwrrsFFOJNSaysSi3Kjy8qzUktPsQozcGiJM6rZN8WIiSQnliSmp2aWpBa
	BJNl4uCUamBcV5f6tb5V5vHPeAObl/b/v97ouJt96HO6QnnGj0MqP3925PNeSpfe5L1h1a6e
	x3efi3V5hE08/buD6+7d7r9hXg0x76Z6/vk0wSW3cuPJE8JC7YW7PuzWOfOW+8+FLx3X/rSd
	2c2an5Qesmty7/eMzN+PpVIrVpUevXE6JIL9VnDvTOYj508LKrEUZyQaajEXFScCAEL657kf	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes in simpler way the bug described in [1] and [2]. It
looks like DWC2 is the only UDC driver that doesn't force usb requests
to complete in ep_disable() function. This causes described problem,
because we have no guarantee that all requests will be completed before
unbind of usb function.

To fix this problem we force all requests of disabled endpoint to complete.
Also currently running request is not handled. This allowed to simplify
code of kill_all_requests() function, because 'force' parameter is always
set to true, so we don't need it anymore.

In s3c_hsotg_rx_data() we change function used to print message when active
request is NULL from dev_warn() to dev_dbg(), because such situation is
harmless for driver and now it can take place during normal endpoint
disabling.

[1] https://lkml.org/lkml/2014/12/9/283
[2] https://lkml.org/lkml/2014/12/12/360

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 200168e..fee0ad5 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1305,7 +1305,7 @@ static void s3c_hsotg_rx_data(struct dwc2_hsotg *hsotg, int ep_idx, int size)
 		u32 epctl = readl(hsotg->regs + DOEPCTL(ep_idx));
 		int ptr;
 
-		dev_warn(hsotg->dev,
+		dev_dbg(hsotg->dev,
 			 "%s: FIFO %d bytes on ep%d but no req (DXEPCTl=0x%08x)\n",
 			 __func__, size, ep_idx, epctl);
 
@@ -1988,30 +1988,23 @@ static void s3c_hsotg_irq_enumdone(struct dwc2_hsotg *hsotg)
  * @hsotg: The device state.
  * @ep: The endpoint the requests may be on.
  * @result: The result code to use.
- * @force: Force removal of any current requests
  *
  * Go through the requests on the given endpoint and mark them
  * completed with the given result code.
  */
 static void kill_all_requests(struct dwc2_hsotg *hsotg,
 			      struct s3c_hsotg_ep *ep,
-			      int result, bool force)
+			      int result)
 {
 	struct s3c_hsotg_req *req, *treq;
 	unsigned size;
 
-	list_for_each_entry_safe(req, treq, &ep->queue, queue) {
-		/*
-		 * currently, we can't do much about an already
-		 * running request on an in endpoint
-		 */
-
-		if (ep->req == req && ep->dir_in && !force)
-			continue;
+	ep->req = NULL;
 
+	list_for_each_entry_safe(req, treq, &ep->queue, queue)
 		s3c_hsotg_complete_request(hsotg, ep, req,
 					   result);
-	}
+
 	if (!hsotg->dedicated_fifos)
 		return;
 	size = (readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4;
@@ -2036,7 +2029,7 @@ void s3c_hsotg_disconnect(struct dwc2_hsotg *hsotg)
 
 	hsotg->connected = 0;
 	for (ep = 0; ep < hsotg->num_of_eps; ep++)
-		kill_all_requests(hsotg, &hsotg->eps[ep], -ESHUTDOWN, true);
+		kill_all_requests(hsotg, &hsotg->eps[ep], -ESHUTDOWN);
 
 	call_gadget(hsotg, disconnect);
 }
@@ -2334,7 +2327,7 @@ irq_retry:
 				       msecs_to_jiffies(200))) {
 
 				kill_all_requests(hsotg, &hsotg->eps[0],
-							  -ECONNRESET, true);
+							  -ECONNRESET);
 
 				s3c_hsotg_core_init_disconnected(hsotg);
 				s3c_hsotg_core_connect(hsotg);
@@ -2588,7 +2581,7 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 	/* terminate all requests with shutdown */
-	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, false);
+	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN);
 
 	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
 	hs_ep->fifo_index = 0;
-- 
1.9.1

