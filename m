Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3APQ46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:56:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab3APQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephan Gatzka <stephan.gatzka@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 068/222] firewire: net: Fix handling of fragmented multicast/broadcast packets.
Date: Wed, 16 Jan 2013 13:54:28 -0200
Message-Id: <1358351822-7675-69-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gatzka <stephan.gatzka@gmail.com>

commit 9d2373420900a39f5212a3b289331aa3535b1000 upstream.

This patch fixes both the transmit and receive portion of sending
fragmented mutlicast and broadcast packets.

The transmit section was broken because the offset for INTFRAG and
LASTFRAG packets were just miscalculated by IEEE1394_GASP_HDR_SIZE (which
was reserved with skb_push() in fwnet_send_packet).

The receive section was broken because in fwnet_incoming_packet is a call
to fwnet_peer_find_by_node_id(). Called with generation == -1 it will
not find a peer and the partial datagrams are associated to a peer.

[Stefan R:  The fix to use context->card->generation is not perfect.
It relies on the IR tasklet which processes packets from the prior bus
generation to run before the self-ID-complete worklet which sets the
current card generation.  Alas, there is no simple way of a race-free
implementation.  Let's do it this way for now.]

Signed-off-by: Stephan Gatzka <stephan.gatzka@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/firewire/net.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 08c6749..638e1f7 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -861,8 +861,8 @@ static void fwnet_receive_broadcast(struct fw_iso_context *context,
 	if (specifier_id == IANA_SPECIFIER_ID && ver == RFC2734_SW_VERSION) {
 		buf_ptr += 2;
 		length -= IEEE1394_GASP_HDR_SIZE;
-		fwnet_incoming_packet(dev, buf_ptr, length,
-				      source_node_id, -1, true);
+		fwnet_incoming_packet(dev, buf_ptr, length, source_node_id,
+				      context->card->generation, true);
 	}
 
 	packet.payload_length = dev->rcv_buffer_size;
@@ -958,7 +958,12 @@ static void fwnet_transmit_packet_done(struct fwnet_packet_task *ptask)
 			break;
 		}
 
-		skb_pull(skb, ptask->max_payload);
+		if (ptask->dest_node == IEEE1394_ALL_NODES) {
+			skb_pull(skb,
+				 ptask->max_payload + IEEE1394_GASP_HDR_SIZE);
+		} else {
+			skb_pull(skb, ptask->max_payload);
+		}
 		if (ptask->outstanding_pkts > 1) {
 			fwnet_make_sf_hdr(&ptask->hdr, RFC2374_HDR_INTFRAG,
 					  dg_size, fg_off, datagram_label);
@@ -1062,7 +1067,7 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
 		smp_rmb();
 		node_id = dev->card->node_id;
 
-		p = skb_push(ptask->skb, 8);
+		p = skb_push(ptask->skb, IEEE1394_GASP_HDR_SIZE);
 		put_unaligned_be32(node_id << 16 | IANA_SPECIFIER_ID >> 8, p);
 		put_unaligned_be32((IANA_SPECIFIER_ID & 0xff) << 24
 						| RFC2734_SW_VERSION, &p[4]);
-- 
1.7.9.5

