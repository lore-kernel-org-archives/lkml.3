Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbaJCXwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:52:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaJCVxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 266/357] usb: dwc3: fix TRB completion when multiple TRBs are started
Date: Fri,  3 Oct 2014 14:30:52 -0700
Message-Id: <20141003212941.487301691@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 0b93a4c838fa10370d72f86fe712426ac63804de upstream.

After commit 2ec2a8be (usb: dwc3: gadget:
always enable IOC on bulk/interrupt transfers)
we created a situation where it was possible to
hang a bulk/interrupt endpoint if we had more
than one pending request in our queue and they
were both started with a single Start Transfer
command.

The problems triggers because we had not enabled
Transfer In Progress event for those endpoints
and we were not able to process early giveback
of requests completed without LST bit set.

Fix the problem by finally enabling Xfer In Progress
event for all endpoint types, except control.

Fixes: 2ec2a8be (usb: dwc3: gadget: always
	enable IOC on bulk/interrupt transfers)
Reported-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/dwc3/gadget.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -527,7 +527,7 @@ static int dwc3_gadget_set_ep_config(str
 		dep->stream_capable = true;
 	}
 
-	if (usb_endpoint_xfer_isoc(desc))
+	if (!usb_endpoint_xfer_control(desc))
 		params.param1 |= DWC3_DEPCFG_XFER_IN_PROGRESS_EN;
 
 	/*
@@ -2042,12 +2042,6 @@ static void dwc3_endpoint_interrupt(stru
 		dwc3_endpoint_transfer_complete(dwc, dep, event, 1);
 		break;
 	case DWC3_DEPEVT_XFERINPROGRESS:
-		if (!usb_endpoint_xfer_isoc(dep->endpoint.desc)) {
-			dev_dbg(dwc->dev, "%s is not an Isochronous endpoint\n",
-					dep->name);
-			return;
-		}
-
 		dwc3_endpoint_transfer_complete(dwc, dep, event, 0);
 		break;
 	case DWC3_DEPEVT_XFERNOTREADY:


