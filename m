Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbaHHUsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:48:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaHHUsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:48:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/259] usb: chipidea: udc: delete td from req's td list at ep_dequeue
Date: Fri,  8 Aug 2014 13:37:50 -0700
Message-Id: <1407530482-4483-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/chipidea/udc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 27ff872..71d0d35 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1326,6 +1326,7 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hw_ep  *hwep  = container_of(ep,  struct ci_hw_ep, ep);
 	struct ci_hw_req *hwreq = container_of(req, struct ci_hw_req, req);
 	unsigned long flags;
+	struct td_node *node, *tmpnode;
 
 	if (ep == NULL || req == NULL || hwreq->req.status != -EALREADY ||
 		hwep->ep.desc == NULL || list_empty(&hwreq->queue) ||
@@ -1336,6 +1337,12 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 
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
1.9.1

