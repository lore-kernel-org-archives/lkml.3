Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab3HIB7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967555Ab3HIB7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 047/102] Bluetooth: ath3k: dont use stack memory for DMA
Date: Thu,  8 Aug 2013 18:57:23 -0700
Message-Id: <20130809015021.095492230@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 517828a87994f41af6ae5a0f96f0f069f05baa81 upstream.

Memory allocated by vmalloc (including stack) can not be used for DMA,
i.e. data pointer on usb_control_msg() should not point to stack memory.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=977558

Reported-and-tested-by: Andy Lawrence <dr.diesel@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -195,24 +195,44 @@ error:
 
 static int ath3k_get_state(struct usb_device *udev, unsigned char *state)
 {
-	int pipe = 0;
+	int ret, pipe = 0;
+	char *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETSTATE,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-			state, 0x01, USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETSTATE,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, sizeof(*buf), USB_CTRL_SET_TIMEOUT);
+
+	*state = *buf;
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_get_version(struct usb_device *udev,
 			struct ath3k_version *version)
 {
-	int pipe = 0;
+	int ret, pipe = 0;
+	struct ath3k_version *buf;
+	const int size = sizeof(*buf);
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETVERSION,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, version,
-			sizeof(struct ath3k_version),
-			USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETVERSION,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, size, USB_CTRL_SET_TIMEOUT);
+
+	memcpy(version, buf, size);
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_load_fwfile(struct usb_device *udev,


