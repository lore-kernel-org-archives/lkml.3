Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423130AbaDKQUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:20:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbaDKQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Durrant <paul.durrant@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 07/23] xen-netback: worse-case estimate in xenvif_rx_action is underestimating
Date: Fri, 11 Apr 2014 09:11:56 -0700
Message-Id: <20140411161201.242621148@linuxfoundation.org>
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

[ Upstream commit a02eb4732cf975d7fc71b6d1a71c058c9988b949 ]

The worse-case estimate for skb ring slot usage in xenvif_rx_action()
fails to take fragment page_offset into account. The page_offset does,
however, affect the number of times the fragmentation code calls
start_new_rx_buffer() (i.e. consume another slot) and the worse-case
should assume that will always return true. This patch adds the page_offset
into the DIV_ROUND_UP for each frag.

Unfortunately some frontends aggressively limit the number of requests
they post into the shared ring so to avoid an estimate that is 'too'
pessimal it is capped at MAX_SKB_FRAGS.

Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -493,9 +493,28 @@ static void xenvif_rx_action(struct xenv
 						PAGE_SIZE);
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			unsigned int size;
+			unsigned int offset;
+
 			size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
-			max_slots_needed += DIV_ROUND_UP(size, PAGE_SIZE);
+			offset = skb_shinfo(skb)->frags[i].page_offset;
+
+			/* For a worse-case estimate we need to factor in
+			 * the fragment page offset as this will affect the
+			 * number of times xenvif_gop_frag_copy() will
+			 * call start_new_rx_buffer().
+			 */
+			max_slots_needed += DIV_ROUND_UP(offset + size,
+							 PAGE_SIZE);
 		}
+
+		/* To avoid the estimate becoming too pessimal for some
+		 * frontends that limit posted rx requests, cap the estimate
+		 * at MAX_SKB_FRAGS.
+		 */
+		if (max_slots_needed > MAX_SKB_FRAGS)
+			max_slots_needed = MAX_SKB_FRAGS;
+
+		/* We may need one more slot for GSO metadata */
 		if (skb_is_gso(skb) &&
 		   (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 ||
 		    skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6))


