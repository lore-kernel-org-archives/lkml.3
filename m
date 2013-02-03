Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3BCPBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:01:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34606 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab3BCO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:23 -0500
Message-Id: <20130203144655.196104219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bart Westgeest <bart@elbrys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 126/128] staging: usbip: changed function return type to void
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Westgeest <bart@elbrys.com>

commit ac2b41acfa3efe4650102067a99251587a806d70 upstream.

The function usbip_pad_iso never returns anything but 0 (success).

Signed-off-by: Bart Westgeest <bart@elbrys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/usbip/usbip_common.c |   11 ++++-------
 drivers/staging/usbip/usbip_common.h |    2 +-
 drivers/staging/usbip/vhci_rx.c      |    3 +--
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index d93e7f1..70f23026 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -735,26 +735,25 @@ EXPORT_SYMBOL_GPL(usbip_recv_iso);
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
@@ -766,8 +765,6 @@ int usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
 			urb->transfer_buffer + actualoffset,
 			urb->iso_frame_desc[i].actual_length);
 	}
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(usbip_pad_iso);
 
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index b8f8c48..c7b888c 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -306,7 +306,7 @@ void usbip_header_correct_endian(struct usbip_header *pdu, int send);
 void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
 /* some members of urb must be substituted before. */
 int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
-int usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
+void usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
 int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
 
 /* usbip_event.c */
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 3f511b4..f5fba732 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -94,8 +94,7 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 		return;
 
 	/* restore the padding in iso packets */
-	if (usbip_pad_iso(ud, urb) < 0)
-		return;
+	usbip_pad_iso(ud, urb);
 
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);


