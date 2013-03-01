Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3CAUWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:22:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3CATpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 14/77] usb: dwc3: gadget: fix skip LINK_TRB on ISOC
Date: Fri,  1 Mar 2013 11:43:59 -0800
Message-Id: <20130301194353.510721377@linuxfoundation.org>
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

commit 915e202aeeb59e272992a6364c910aaef3073544 upstream.

When we reach to link trb, we just need to increase free_slot and then
calculate TRB. Return is not correct, as it will cause wrong TRB DMA
address to fetch in case of update transfer.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -754,21 +754,18 @@ static void dwc3_prepare_one_trb(struct
 	struct dwc3		*dwc = dep->dwc;
 	struct dwc3_trb		*trb;
 
-	unsigned int		cur_slot;
-
 	dev_vdbg(dwc->dev, "%s: req %p dma %08llx length %d%s%s\n",
 			dep->name, req, (unsigned long long) dma,
 			length, last ? " last" : "",
 			chain ? " chain" : "");
 
-	trb = &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];
-	cur_slot = dep->free_slot;
-	dep->free_slot++;
-
 	/* Skip the LINK-TRB on ISOC */
-	if (((cur_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
+	if (((dep->free_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
 			usb_endpoint_xfer_isoc(dep->endpoint.desc))
-		return;
+		dep->free_slot++;
+
+	trb = &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];
+	dep->free_slot++;
 
 	if (!req->trb) {
 		dwc3_gadget_move_request_queued(req);


