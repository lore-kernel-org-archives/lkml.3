Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936626Ab3DHKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:23:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935431Ab3DHJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/102] IPoIB: Fix send lockup due to missed TX completion
Date: Mon,  8 Apr 2013 10:49:26 +0100
Message-Id: <1365414657-29191-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 1ee9e2aa7b31427303466776f455d43e5e3c9275 upstream.

Commit f0dc117abdfa ("IPoIB: Fix TX queue lockup with mixed UD/CM
traffic") attempts to solve an issue where unprocessed UD send
completions can deadlock the netdev.

The patch doesn't fully resolve the issue because if more than half
the tx_outstanding's were UD and all of the destinations are RC
reachable, arming the CQ doesn't solve the issue.

This patch uses the IB_CQ_REPORT_MISSED_EVENTS on the
ib_req_notify_cq().  If the rc is above 0, the UD send cq completion
callback is called directly to re-arm the send completion timer.

This issue is seen in very large parallel filesystem deployments
and the patch has been shown to correct the issue.

Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 014504d..3767853 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -755,9 +755,13 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
-			if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
-				ipoib_warn(priv, "request notify on send CQ failed\n");
 			netif_stop_queue(dev);
+			rc = ib_req_notify_cq(priv->send_cq,
+				IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+			if (rc < 0)
+				ipoib_warn(priv, "request notify on send CQ failed\n");
+			else if (rc)
+				ipoib_send_comp_handler(priv->send_cq, dev);
 		}
 	}
 }
-- 
1.8.1.2

