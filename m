Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab3GCTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:09:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab3GCTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:26 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jrjAHQ85pKUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=x91BobN0pdQA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=f0kB0LozuS0uFcChkW8A:9 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184103.516479612@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [101/141] usb: dwc3: gadget: free trb pool only from epnum 2
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0101-usb-dwc3-gadget-free-trb-pool-only-from-epnum-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

[ Upstream commit 5bf8fae33d14cc5c3c53a926f9079f92c8b082b0 ]

we never allocate a TRB pool for physical endpoints
0 and 1 so trying to free it (a invalid TRB pool pointer)
will lead us in a warning while removing dwc3.ko module.

In order to fix the situation, all we have to do is skip
dwc3_free_trb_pool() for physical endpoints 0 and 1 just
as we while deleting endpoints from the endpoints list.

Cc: stable@vger.kernel.org
Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/dwc3/gadget.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index eb0fd10..8212dbb 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1650,10 +1650,21 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 
 	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		dep = dwc->eps[epnum];
-		dwc3_free_trb_pool(dep);
-
-		if (epnum != 0 && epnum != 1)
+		if (!dep)
+			continue;
+		/*
+		 * Physical endpoints 0 and 1 are special; they form the
+		 * bi-directional USB endpoint 0.
+		 *
+		 * For those two physical endpoints, we don't allocate a TRB
+		 * pool nor do we add them the endpoints list. Due to that, we
+		 * shouldn't do these two operations otherwise we would end up
+		 * with all sorts of bugs when removing dwc3.ko.
+		 */
+		if (epnum != 0 && epnum != 1) {
+			dwc3_free_trb_pool(dep);
 			list_del(&dep->endpoint.ep_list);
+		}
 
 		kfree(dep);
 	}
-- 
1.7.10.4


