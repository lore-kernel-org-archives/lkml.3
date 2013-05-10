Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3EJOUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628Ab3EJOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "hayeswang" <hayeswang@realtek.com>,
        "Stefan Bader" <stefan.bader@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Francois Romieu" <romieu@fr.zoreil.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.816779725@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [112/118] r8169: fix 8168evl frame padding.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

From: Stefan Bader <stefan.bader@canonical.com>

commit e5195c1f31f399289347e043d6abf3ffa80f0005 upstream.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5566,6 +5566,14 @@ static netdev_tx_t rtl8169_start_xmit(st
 		goto err_stop_0;
 	}
 
+	/* 8168evl does not automatically pad to minimum length. */
+	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
+		     skb->len < ETH_ZLEN)) {
+		if (skb_padto(skb, ETH_ZLEN))
+			goto err_update_stats;
+		skb_put(skb, ETH_ZLEN - skb->len);
+	}
+
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
@@ -5633,6 +5641,7 @@ err_dma_1:
 	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 err_dma_0:
 	dev_kfree_skb(skb);
+err_update_stats:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 

