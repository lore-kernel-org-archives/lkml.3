Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaDHAzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:55:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:3720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaDHAzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:55:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516267267"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] ntb_netdev: Fix skb free issue in open
Date: Mon,  7 Apr 2014 17:52:47 -0700
Message-Id: <1396918374-5196-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ntb_netdev_open, when ntb_transport_rx_enqueue fails the skb that was
attempting to be enqueued is not freed.  Free this skb on the
ntb_transport_rx_enqueue error.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 8298880..8e6752f 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -182,8 +182,10 @@ static int ntb_netdev_open(struct net_device *ndev)
 
 		rc = ntb_transport_rx_enqueue(dev->qp, skb, skb->data,
 					      ndev->mtu + ETH_HLEN);
-		if (rc == -EINVAL)
+		if (rc == -EINVAL) {
+			dev_kfree_skb(skb);
 			goto err;
+		}
 	}
 
 	netif_carrier_off(ndev);
-- 
1.8.3.2

