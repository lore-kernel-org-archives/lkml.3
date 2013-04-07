Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab3DGXji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:39:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46685 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934598Ab3DGX3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Dean Luick" <dean.luick@intel.com>,
        "Mike Marciniszyn" <mike.marciniszyn@intel.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.361422891@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/74] IPoIB: Fix send lockup due to missed TX completion
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -755,9 +755,13 @@ void ipoib_cm_send(struct net_device *de
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

