Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3FRLoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3FRLn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:43:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/93] usb: dwc3: gadget: free trb pool only from epnum 2
Date: Tue, 18 Jun 2013 12:42:17 +0100
Message-Id: <1371555821-12820-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

commit 5bf8fae33d14cc5c3c53a926f9079f92c8b082b0 upstream.

we never allocate a TRB pool for physical endpoints
0 and 1 so trying to free it (a invalid TRB pool pointer)
will lead us in a warning while removing dwc3.ko module.

In order to fix the situation, all we have to do is skip
dwc3_free_trb_pool() for physical endpoints 0 and 1 just
as we while deleting endpoints from the endpoints list.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backport to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index fae7885..3530c2b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1537,10 +1537,19 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 
 	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		dep = dwc->eps[epnum];
-		dwc3_free_trb_pool(dep);
-
-		if (epnum != 0 && epnum != 1)
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
1.8.1.2

