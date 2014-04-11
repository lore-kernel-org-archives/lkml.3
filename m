Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbaDKQUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:20:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbaDKQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Durrant <paul.durrant@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 08/23] xen-netback: BUG_ON in xenvif_rx_action() not catching overflow
Date: Fri, 11 Apr 2014 09:11:57 -0700
Message-Id: <20140411161201.374113645@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Durrant <Paul.Durrant@citrix.com>

[ Upstream commit 1425c7a4e8d3d2eebf308bcbdc3fa3c1247686b4 ]

The BUG_ON to catch ring overflow in xenvif_rx_action() makes the assumption
that meta_slots_used == ring slots used. This is not necessarily the case
for GSO packets, because the non-prefix GSO protocol consumes one more ring
slot than meta-slot for the 'extra_info'. This patch changes the test to
actually check ring slots.

Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -482,6 +482,8 @@ static void xenvif_rx_action(struct xenv
 
 	while ((skb = skb_dequeue(&vif->rx_queue)) != NULL) {
 		RING_IDX max_slots_needed;
+		RING_IDX old_req_cons;
+		RING_IDX ring_slots_used;
 		int i;
 
 		/* We need a cheap worse case estimate for the number of
@@ -530,8 +532,12 @@ static void xenvif_rx_action(struct xenv
 			vif->rx_last_skb_slots = 0;
 
 		sco = (struct skb_cb_overlay *)skb->cb;
+
+		old_req_cons = vif->rx.req_cons;
 		sco->meta_slots_used = xenvif_gop_skb(skb, &npo);
-		BUG_ON(sco->meta_slots_used > max_slots_needed);
+		ring_slots_used = vif->rx.req_cons - old_req_cons;
+
+		BUG_ON(ring_slots_used > max_slots_needed);
 
 		__skb_queue_tail(&rxq, skb);
 	}


