Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LRVIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:08:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3LRVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.4 12/31] usb: dwc3: fix implementation of endpoint wedge
Date: Wed, 18 Dec 2013 13:08:20 -0800
Message-Id: <20131218210523.141680542@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c    |    2 ++
 drivers/usb/dwc3/gadget.c |    5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -380,6 +380,8 @@ static int dwc3_ep0_handle_feature(struc
 			dep = dwc3_wIndex_to_dep(dwc, wIndex);
 			if (!dep)
 				return -EINVAL;
+			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
+				break;
 			ret = __dwc3_gadget_ep_set_halt(dep, set);
 			if (ret)
 				return -EINVAL;
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1101,9 +1101,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 		else
 			dep->flags |= DWC3_EP_STALL;
 	} else {
-		if (dep->flags & DWC3_EP_WEDGE)
-			return 0;
-
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number,
 			DWC3_DEPCMD_CLEARSTALL, &params);
 		if (ret)
@@ -1111,7 +1108,7 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 					value ? "set" : "clear",
 					dep->name);
 		else
-			dep->flags &= ~DWC3_EP_STALL;
+			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
 	}
 
 	return ret;


