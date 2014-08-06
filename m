Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaHFSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:16:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45462 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbaHFSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:16:56 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="159399045"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH] xen-netback: Small fixes around internal queue purging
Date: Wed, 6 Aug 2014 19:16:12 +0100
Message-ID: <1407348973-2433-4-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an extra internal queue purging for xenvif_carrier_off. It makes
sense to do this when the carrier is switched off.
Also, it uses the proper helper instead of a while loop to the purging at
another place.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index cbe6b51..df9507e 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -533,6 +533,9 @@ void xenvif_carrier_off(struct xenvif *vif)
 	}
 
 	rtnl_unlock();
+
+	skb_queue_purge(&vif->rx_queue);
+	vif->rx_last_skb_slots = 0;
 }
 
 void xenvif_disconnect(struct xenvif *vif)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index e462cf2c..f728f73 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1932,7 +1932,6 @@ static void xenvif_start_queue(struct xenvif *vif)
 int xenvif_kthread_guest_rx(void *data)
 {
 	struct xenvif *vif = data;
-	struct sk_buff *skb;
 
 	while (!kthread_should_stop()) {
 		wait_event_interruptible(vif->wq,
@@ -2009,8 +2008,7 @@ int xenvif_kthread_guest_rx(void *data)
 	}
 
 	/* Bin any remaining skbs */
-	while ((skb = skb_dequeue(&vif->rx_queue)) != NULL)
-		dev_kfree_skb(skb);
+	skb_queue_purge(&vif->rx_queue);
 
 	return 0;
 }
