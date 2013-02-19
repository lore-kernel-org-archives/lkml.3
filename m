Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802Ab3BSSuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791Ab3BSSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 02/81] xhci: Fix TD size for isochronous URBs.
Date: Tue, 19 Feb 2013 15:48:25 -0300
Message-Id: <1361299784-8830-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 3bf13f8..3dc8e3f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3106,7 +3106,7 @@ static u32 xhci_v1_0_td_remainder(int running_total, int trb_buff_len,
 	 * running_total.
 	 */
 	packets_transferred = (running_total + trb_buff_len) /
-		usb_endpoint_maxp(&urb->ep->desc);
+		GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc));
 
 	if ((total_packet_count - packets_transferred) > 31)
 		return 31 << 17;
@@ -3640,7 +3640,8 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		td_len = urb->iso_frame_desc[i].length;
 		td_remain_len = td_len;
 		total_packet_count = DIV_ROUND_UP(td_len,
-				usb_endpoint_maxp(&urb->ep->desc));
+				GET_MAX_PACKET(
+					usb_endpoint_maxp(&urb->ep->desc)));
 		/* A zero-length transfer still involves at least one packet. */
 		if (total_packet_count == 0)
 			total_packet_count++;
-- 
1.7.9.5

