Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaJMC3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:29:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbaJMC3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:29:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 27/55] tg3: Work around HW/FW limitations with vlan encapsulated frames
Date: Mon, 13 Oct 2014 04:24:41 +0200
Message-Id: <20141013022444.919718881@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit 476c18850c6cbaa3f2bb661ae9710645081563b9 ]

TG3 appears to have an issue performing TSO and checksum offloading
correclty when the frame has been vlan encapsulated (non-accelrated).
In these cases, tcp checksum is not correctly updated.

This patch attempts to work around this issue.  After the patch,
802.1ad vlans start working correctly over tg3 devices.

CC: Prashant Sreedharan <prashant@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7914,8 +7914,6 @@ static netdev_tx_t tg3_start_xmit(struct
 
 	entry = tnapi->tx_prod;
 	base_flags = 0;
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		base_flags |= TXD_FLAG_TCPUDP_CSUM;
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (mss) {
@@ -7929,6 +7927,13 @@ static netdev_tx_t tg3_start_xmit(struct
 
 		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb) - ETH_HLEN;
 
+		/* HW/FW can not correctly segment packets that have been
+		 * vlan encapsulated.
+		 */
+		if (skb->protocol == htons(ETH_P_8021Q) ||
+		    skb->protocol == htons(ETH_P_8021AD))
+			return tg3_tso_bug(tp, tnapi, txq, skb);
+
 		if (!skb_is_gso_v6(skb)) {
 			if (unlikely((ETH_HLEN + hdr_len) > 80) &&
 			    tg3_flag(tp, TSO_BUG))
@@ -7979,6 +7984,17 @@ static netdev_tx_t tg3_start_xmit(struct
 				base_flags |= tsflags << 12;
 			}
 		}
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		/* HW/FW can not correctly checksum packets that have been
+		 * vlan encapsulated.
+		 */
+		if (skb->protocol == htons(ETH_P_8021Q) ||
+		    skb->protocol == htons(ETH_P_8021AD)) {
+			if (skb_checksum_help(skb))
+				goto drop;
+		} else  {
+			base_flags |= TXD_FLAG_TCPUDP_CSUM;
+		}
 	}
 
 	if (tg3_flag(tp, USE_JUMBO_BDFLAG) &&


