Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3ILFlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:41:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab3ILFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:48 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5z3dFwX9d18A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Eq3-d39ABzMA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=UTB_XpHje0EA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=BPSfKMXmiYsA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042907.762229438@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: William Gulland <wgulland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [093/251] usb: Clear both buffers when clearing a control transfer TT buffer.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0093-usb-Clear-both-buffers-when-clearing-a-control-trans.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: William Gulland <wgulland@google.com>

[ Upstream commit 2c7b871b9102c497ba8f972aa5d38532f05b654d ]

Control transfers have both IN and OUT (or SETUP) packets, so when
clearing TT buffers for a control transfer it's necessary to send
two HUB_CLEAR_TT_BUFFER requests to the hub.

Signed-off-by: William Gulland <wgulland@google.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/core/hub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index fe7faf0..74ae3a5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -711,6 +711,15 @@ resubmit:
 static inline int
 hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
 {
+	/* Need to clear both directions for control ep */
+	if (((devinfo >> 11) & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_CONTROL) {
+		int status = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
+				HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
+				devinfo ^ 0x8000, tt, NULL, 0, 1000);
+		if (status)
+			return status;
+	}
 	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
 			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT, devinfo,
 			       tt, NULL, 0, 1000);
-- 
1.7.10.4


