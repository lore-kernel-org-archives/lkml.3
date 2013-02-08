Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3BHBML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:12:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499Ab3BHA5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 32/34] xhci: Fix TD size for isochronous URBs.
Date: Thu,  7 Feb 2013 16:57:28 -0800
Message-Id: <20130208004632.182435386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit f18f8ed2a9adc41c2d9294b85b6af115829d2af1 upstream.

To calculate the TD size for a particular TRB in an isoc TD, we need
know the endpoint's max packet size.  Isochronous endpoints also encode
the number of additional service opportunities in their wMaxPacketSize
field.  The TD size calculation did not mask off those bits before using
the field.  This resulted in incorrect TD size information for
isochronous TRBs when an URB frame buffer crossed a 64KB boundary.

For example:
 - an isoc endpoint has 2 additional service opportunites and
   a max packet size of 1020 bytes
 - a frame transfer buffer contains 3060 bytes
 - one frame buffer crosses a 64KB boundary, and must be split into
   one 1276 byte TRB, and one 1784 byte TRB.

The TD size is is the number of packets that remain to be transferred
for a TD after processing all the max packet sized packets in the
current TRB and all previous TRBs.

For this TD, the number of packets to be transferred is (3060 / 1020),
or 3.  The first TRB contains 1276 bytes, which means it contains one
full packet, and a 256 byte remainder.  After processing all the max
packet-sized packets in the first TRB, the host will have 2 packets left
to transfer.

The old code would calculate the TD size for the first TRB as:

total packet count = DIV_ROUND_UP (TD length / endpoint wMaxPacketSize)
total packet count - (first TRB length / endpoint wMaxPacketSize)

The math should have been:

total packet count = DIV_ROUND_UP (3060 / 1020) = 3
3 - (1276 / 1020) = 2

Since the old code didn't mask off the additional service interval bits
from the wMaxPacketSize field, the math ended up as

total packet count = DIV_ROUND_UP (3060 / 5116) = 1
1 - (1276 / 5116) = 1

Fix this by masking off the number of additional service opportunities
in the wMaxPacketSize field.

This patch should be backported to stable kernels as old as 3.0, that
contain the commit 4da6e6f247a2601ab9f1e63424e4d944ed4124f3 "xhci 1.0:
Update TD size field format."  It may not apply well to kernels older
than 3.2 because of commit 29cc88979a8818cd8c5019426e945aed118b400e
"USB: use usb_endpoint_maxp() instead of le16_to_cpu()".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3108,7 +3108,7 @@ static u32 xhci_v1_0_td_remainder(int ru
 	 * running_total.
 	 */
 	packets_transferred = (running_total + trb_buff_len) /
-		usb_endpoint_maxp(&urb->ep->desc);
+		GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc));
 
 	if ((total_packet_count - packets_transferred) > 31)
 		return 31 << 17;
@@ -3642,7 +3642,8 @@ static int xhci_queue_isoc_tx(struct xhc
 		td_len = urb->iso_frame_desc[i].length;
 		td_remain_len = td_len;
 		total_packet_count = DIV_ROUND_UP(td_len,
-				usb_endpoint_maxp(&urb->ep->desc));
+				GET_MAX_PACKET(
+					usb_endpoint_maxp(&urb->ep->desc)));
 		/* A zero-length transfer still involves at least one packet. */
 		if (total_packet_count == 0)
 			total_packet_count++;


