Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3LFNCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3LFNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ujjal Roy <royujjal@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/272] mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode
Date: Fri,  6 Dec 2013 12:57:00 +0000
Message-Id: <1386334761-25517-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index a018e42..48e6724 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -34,6 +34,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
 	struct timeval tv;
+	struct ethhdr *p_ethhdr;
 	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -48,14 +49,36 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
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
-- 
1.8.3.2

