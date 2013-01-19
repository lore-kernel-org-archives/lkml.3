Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3ASJH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:07:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:31720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab3ASJDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="275794058"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 17/21] ntb_netdev: correct skb leak
Date: Sat, 19 Jan 2013 02:02:31 -0700
Message-Id: <1358586155-23322-18-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ntb_netdev is unable to pass a new skb to the ntb transport for
future rx packets, it should free the newly alloc'ed skb in the error
case.  Found by Kernel memory leak detector.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 0d4a6ee..28d6fea 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -119,6 +119,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
 
 	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
 	if (rc) {
+		dev_kfree_skb(skb);
 		ndev->stats.rx_errors++;
 		ndev->stats.rx_fifo_errors++;
 	}
-- 
1.7.9.5

