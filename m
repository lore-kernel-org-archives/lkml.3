Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaLSJ4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:56:07 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37551 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaLSJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:56:03 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: Peter.Chen@freescale.com
Cc: stefan@agner.ch, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 3/3] usb: chipidea: Add errata for revision 2.40a
Date: Fri, 19 Dec 2014 15:25:29 +0530
Message-Id: <2777af66ca21ac4eb3d534a21ec227eea693245c.1418981438.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At chipidea revision 2.40a, there is a below errata:

9000531823  B2-Medium  Adding a dTD to a Primed Endpoint May Not Get Recognized

Title: Adding a dTD to a Primed Endpoint May Not Get Recognized

Impacted Configuration: All device mode configurations.

Description:
There is an issue with the add dTD tripwire semaphore (ATDTW bit in USBCMD register)
that can cause the controller to ignore a dTD that is added to a primed endpoint.
When this happens, the software can read the tripwire bit and the status bit at '1'
even though the endpoint is unprimed.

After executing a dTD, the device controller endpoint state machine executes a final
read of the dTD terminate bit to check if the application added a dTD to the linked
list at the last moment. This read is done in the finpkt_read_latest_next_td (44) state.
After the read is performed, if the terminate bit is still set, the state machine moves
to unprime the endpoint. The decision to unprime the endpoint is done in the
checkqh_decision (59) state, based on the value of the terminate bit.
Before reaching the checkqh_decision state, the state machine traverses the
writeqhtd_status (57), writeqh_status (56), and release_prime_mask (42) states.
As shown in the waveform, the ep_addtd_tripwire_clr signal is not set to clear
the tripwire bit in these states.

Workaround:
The software must implement a periodic poll cycle, and check for each dTD
pending on execution (Active = 1), if the enpoint is primed. It can do this by reading
the corresponding bits in the ENDPTPRIME and ENDPTSTAT registers. If these bits are
read at 0, the software needs to re-prime the endpoint by writing 1 to the corresponding
bit in the ENDPTPRIME register. This can be done for every microframe, every frame or
with a larger interval, depending on the urgency of transfer execution for the application.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 drivers/usb/chipidea/udc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 0444d3f..551ab37 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -522,6 +522,20 @@ static void free_pending_td(struct ci_hw_ep *hwep)
 	kfree(pending);
 }
 
+static int reprime_dtd(struct ci_hdrc *ci, struct ci_hw_ep *hwep,
+					   struct td_node *node)
+{
+	hwep->qh.ptr->td.next = node->dma;
+	hwep->qh.ptr->td.token &=
+		cpu_to_le32(~(TD_STATUS_HALTED | TD_STATUS_ACTIVE));
+
+	/* Synchronize before ep prime */
+	wmb();
+
+	return hw_ep_prime(ci, hwep->num, hwep->dir,
+				hwep->type == USB_ENDPOINT_XFER_CONTROL);
+}
+
 /**
  * _hardware_dequeue: handles a request at hardware level
  * @gadget: gadget
@@ -535,6 +549,7 @@ static int _hardware_dequeue(struct ci_hw_ep *hwep, struct ci_hw_req *hwreq)
 	struct td_node *node, *tmpnode;
 	unsigned remaining_length;
 	unsigned actual = hwreq->req.length;
+	struct ci_hdrc *ci = hwep->ci;
 
 	if (hwreq->req.status != -EALREADY)
 		return -EINVAL;
@@ -544,6 +559,11 @@ static int _hardware_dequeue(struct ci_hw_ep *hwep, struct ci_hw_req *hwreq)
 	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
 		tmptoken = le32_to_cpu(node->ptr->token);
 		if ((TD_STATUS_ACTIVE & tmptoken) != 0) {
+			int n = hw_ep_bit(hwep->num, hwep->dir);
+
+			if (ci->rev == CI_REVISION_24)
+				if (!hw_read(ci, OP_ENDPTSTAT, BIT(n)))
+					reprime_dtd(ci, hwep, node);
 			hwreq->req.status = -EALREADY;
 			return -EBUSY;
 		}
-- 
1.7.9.5

