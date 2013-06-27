Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3F0XK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:10:56 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44307 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3F0XKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:10:55 -0400
From: William Gulland <wgulland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Ming Lei <ming.lei@canonical.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: William Gulland <wgulland@google.com>
Subject: [PATCH] usb: Clear both buffers when clearing a control transfer TT buffer.
Date: Thu, 27 Jun 2013 16:10:20 -0700
Message-Id: <1372374620-11790-1-git-send-email-wgulland@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Control transfers have both IN and OUT (or SETUP) packets, so when
    clearing TT buffers for a control transfer it's necessary to send
    two HUB_CLEAR_TT_BUFFER requests to the hub.

Signed-off-by: William Gulland <wgulland@google.com>
---
 drivers/usb/core/hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index feef935..868ad74 100644
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
-- 
1.8.3

