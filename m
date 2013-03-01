Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3CAUYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:24:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3CATpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 12/77] usb: dwc3: gadget: fix missed isoc
Date: Fri,  1 Mar 2013 11:43:57 -0800
Message-Id: <20130301194353.294521620@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit 7efea86c2868b8fd9df65e589e33aebe498ce21d upstream.

There are two reasons to generate missed isoc.

1. when the host does not poll for all the data.
2. because of application-side delays that prevent all the data from
being transferred in programmed microframe.

Current code was able to handle first case only.  This patch handles
scenario 2 as well.Scenario 2 sometime may occur with complex gadget
application, however it can be easily reproduced for testing purpose as
follows:

a. use isoc binterval as 1 in f_sourcesink.
b. use pattern=0
c. introduce a delay of 150us deliberately in source_sink_complete, so
that after few frames it lands into scenario 2.
d. now run testusb 16 (isoc in  test). You will notice that if this
patch is not applied then isoc transfer is not able to recover after
first missed.

Current patch's approach is as under:

If missed isoc occurs and there is no request queued then issue END
TRANSFER, so that core generates next xfernotready and we will issue a
fresh START TRANSFER.
If there are still queued request then wait, do not issue either END or
UPDATE TRANSFER, just attach next request in request_list during giveback.
If any future queued request is successfully transferred then we will issue
UPDATE TRANSFER for all request in the request_list.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.h   |    2 --
 drivers/usb/dwc3/gadget.c |   36 ++++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -405,7 +405,6 @@ struct dwc3_event_buffer {
  * @number: endpoint number (1 - 15)
  * @type: set to bmAttributes & USB_ENDPOINT_XFERTYPE_MASK
  * @resource_index: Resource transfer index
- * @current_uf: Current uf received through last event parameter
  * @interval: the intervall on which the ISOC transfer is started
  * @name: a human readable name e.g. ep1out-bulk
  * @direction: true for TX, false for RX
@@ -439,7 +438,6 @@ struct dwc3_ep {
 	u8			number;
 	u8			type;
 	u8			resource_index;
-	u16			current_uf;
 	u32			interval;
 
 	char			name[20];
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1117,16 +1117,6 @@ static int __dwc3_gadget_ep_queue(struct
 					dep->name);
 	}
 
-	/*
-	 * 3. Missed ISOC Handling. We need to start isoc transfer on the saved
-	 * uframe number.
-	 */
-	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
-		(dep->flags & DWC3_EP_MISSED_ISOC)) {
-			__dwc3_gadget_start_isoc(dwc, dep, dep->current_uf);
-			dep->flags &= ~DWC3_EP_MISSED_ISOC;
-	}
-
 	return 0;
 }
 
@@ -1689,14 +1679,29 @@ static int dwc3_cleanup_done_reqs(struct
 				if (trb_status == DWC3_TRBSTS_MISSED_ISOC) {
 					dev_dbg(dwc->dev, "incomplete IN transfer %s\n",
 							dep->name);
-					dep->current_uf = event->parameters &
-						~(dep->interval - 1);
+					/*
+					 * If missed isoc occurred and there is
+					 * no request queued then issue END
+					 * TRANSFER, so that core generates
+					 * next xfernotready and we will issue
+					 * a fresh START TRANSFER.
+					 * If there are still queued request
+					 * then wait, do not issue either END
+					 * or UPDATE TRANSFER, just attach next
+					 * request in request_list during
+					 * giveback.If any future queued request
+					 * is successfully transferred then we
+					 * will issue UPDATE TRANSFER for all
+					 * request in the request_list.
+					 */
 					dep->flags |= DWC3_EP_MISSED_ISOC;
 				} else {
 					dev_err(dwc->dev, "incomplete IN transfer %s\n",
 							dep->name);
 					status = -ECONNRESET;
 				}
+			} else {
+				dep->flags &= ~DWC3_EP_MISSED_ISOC;
 			}
 		} else {
 			if (count && (event->status & DEPEVT_STATUS_SHORT))
@@ -1723,6 +1728,13 @@ static int dwc3_cleanup_done_reqs(struct
 			break;
 	} while (1);
 
+	if (list_empty(&dep->req_queued) &&
+			(dep->flags & DWC3_EP_MISSED_ISOC)) {
+		dwc3_stop_active_transfer(dwc, dep->number);
+		dep->flags &= ~DWC3_EP_MISSED_ISOC;
+		return 1;
+	}
+
 	if ((event->status & DEPEVT_STATUS_IOC) &&
 			(trb->ctrl & DWC3_TRB_CTRL_IOC))
 		return 0;


