Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab3DBSvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:51:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44350 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932946Ab3DBSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:12 -0400
X-Sasl-enc: 8dDwK+0lmftr8Th/2tvIEY7Pm3WRuO/VqBjnWrvP5L7F 1364928491
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 2/6] mac802154: Move xmit_attemps to stack
Date: Tue,  2 Apr 2013 14:47:57 -0400
Message-Id: <1364928481-1813-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to have it in the work struct anymore.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index fbf937c..a248246 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -39,12 +39,12 @@ struct xmit_work {
 	struct mac802154_priv *priv;
 	u8 chan;
 	u8 page;
-	u8 xmit_attempts;
 };
 
 static void mac802154_xmit_worker(struct work_struct *work)
 {
 	struct xmit_work *xw = container_of(work, struct xmit_work, work);
+	u8 xmit_attempts = 0;
 	int res;
 
 	mutex_lock(&xw->priv->phy->pib_lock);
@@ -61,7 +61,7 @@ static void mac802154_xmit_worker(struct work_struct *work)
 
 	do {
 		res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
-		if (res && ++xw->xmit_attempts >= MAC802154_MAX_XMIT_ATTEMPTS) {
+		if (res && ++xmit_attempts >= MAC802154_MAX_XMIT_ATTEMPTS) {
 			pr_debug("transmission failed for %d times",
 				 MAC802154_MAX_XMIT_ATTEMPTS);
 			break;
@@ -113,7 +113,6 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
 	work->priv = priv;
 	work->page = page;
 	work->chan = chan;
-	work->xmit_attempts = 0;
 
 	queue_work(priv->dev_workqueue, &work->work);
 
-- 
1.7.11.2

