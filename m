Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab3LBVBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:01:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3LBTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ujjal Roy <royujjal@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 080/173] mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode
Date: Mon,  2 Dec 2013 11:11:03 -0800
Message-Id: <20131202191152.601886029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ujjal Roy <royujjal@gmail.com>

commit 8d93f1f309d38b65fce0b9f0de91ba6c96990c07 upstream.

The eth_hdr is never defined in this driver but it gets compiled
without any warning/error because kernel has defined eth_hdr.

Fix it by defining our own p_ethhdr and use it instead of eth_hdr.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/uap_txrx.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -34,6 +34,7 @@ static void mwifiex_uap_queue_bridged_pk
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
 	struct timeval tv;
+	struct ethhdr *p_ethhdr;
 	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -48,14 +49,36 @@ static void mwifiex_uap_queue_bridged_pk
 	}
 
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
-		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)))
+		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
+		/* Replace the 803 header and rfc1042 header (llc/snap) with
+		 * an Ethernet II header, keep the src/dst and snap_type
+		 * (ethertype).
+		 *
+		 * The firmware only passes up SNAP frames converting all RX
+		 * data from 802.11 to 802.2/LLC/SNAP frames.
+		 *
+		 * To create the Ethernet II, just move the src, dst address
+		 * right before the snap_type.
+		 */
+		p_ethhdr = (struct ethhdr *)
+			((u8 *)(&rx_pkt_hdr->eth803_hdr)
+			 + sizeof(rx_pkt_hdr->eth803_hdr)
+			 + sizeof(rx_pkt_hdr->rfc1042_hdr)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_dest)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_source)
+			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
+		memcpy(p_ethhdr->h_source, rx_pkt_hdr->eth803_hdr.h_source,
+		       sizeof(p_ethhdr->h_source));
+		memcpy(p_ethhdr->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
+		       sizeof(p_ethhdr->h_dest));
 		/* Chop off the rxpd + the excess memory from
 		 * 802.2/llc/snap header that was removed.
 		 */
-		hdr_chop = (u8 *)eth_hdr - (u8 *)uap_rx_pd;
-	else
+		hdr_chop = (u8 *)p_ethhdr - (u8 *)uap_rx_pd;
+	} else {
 		/* Chop off the rxpd */
 		hdr_chop = (u8 *)&rx_pkt_hdr->eth803_hdr - (u8 *)uap_rx_pd;
+	}
 
 	/* Chop off the leading header bytes so the it points
 	 * to the start of either the reconstructed EthII frame


