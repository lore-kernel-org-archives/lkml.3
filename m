Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3LSL63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LSL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 128/208] usb: dwc3: fix implementation of endpoint wedge
Date: Thu, 19 Dec 2013 11:53:46 +0000
Message-Id: <1387454106-19326-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/ep0.c    | 2 ++
 drivers/usb/dwc3/gadget.c | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 5acbb94..3cea676 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -478,6 +478,8 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 			dep = dwc3_wIndex_to_dep(dwc, wIndex);
 			if (!dep)
 				return -EINVAL;
+			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
+				break;
 			ret = __dwc3_gadget_ep_set_halt(dep, set);
 			if (ret)
 				return -EINVAL;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 14d28d6..69948ad 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1220,9 +1220,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
 		else
 			dep->flags |= DWC3_EP_STALL;
 	} else {
-		if (dep->flags & DWC3_EP_WEDGE)
-			return 0;
-
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number,
 			DWC3_DEPCMD_CLEARSTALL, &params);
 		if (ret)
@@ -1230,7 +1227,7 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
 					value ? "set" : "clear",
 					dep->name);
 		else
-			dep->flags &= ~DWC3_EP_STALL;
+			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
 	}
 
 	return ret;
-- 
1.8.3.2

