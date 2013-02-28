Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab3B1P0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:26:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3B1OqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/139] usb: dwc3: gadget: fix skip LINK_TRB on ISOC
Date: Thu, 28 Feb 2013 14:42:38 +0000
Message-Id: <1362062689-2567-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit 915e202aeeb59e272992a6364c910aaef3073544 upstream.

When we reach to link trb, we just need to increase free_slot and then
calculate TRB. Return is not correct, as it will cause wrong TRB DMA
address to fetch in case of update transfer.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index edfff45..9ba53de 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -710,21 +710,18 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
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
-- 
1.8.1.2

