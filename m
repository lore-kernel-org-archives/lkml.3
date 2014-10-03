Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaJCVpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaJCVnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ronald Wahl <ronald.wahl@raritan.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 001/238] carl9170: fix sending URBs with wrong type when using full-speed
Date: Fri,  3 Oct 2014 14:28:36 -0700
Message-Id: <20141003212913.727739474@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

commit 671796dd96b6cd85b75fba9d3007bcf7e5f7c309 upstream.

The driver assumes that endpoint 4 is always an interrupt endpoint.
Unfortunately the type differs between high-speed and full-speed
configurations while in the former case it is indeed an interrupt
endpoint this is not true for the latter case - here it is a bulk
endpoint. When sending URBs with the wrong type the kernel will
generate a warning message including backtrace. In this specific
case there will be a huge amount of warnings which can bring the system
to freeze.

To fix this we are now sending URBs to endpoint 4 using the type
found in the endpoint descriptor.

A side note: The carl9170 firmware currently specifies endpoint 4 as
interrupt endpoint even in the full-speed configuration but this has
no relevance because before this firmware is loaded the endpoint type
is as described above and after the firmware is running the stick is not
reenumerated and so the old descriptor is used.

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 
 drivers/net/wireless/ath/carl9170/usb.c      |   31 +++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -256,6 +256,7 @@ struct ar9170 {
 	atomic_t rx_work_urbs;
 	atomic_t rx_pool_urbs;
 	kernel_ulong_t features;
+	bool usb_ep_cmd_is_bulk;
 
 	/* firmware settings */
 	struct completion fw_load_wait;
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -621,9 +621,16 @@ int __carl9170_exec_cmd(struct ar9170 *a
 		goto err_free;
 	}
 
-	usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
-		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
-		carl9170_usb_cmd_complete, ar, 1);
+	if (ar->usb_ep_cmd_is_bulk)
+		usb_fill_bulk_urb(urb, ar->udev,
+				  usb_sndbulkpipe(ar->udev, AR9170_USB_EP_CMD),
+				  cmd, cmd->hdr.len + 4,
+				  carl9170_usb_cmd_complete, ar);
+	else
+		usb_fill_int_urb(urb, ar->udev,
+				 usb_sndintpipe(ar->udev, AR9170_USB_EP_CMD),
+				 cmd, cmd->hdr.len + 4,
+				 carl9170_usb_cmd_complete, ar, 1);
 
 	if (free_buf)
 		urb->transfer_flags |= URB_FREE_BUFFER;
@@ -1032,9 +1039,10 @@ static void carl9170_usb_firmware_step2(
 static int carl9170_usb_probe(struct usb_interface *intf,
 			      const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *ep;
 	struct ar9170 *ar;
 	struct usb_device *udev;
-	int err;
+	int i, err;
 
 	err = usb_reset_device(interface_to_usbdev(intf));
 	if (err)
@@ -1050,6 +1058,21 @@ static int carl9170_usb_probe(struct usb
 	ar->intf = intf;
 	ar->features = id->driver_info;
 
+	/* We need to remember the type of endpoint 4 because it differs
+	 * between high- and full-speed configuration. The high-speed
+	 * configuration specifies it as interrupt and the full-speed
+	 * configuration as bulk endpoint. This information is required
+	 * later when sending urbs to that endpoint.
+	 */
+	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
+		ep = &intf->cur_altsetting->endpoint[i].desc;
+
+		if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
+		    usb_endpoint_dir_out(ep) &&
+		    usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK)
+			ar->usb_ep_cmd_is_bulk = true;
+	}
+
 	usb_set_intfdata(intf, ar);
 	SET_IEEE80211_DEV(ar->hw, &intf->dev);
 


