Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaGHBRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:17:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaGGXxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.15 016/122] usb: chipidea: udc: delete td from reqs td list at ep_dequeue
Date: Mon,  7 Jul 2014 16:56:18 -0700
Message-Id: <20140707235734.733467368@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/chipidea/udc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1328,6 +1328,7 @@ static int ep_dequeue(struct usb_ep *ep,
 	struct ci_hw_ep  *hwep  = container_of(ep,  struct ci_hw_ep, ep);
 	struct ci_hw_req *hwreq = container_of(req, struct ci_hw_req, req);
 	unsigned long flags;
+	struct td_node *node, *tmpnode;
 
 	if (ep == NULL || req == NULL || hwreq->req.status != -EALREADY ||
 		hwep->ep.desc == NULL || list_empty(&hwreq->queue) ||
@@ -1338,6 +1339,12 @@ static int ep_dequeue(struct usb_ep *ep,
 
 	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
+	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
+		dma_pool_free(hwep->td_pool, node->ptr, node->dma);
+		list_del(&node->td);
+		kfree(node);
+	}
+
 	/* pop request */
 	list_del_init(&hwreq->queue);
 


