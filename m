Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3L2Ccu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:32:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805Ab3L2CKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pratyush Anand" <pratyush.anand@st.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.675755596@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 093/185] usb: dwc3: fix implementation of endpoint wedge
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a535d81c92615b8ffb99b7e1fd1fb01effaed1af upstream.

The dwc3 UDC driver doesn't implement endpoint wedging correctly.
When an endpoint is wedged, the gadget driver should be allowed to
clear the wedge by calling usb_ep_clear_halt().  Only the host is
prevented from resetting the endpoint.

This patch fixes the implementation.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/ep0.c    | 2 ++
 drivers/usb/dwc3/gadget.c | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -394,6 +394,8 @@ static int dwc3_ep0_handle_feature(struc
 			dep =  dwc3_wIndex_to_dep(dwc, ctrl->wIndex);
 			if (!dep)
 				return -EINVAL;
+			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
+				break;
 			ret = __dwc3_gadget_ep_set_halt(dep, set);
 			if (ret)
 				return -EINVAL;
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -903,9 +903,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 		else
 			dep->flags |= DWC3_EP_STALL;
 	} else {
-		if (dep->flags & DWC3_EP_WEDGE)
-			return 0;
-
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number,
 			DWC3_DEPCMD_CLEARSTALL, &params);
 		if (ret)
@@ -913,7 +910,7 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 					value ? "set" : "clear",
 					dep->name);
 		else
-			dep->flags &= ~DWC3_EP_STALL;
+			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
 	}
 
 	return ret;

