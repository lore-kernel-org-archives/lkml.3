Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaATV0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:26:12 -0500
Received: from smtp.citrix.com ([66.165.176.89]:20333 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbaATVY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:24:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,692,1384300800"; 
   d="scan'208";a="94665772"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v5 7/9] xen-netback: Add stat counters for frag_list skbs
Date: Mon, 20 Jan 2014 21:24:27 +0000
Message-ID: <1390253069-25507-8-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These counters help determine how often the guest sends a packet with more
than MAX_SKB_FRAGS frags.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/common.h    |    1 +
 drivers/net/xen-netback/interface.c |    7 +++++++
 drivers/net/xen-netback/netback.c   |    1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index e3c28ff..c037efb 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -158,6 +158,7 @@ struct xenvif {
 	unsigned long tx_zerocopy_sent;
 	unsigned long tx_zerocopy_success;
 	unsigned long tx_zerocopy_fail;
+	unsigned long tx_frag_overflow;
 
 	/* Miscellaneous private stuff. */
 	struct net_device *dev;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index ac27af3..b7daf8d 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -254,6 +254,13 @@ static const struct xenvif_stat {
 		"tx_zerocopy_fail",
 		offsetof(struct xenvif, tx_zerocopy_fail)
 	},
+	/* Number of packets exceeding MAX_SKB_FRAG slots. You should use
+	 * a guest with the same MAX_SKB_FRAG
+	 */
+	{
+		"tx_frag_overflow",
+		offsetof(struct xenvif, tx_frag_overflow)
+	},
 };
 
 static int xenvif_get_sset_count(struct net_device *dev, int string_set)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 9841429..4305965 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1656,6 +1656,7 @@ static int xenvif_tx_submit(struct xenvif *vif, int budget)
 			skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
 			skb_shinfo(nskb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
 			vif->tx_zerocopy_sent += 2;
+			vif->tx_frag_overflow++;
 			nskb = skb;
 
 			skb = skb_copy_expand(skb, 0, 0, GFP_ATOMIC | __GFP_NOWARN);
