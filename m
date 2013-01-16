Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3APP6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3APP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 022/222] xHCI: Fix TD Size calculation on 1.0 hosts.
Date: Wed, 16 Jan 2013 13:53:42 -0200
Message-Id: <1358351822-7675-23-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 4525c0a10dff7ad3669763c28016c7daffc3900e upstream.

The xHCI 1.0 specification made a change to the TD Size field in TRBs.
The value is now the number of packets that remain to be sent in the TD,
not including this TRB.  The TD Size value for the last TRB in a TD must
always be zero.

The xHCI function xhci_v1_0_td_remainder() attempts to calculate this,
but it gets it wrong.  First, it erroneously reuses the old
xhci_td_remainder function, which will right shift the value by 10.  The
xHCI 1.0 spec as of June 2011 says nothing about right shifting by 10.
Second, it does not set the TD size for the last TRB in a TD to zero.

Third, it uses roundup instead of DIV_ROUND_UP.  The total packet count
is supposed to be the total number of bytes in this TD, divided by the
max packet size, rounded up.  DIV_ROUND_UP is the right function to use
in that case.

With the old code, a TD on an endpoint with max packet size 1024 would
be set up like so:
TRB 1, TRB length = 600 bytes, TD size = 0
TRB 1, TRB length = 200 bytes, TD size = 0
TRB 1, TRB length = 100 bytes, TD size = 0

With the new code, the TD would be set up like this:
TRB 1, TRB length = 600 bytes, TD size = 1
TRB 1, TRB length = 200 bytes, TD size = 1
TRB 1, TRB length = 100 bytes, TD size = 0

This commit should be backported to kernels as old as 3.0, that contain
the commit 4da6e6f247a2601ab9f1e63424e4d944ed4124f3 "xhci 1.0: Update TD
size field format."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Chintan Mehta <chintan.mehta@sibridgetech.com>
Reported-by: Shimmer Huang <shimmering.h@gmail.com>
Tested-by: Bhavik Kothari <bhavik.kothari@sibridgetech.com>
Tested-by: Shimmer Huang <shimmering.h@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 755858e..7ac8c9fa 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3069,11 +3069,11 @@ static u32 xhci_td_remainder(unsigned int remainder)
 }
 
 /*
- * For xHCI 1.0 host controllers, TD size is the number of packets remaining in
- * the TD (*not* including this TRB).
+ * For xHCI 1.0 host controllers, TD size is the number of max packet sized
+ * packets remaining in the TD (*not* including this TRB).
  *
  * Total TD packet count = total_packet_count =
- *     roundup(TD size in bytes / wMaxPacketSize)
+ *     DIV_ROUND_UP(TD size in bytes / wMaxPacketSize)
  *
  * Packets transferred up to and including this TRB = packets_transferred =
  *     rounddown(total bytes transferred including this TRB / wMaxPacketSize)
@@ -3081,15 +3081,16 @@ static u32 xhci_td_remainder(unsigned int remainder)
  * TD size = total_packet_count - packets_transferred
  *
  * It must fit in bits 21:17, so it can't be bigger than 31.
+ * The last TRB in a TD must have the TD size set to zero.
  */
-
 static u32 xhci_v1_0_td_remainder(int running_total, int trb_buff_len,
-		unsigned int total_packet_count, struct urb *urb)
+		unsigned int total_packet_count, struct urb *urb,
+		unsigned int num_trbs_left)
 {
 	int packets_transferred;
 
 	/* One TRB with a zero-length data packet. */
-	if (running_total == 0 && trb_buff_len == 0)
+	if (num_trbs_left == 0 || (running_total == 0 && trb_buff_len == 0))
 		return 0;
 
 	/* All the TRB queueing functions don't count the current TRB in
@@ -3098,7 +3099,9 @@ static u32 xhci_v1_0_td_remainder(int running_total, int trb_buff_len,
 	packets_transferred = (running_total + trb_buff_len) /
 		usb_endpoint_maxp(&urb->ep->desc);
 
-	return xhci_td_remainder(total_packet_count - packets_transferred);
+	if ((total_packet_count - packets_transferred) > 31)
+		return 31 << 17;
+	return (total_packet_count - packets_transferred) << 17;
 }
 
 static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
@@ -3125,7 +3128,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 
 	num_trbs = count_sg_trbs_needed(xhci, urb);
 	num_sgs = urb->num_mapped_sgs;
-	total_packet_count = roundup(urb->transfer_buffer_length,
+	total_packet_count = DIV_ROUND_UP(urb->transfer_buffer_length,
 			usb_endpoint_maxp(&urb->ep->desc));
 
 	trb_buff_len = prepare_transfer(xhci, xhci->devs[slot_id],
@@ -3208,7 +3211,8 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 					running_total);
 		} else {
 			remainder = xhci_v1_0_td_remainder(running_total,
-					trb_buff_len, total_packet_count, urb);
+					trb_buff_len, total_packet_count, urb,
+					num_trbs - 1);
 		}
 		length_field = TRB_LEN(trb_buff_len) |
 			remainder |
@@ -3316,7 +3320,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	start_cycle = ep_ring->cycle_state;
 
 	running_total = 0;
-	total_packet_count = roundup(urb->transfer_buffer_length,
+	total_packet_count = DIV_ROUND_UP(urb->transfer_buffer_length,
 			usb_endpoint_maxp(&urb->ep->desc));
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
@@ -3362,7 +3366,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 					running_total);
 		} else {
 			remainder = xhci_v1_0_td_remainder(running_total,
-					trb_buff_len, total_packet_count, urb);
+					trb_buff_len, total_packet_count, urb,
+					num_trbs - 1);
 		}
 		length_field = TRB_LEN(trb_buff_len) |
 			remainder |
@@ -3625,7 +3630,7 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		addr = start_addr + urb->iso_frame_desc[i].offset;
 		td_len = urb->iso_frame_desc[i].length;
 		td_remain_len = td_len;
-		total_packet_count = roundup(td_len,
+		total_packet_count = DIV_ROUND_UP(td_len,
 				usb_endpoint_maxp(&urb->ep->desc));
 		/* A zero-length transfer still involves at least one packet. */
 		if (total_packet_count == 0)
@@ -3704,7 +3709,8 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 			} else {
 				remainder = xhci_v1_0_td_remainder(
 						running_total, trb_buff_len,
-						total_packet_count, urb);
+						total_packet_count, urb,
+						(trbs_per_td - j - 1));
 			}
 			length_field = TRB_LEN(trb_buff_len) |
 				remainder |
-- 
1.7.9.5

