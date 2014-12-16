Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaLPKw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:52:59 -0500
Received: from [203.254.224.34] ([203.254.224.34]:15205 "EHLO
	mailout4.samsung.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPKw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:52:57 -0500
X-AuditID: cbfee61a-f79c06d000004e71-39-54900ef46fdb
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, peter.chen@freescale.com,
        stern@rowland.harvard.edu, k.opasiak@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] drivers: usb: dwc2: remove 'force' parameter from
 kill_all_requests()
Date: Tue, 16 Dec 2014 11:51:44 +0100
Message-id: <1418727104-17079-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e+xoO4XvgkhBteWc1s0L17PZnF74jQ2
	i8u75rBZLFrWymyx9shddovtU6YzWRyb/ZfJ4sHhnewWE35fYHPg9Ph3uJ/JY//cNewes+/+
	YPTo27KK0WPL/s+MHp83yQWwRXHZpKTmZJalFunbJXBltDQcZCxokqk4+PkZUwPjNrEuRg4O
	CQETiY1TFbsYOYFMMYkL99azgdhCAtMZJSY/KYKw25kkmrdzgNhsAjoSW75PYARpFQGq//6B
	s4uRi4NZ4DWjxLPlKxhBaoQFIiSO9/xkBrFZBFQlLtzaxgRi8wq4SnxpmswCsUtO4uSxyawT
	GLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOn2dSOxhXNlgcYhTgYFTi4Q0o7A8R
	Yk0sK67MPcQowcGsJMK75T5QiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+SfVuIkEB6Yklqdmpq
	QWoRTJaJg1OqgTH6QVjF9bbbzg93FzDktjSa3/nQovPsm1NbHdv51XtPq9iUxZz/s/nZiulH
	ZLJ8bK4HCvlL2C6pztU+WGYXfcjXXrX3Tr2TjFOF86JdX/VuuSgf4DiVyKux5GaeyjQnF5aL
	12+e4uCpFYx/VXO9T/JTjcuVxV5BT7LDjTf8bp97etu1xaHvwpVYijMSDbWYi4oTAeRG4RYb	AgAA
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

