Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3HQAIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:08:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3HPWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: William Gulland <wgulland@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 041/133] usb: Clear both buffers when clearing a control transfer TT buffer.
Date: Fri, 16 Aug 2013 15:33:03 -0700
Message-Id: <1376692475-28413-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Gulland <wgulland@google.com>

commit 2c7b871b9102c497ba8f972aa5d38532f05b654d upstream.

Control transfers have both IN and OUT (or SETUP) packets, so when
clearing TT buffers for a control transfer it's necessary to send
two HUB_CLEAR_TT_BUFFER requests to the hub.

Signed-off-by: William Gulland <wgulland@google.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2a89588..d96ca07 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -725,6 +725,15 @@ resubmit:
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
1.8.1.2

