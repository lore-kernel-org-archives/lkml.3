Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaCFVv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:51:27 -0500
Received: from smtp.citrix.com ([66.165.176.89]:64588 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaCFVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:49:13 -0500
X-IronPort-AV: E=Sophos;i="4.97,603,1389744000"; 
   d="scan'208";a="108916342"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>, Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v7 6/9] xen-netback: Add stat counters for zerocopy
Date: Thu, 6 Mar 2014 21:48:28 +0000
Message-ID: <1394142511-14827-7-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
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

NOTE: if bisect brought you here, you should apply the series up until
"xen-netback: Timeout packets in RX path", otherwise Windows guests can't work
properly and malicious guests can block other guests by not releasing their sent
packets.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 79ba456..eac171e 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -167,6 +167,9 @@ struct xenvif {
 
 	/* Statistics */
 	unsigned long rx_gso_checksum_fixup;
+	unsigned long tx_zerocopy_sent;
+	unsigned long tx_zerocopy_success;
+	unsigned long tx_zerocopy_fail;
 
 	/* Miscellaneous private stuff. */
 	struct net_device *dev;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 408ab57..adfed30 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -237,6 +237,21 @@ static const struct xenvif_stat {
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
index bc91965..44e6988 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1554,8 +1554,10 @@ static int xenvif_tx_submit(struct xenvif *vif)
 		 * do a skb_copy_ubufs while we are still in control of the
 		 * skb. E.g. the __pskb_pull_tail earlier can do such thing.
 		 */
-		if (skb_shinfo(skb)->destructor_arg)
+		if (skb_shinfo(skb)->destructor_arg) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+			vif->tx_zerocopy_sent++;
+		}
 
 		netif_receive_skb(skb);
 	}
@@ -1595,6 +1597,11 @@ void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success)
 		napi_schedule(&vif->napi);
 		local_bh_enable();
 	}
+
+	if (likely(zerocopy_success))
+		vif->tx_zerocopy_success++;
+	else
+		vif->tx_zerocopy_fail++;
 }
 
 static inline void xenvif_tx_dealloc_action(struct xenvif *vif)
