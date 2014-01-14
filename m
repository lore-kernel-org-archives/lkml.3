Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaANUlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:41:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54921 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaANUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:40:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,659,1384300800"; 
   d="scan'208";a="92858976"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v4 5/9] xen-netback: Add stat counters for zerocopy
Date: Tue, 14 Jan 2014 20:39:51 +0000
Message-ID: <1389731995-9887-6-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com>
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These counters help determine how often the buffers had to be copied. Also
they help find out if packets are leaked, as if "sent != success + fail",
there are probably packets never freed up properly.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/common.h    |    3 +++
 drivers/net/xen-netback/interface.c |   15 +++++++++++++++
 drivers/net/xen-netback/netback.c   |    9 ++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 419e63c..e3c28ff 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -155,6 +155,9 @@ struct xenvif {
 
 	/* Statistics */
 	unsigned long rx_gso_checksum_fixup;
+	unsigned long tx_zerocopy_sent;
+	unsigned long tx_zerocopy_success;
+	unsigned long tx_zerocopy_fail;
 
 	/* Miscellaneous private stuff. */
 	struct net_device *dev;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index af5216f..75fe683 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -239,6 +239,21 @@ static const struct xenvif_stat {
 		"rx_gso_checksum_fixup",
 		offsetof(struct xenvif, rx_gso_checksum_fixup)
 	},
+	/* If (sent != success + fail), there are probably packets never
+	 * freed up properly!
+	 */
+	{
+		"tx_zerocopy_sent",
+		offsetof(struct xenvif, tx_zerocopy_sent),
+	},
+	{
+		"tx_zerocopy_success",
+		offsetof(struct xenvif, tx_zerocopy_success),
+	},
+	{
+		"tx_zerocopy_fail",
+		offsetof(struct xenvif, tx_zerocopy_fail)
+	},
 };
 
 static int xenvif_get_sset_count(struct net_device *dev, int string_set)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a1b03e4..e2dd565 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1611,8 +1611,10 @@ static int xenvif_tx_submit(struct xenvif *vif, int budget)
 		 * skb_copy_ubufs while we are still in control of the skb. E.g.
 		 * the __pskb_pull_tail earlier can do such thing.
 		 */
-		if (skb_shinfo(skb)->destructor_arg)
+		if (skb_shinfo(skb)->destructor_arg) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+			vif->tx_zerocopy_sent++;
+		}
 
 		netif_receive_skb(skb);
 	}
@@ -1645,6 +1647,11 @@ void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success)
 		napi_schedule(&vif->napi);
 	} while (ubuf);
 	spin_unlock_irqrestore(&vif->dealloc_lock, flags);
+
+	if (likely(zerocopy_success))
+		vif->tx_zerocopy_success++;
+	else
+		vif->tx_zerocopy_fail++;
 }
 
 static inline void xenvif_tx_action_dealloc(struct xenvif *vif)
