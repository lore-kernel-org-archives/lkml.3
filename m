Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3FPW2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:28:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46426 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711Ab3FPWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "George Cherian" <george.cherian@ti.com>,
        "Felipe Balbi" <balbi@ti.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.808396678@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [37/83] usb: dwc3: gadget: free trb pool only from epnum 2
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1310,10 +1310,19 @@ static void dwc3_gadget_free_endpoints(s
 
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

