Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3AXVY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:24:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:41148 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab3AXVS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:18:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bart Westgeest <bart@elbrys.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [ 09/15] staging: usbip: changed function return type to void
Date: Thu, 24 Jan 2013 13:18:33 -0800
Message-Id: <20130124211727.217712287@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211723.489089115@linuxfoundation.org>
References: <20130124211723.489089115@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Westgeest <bart@elbrys.com>

commit ac2b41acfa3efe4650102067a99251587a806d70 upstream.

The function usbip_pad_iso never returns anything but 0 (success).

Signed-off-by: Bart Westgeest <bart@elbrys.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/usbip/usbip_common.c |   11 ++++-------
 drivers/staging/usbip/usbip_common.h |    2 +-
 drivers/staging/usbip/vhci_rx.c      |    3 +--
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -761,26 +761,25 @@ EXPORT_SYMBOL_GPL(usbip_recv_iso);
  * buffer and iso packets need to be stored and be in propeper endian in urb
  * before calling this function
  */
-int usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
+void usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
 {
 	int np = urb->number_of_packets;
 	int i;
-	int ret;
 	int actualoffset = urb->actual_length;
 
 	if (!usb_pipeisoc(urb->pipe))
-		return 0;
+		return;
 
 	/* if no packets or length of data is 0, then nothing to unpack */
 	if (np == 0 || urb->actual_length == 0)
-		return 0;
+		return;
 
 	/*
 	 * if actual_length is transfer_buffer_length then no padding is
 	 * present.
 	*/
 	if (urb->actual_length == urb->transfer_buffer_length)
-		return 0;
+		return;
 
 	/*
 	 * loop over all packets from last to first (to prevent overwritting
@@ -792,8 +791,6 @@ int usbip_pad_iso(struct usbip_device *u
 			urb->transfer_buffer + actualoffset,
 			urb->iso_frame_desc[i].actual_length);
 	}
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(usbip_pad_iso);
 
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -327,7 +327,7 @@ int usbip_recv_xbuff(struct usbip_device
 /* some members of urb must be substituted before. */
 int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
 /* some members of urb must be substituted before. */
-int usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
+void usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
 void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
 
 /* usbip_event.c */
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -94,8 +94,7 @@ static void vhci_recv_ret_submit(struct
 		return;
 
 	/* restore the padding in iso packets */
-	if (usbip_pad_iso(ud, urb) < 0)
-		return;
+	usbip_pad_iso(ud, urb);
 
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);


