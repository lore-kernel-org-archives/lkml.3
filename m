Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030607AbaGRNWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:22:41 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17964 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761312AbaGRNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/170] usb: chipidea: udc: delete td from req's td list at ep_dequeue
Date: Fri, 18 Jul 2014 14:11:16 +0200
Message-Id: <6b94ad95ad64b2a2ca7a26b9fd147ebb5e52383b.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Chen <peter.chen@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e4adcff09ca39ecbcc4851d40d0f0a5458e7b77a upstream.

We need to delete un-finished td from current request's td list
at ep_dequeue API, otherwise, this non-user td will be remained
at td list before this request is freed. So if we do ep_queue->
ep_dequeue->ep_queue sequence, when the complete interrupt for
the second ep_queue comes, we search td list for this request,
the first td (added by the first ep_queue) will be handled, and
its status is still active, so we will consider the this transfer
still not be completed, but in fact, it has completed. It causes
the peripheral side considers it never receives current data for
this transfer.

We met this problem when do "Error Recovery Test - Device Configured"
test item for USBCV2 MSC test, the host has never received ACK for
the IN token for CSW due to peripheral considers it does not get this
CBW, the USBCV test log like belows:

--------------------------------------------------------------------------
INFO
Issuing BOT MSC Reset, reset should always succeed
INFO
Retrieving status on CBW endpoint
INFO
CBW endpoint status = 0x0
INFO
Retrieving status on CSW endpoint
INFO
CSW endpoint status = 0x0
INFO
Issuing required command (Test Unit Ready) to verify device has recovered
INFO
Issuing CBW (attempt #1):
INFO
|----- CBW LUN                  = 0x0
INFO
|----- CBW Flags                = 0x0
INFO
|----- CBW Data Transfer Length = 0x0
INFO
|----- CBW CDB Length           = 0x6
INFO
|----- CBW CDB-00 = 0x0
INFO
|----- CBW CDB-01 = 0x0
INFO
|----- CBW CDB-02 = 0x0
INFO
|----- CBW CDB-03 = 0x0
INFO
|----- CBW CDB-04 = 0x0
INFO
|----- CBW CDB-05 = 0x0
INFO
Issuing CSW : try 1
INFO
CSW Bulk Request timed out!
ERROR
Failed CSW phase : should have been success or stall
FAIL
(5.3.4) The CSW status value must be 0x00, 0x01, or 0x02.
ERROR
BOTCommonMSCRequest failed:  error=80004000

Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/chipidea/udc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 938426ae30de..a18c2cfafe6d 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1325,6 +1325,7 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hw_ep  *hwep  = container_of(ep,  struct ci_hw_ep, ep);
 	struct ci_hw_req *hwreq = container_of(req, struct ci_hw_req, req);
 	unsigned long flags;
+	struct td_node *node, *tmpnode;
 
 	if (ep == NULL || req == NULL || hwreq->req.status != -EALREADY ||
 		hwep->ep.desc == NULL || list_empty(&hwreq->queue) ||
@@ -1335,6 +1336,12 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 
 	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
+	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
+		dma_pool_free(hwep->td_pool, node->ptr, node->dma);
+		list_del(&node->td);
+		kfree(node);
+	}
+
 	/* pop request */
 	list_del_init(&hwreq->queue);
 
-- 
2.0.0

