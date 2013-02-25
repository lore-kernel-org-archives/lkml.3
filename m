Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3BYW3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:29:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab3BYWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 23/58] rtlwifi: usb: allocate URB control message setup_packet and data buffer separately
Date: Mon, 25 Feb 2013 14:19:19 -0800
Message-Id: <20130225221641.065210416@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit bc6b89237acb3dee6af6e64e51a18255fef89cc2 upstream.

rtlwifi allocates both setup_packet and data buffer of control message urb,
using shared kmalloc in _usbctrl_vendorreq_async_write. Structure used for
allocating is:
	struct {
		u8 data[254];
		struct usb_ctrlrequest dr;
	};

Because 'struct usb_ctrlrequest' is __packed, setup packet is unaligned and
DMA mapping of both 'data' and 'dr' confuses ARM/sunxi, leading to memory
corruptions and freezes.

Patch changes setup packet to be allocated separately.

[v2]:
 - Use WARN_ON_ONCE instead of WARN_ON

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/usb.c |   44 +++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -42,8 +42,12 @@
 
 static void usbctrl_async_callback(struct urb *urb)
 {
-	if (urb)
-		kfree(urb->context);
+	if (urb) {
+		/* free dr */
+		kfree(urb->setup_packet);
+		/* free databuf */
+		kfree(urb->transfer_buffer);
+	}
 }
 
 static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
@@ -55,39 +59,47 @@ static int _usbctrl_vendorreq_async_writ
 	u8 reqtype;
 	struct usb_ctrlrequest *dr;
 	struct urb *urb;
-	struct rtl819x_async_write_data {
-		u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
-		struct usb_ctrlrequest dr;
-	} *buf;
+	const u16 databuf_maxlen = REALTEK_USB_VENQT_MAX_BUF_SIZE;
+	u8 *databuf;
+
+	if (WARN_ON_ONCE(len > databuf_maxlen))
+		len = databuf_maxlen;
 
 	pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	reqtype =  REALTEK_USB_VENQT_WRITE;
 
-	buf = kmalloc(sizeof(*buf), GFP_ATOMIC);
-	if (!buf)
+	dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
+	if (!dr)
 		return -ENOMEM;
 
+	databuf = kmalloc(databuf_maxlen, GFP_ATOMIC);
+	if (!databuf) {
+		kfree(dr);
+		return -ENOMEM;
+	}
+
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
-		kfree(buf);
+		kfree(databuf);
+		kfree(dr);
 		return -ENOMEM;
 	}
 
-	dr = &buf->dr;
-
 	dr->bRequestType = reqtype;
 	dr->bRequest = request;
 	dr->wValue = cpu_to_le16(value);
 	dr->wIndex = cpu_to_le16(index);
 	dr->wLength = cpu_to_le16(len);
 	/* data are already in little-endian order */
-	memcpy(buf, pdata, len);
+	memcpy(databuf, pdata, len);
 	usb_fill_control_urb(urb, udev, pipe,
-			     (unsigned char *)dr, buf, len,
-			     usbctrl_async_callback, buf);
+			     (unsigned char *)dr, databuf, len,
+			     usbctrl_async_callback, NULL);
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
-	if (rc < 0)
-		kfree(buf);
+	if (rc < 0) {
+		kfree(databuf);
+		kfree(dr);
+	}
 	usb_free_urb(urb);
 	return rc;
 }


