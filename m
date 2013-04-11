Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab3DKU1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:27:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3DKU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:21 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=t3nTB2NjAdYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ECg1GtgZPMEA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=WTJdmG3rAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=dGJ0OcVc7YAA:10 a=nsF78Xlgl7EA:10 a=jeBq3FmKZ4MA:10 a=3JeV1RASMAyesLZR:21 a=-UY2QHJZWejIu7-u:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202556.059076364@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dean Luick <dean.luick@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 060/171 ] IPoIB: Fix send lockup due to missed TX completion
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0060-IPoIB-Fix-send-lockup-due-to-missed-TX-completion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 1ee9e2aa7b31427303466776f455d43e5e3c9275 ]

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

Cc: <stable@vger.kernel.org>
Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 24683fd..2ad27ce 100644
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
1.7.10.4


