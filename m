Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324Ab3DCOBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:01:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59853 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758148Ab3DCOBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:01:10 -0400
X-Sasl-enc: K7/PU0xDS5+h4XUSA731piQg43LviW+6MJAVaV1oOAnh 1364997669
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 4/4] 6lowpan: handle dev_queue_xmit() error code properly
Date: Wed,  3 Apr 2013 10:00:58 -0400
Message-Id: <1364997658-16498-5-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364997658-16498-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
 <1364997658-16498-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_queue_xmit() will return a positive value if the packet could not be
queued, often because the real network device (in our case the mac802154
wpan device) has its queue stopped.  lowpan_xmit() should handle the
positive return code (for the debug statement) and return that value to
the higher layer so the higher layer will retry sending the packet.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index e1b4580..55e1fd5 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1139,10 +1139,10 @@ static netdev_tx_t lowpan_xmit(struct sk_buff *skb, struct net_device *dev)
 error:
 	dev_kfree_skb(skb);
 out:
-	if (err < 0)
+	if (err)
 		pr_debug("ERROR: xmit failed\n");
 
-	return (err < 0 ? NETDEV_TX_BUSY : NETDEV_TX_OK);
+	return (err < 0) ? NET_XMIT_DROP : err;
 }
 
 static struct wpan_phy *lowpan_get_phy(const struct net_device *dev)
-- 
1.7.11.2

