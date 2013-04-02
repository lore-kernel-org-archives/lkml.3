Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3DBSsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58830 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932891Ab3DBSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:11 -0400
X-Sasl-enc: 8dD9IeU2guZ95j5t1NXaGo/Pm3WRuO/VqBjnWrvP5L7F 1364928491
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 1/6] mac802154: Immediately retry sending failed packets
Date: Tue,  2 Apr 2013 14:47:56 -0400
Message-Id: <1364928481-1813-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1364928481-1813-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ops->xmit() fails, immediately retry. Previously the packet was sent
to the back of the workqueue.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/tx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 4e09d07..fbf937c 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -59,19 +59,18 @@ static void mac802154_xmit_worker(struct work_struct *work)
 		}
 	}
 
-	res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
+	do {
+		res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
+		if (res && ++xw->xmit_attempts >= MAC802154_MAX_XMIT_ATTEMPTS) {
+			pr_debug("transmission failed for %d times",
+				 MAC802154_MAX_XMIT_ATTEMPTS);
+			break;
+		}
+	} while (res);
 
 out:
 	mutex_unlock(&xw->priv->phy->pib_lock);
 
-	if (res) {
-		if (xw->xmit_attempts++ < MAC802154_MAX_XMIT_ATTEMPTS) {
-			queue_work(xw->priv->dev_workqueue, &xw->work);
-			return;
-		} else
-			pr_debug("transmission failed for %d times",
-				 MAC802154_MAX_XMIT_ATTEMPTS);
-	}
 
 	dev_kfree_skb(xw->skb);
 
-- 
1.7.11.2

