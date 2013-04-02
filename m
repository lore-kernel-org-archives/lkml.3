Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3DBSsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39972 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932891Ab3DBSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:15 -0400
X-Sasl-enc: jbDMGhtljXThVDf1wr1yEfiv8khyD8wlg3U+RzL4molQ 1364928494
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 6/6] 6lowpan: return the dev_queue_xmit() return value from lowpan_xmit()
Date: Tue,  2 Apr 2013 14:48:01 -0400
Message-Id: <1364928481-1813-7-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_queue_xmit() will return a positive value if the packet could not be
queued, often because the real network device (in our case the mac802154
wpan device) has its queue stopped.  lowpan_xmit() should return that value
to the higher layer so the higher layer will retry sending the packet.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index a68c792..55e1fd5 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1142,7 +1142,7 @@ out:
 	if (err)
 		pr_debug("ERROR: xmit failed\n");
 
-	return (err < 0 ? NETDEV_TX_BUSY : NETDEV_TX_OK);
+	return (err < 0) ? NET_XMIT_DROP : err;
 }
 
 static struct wpan_phy *lowpan_get_phy(const struct net_device *dev)
-- 
1.7.11.2

