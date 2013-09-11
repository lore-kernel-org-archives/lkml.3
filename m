Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3IKUMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab3IKUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:12:36 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] HID: sony: use hid_get_raw_report() instead of a direct call to usb
Date: Wed, 11 Sep 2013 22:12:25 +0200
Message-Id: <1378930345-6670-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb packets are exactly the same, but it makes it a little bit more
independent of the transport layer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-sony.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index b18320d..bc37a18 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -419,21 +419,14 @@ static int sixaxis_usb_output_raw_report(struct hid_device *hid, __u8 *buf,
  */
 static int sixaxis_set_operational_usb(struct hid_device *hdev)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct usb_device *dev = interface_to_usbdev(intf);
-	__u16 ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	int ret;
 	char *buf = kmalloc(18, GFP_KERNEL);
 
 	if (!buf)
 		return -ENOMEM;
 
-	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-				 HID_REQ_GET_REPORT,
-				 USB_DIR_IN | USB_TYPE_CLASS |
-				 USB_RECIP_INTERFACE,
-				 (3 << 8) | 0xf2, ifnum, buf, 17,
-				 USB_CTRL_GET_TIMEOUT);
+	ret = hdev->hid_get_raw_report(hdev, 0xf2, buf, 17, HID_FEATURE_REPORT);
+
 	if (ret < 0)
 		hid_err(hdev, "can't set operational mode\n");
 
-- 
1.8.3.1

