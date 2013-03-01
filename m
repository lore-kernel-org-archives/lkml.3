Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3CAUXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:23:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3CATpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 13/77] usb: dwc3: gadget: fix isoc END TRANSFER Condition
Date: Fri,  1 Mar 2013 11:43:58 -0800
Message-Id: <20130301194353.395306822@linuxfoundation.org>
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

commit cdc359dd87ab6c39a67dab724fd0b61c16e6f08b upstream.

There were still some corner cases where isoc transfer was not able to
restart, specially when missed isoc does not happen , and in fact gadget does
not queue any new request during giveback.

Cleanup function calls giveback first, which provides a way to queue
another request to gadget. But gadget did not had any data. So , it did
not call ep_queue. To twist it further, gadget did not queue till
cleanup for last queued TRB is called. If we ever reach this scenario,
we must call END TRANSFER, so that we receive a new  xfernotready with
information about current microframe number.

Also insure that there is no request submitted to core when issuing END
TRANSFER.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1091,7 +1091,10 @@ static int __dwc3_gadget_ep_queue(struct
 		 * notion of current microframe.
 		 */
 		if (usb_endpoint_xfer_isoc(dep->endpoint.desc)) {
-			dwc3_stop_active_transfer(dwc, dep->number);
+			if (list_empty(&dep->req_queued)) {
+				dwc3_stop_active_transfer(dwc, dep->number);
+				dep->flags = DWC3_EP_ENABLED;
+			}
 			return 0;
 		}
 
@@ -1728,10 +1731,20 @@ static int dwc3_cleanup_done_reqs(struct
 			break;
 	} while (1);
 
-	if (list_empty(&dep->req_queued) &&
-			(dep->flags & DWC3_EP_MISSED_ISOC)) {
-		dwc3_stop_active_transfer(dwc, dep->number);
-		dep->flags &= ~DWC3_EP_MISSED_ISOC;
+	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			list_empty(&dep->req_queued)) {
+		if (list_empty(&dep->request_list)) {
+			/*
+			 * If there is no entry in request list then do
+			 * not issue END TRANSFER now. Just set PENDING
+			 * flag, so that END TRANSFER is issued when an
+			 * entry is added into request list.
+			 */
+			dep->flags = DWC3_EP_PENDING_REQUEST;
+		} else {
+			dwc3_stop_active_transfer(dwc, dep->number);
+			dep->flags = DWC3_EP_ENABLED;
+		}
 		return 1;
 	}
 


