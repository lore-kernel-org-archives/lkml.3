Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3HBKxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:53:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab3HBKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        William Gulland <wgulland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 32/99] usb: Clear both buffers when clearing a control transfer TT buffer.
Date: Fri,  2 Aug 2013 18:07:45 +0800
Message-Id: <20130802100230.567514598@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Gulland <wgulland@google.com>

commit 2c7b871b9102c497ba8f972aa5d38532f05b654d upstream.

Control transfers have both IN and OUT (or SETUP) packets, so when
clearing TT buffers for a control transfer it's necessary to send
two HUB_CLEAR_TT_BUFFER requests to the hub.

Signed-off-by: William Gulland <wgulland@google.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -668,6 +668,15 @@ resubmit:
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


