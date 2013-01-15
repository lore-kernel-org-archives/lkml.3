Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3AOPPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:15:23 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:51573 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab3AOPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:15:22 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: netdev@vger.kernel.org
Cc: dm@chelsio.com, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        steved@us.ibm.com, toml@us.ibm.com
Subject: [PATCH] cxgb4: set coalesce parameters on all queues
Date: Tue, 15 Jan 2013 13:15:10 -0200
Message-Id: <1358262910-23121-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011515-1524-0000-0000-000004ED7E93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The coalesce parameters was set only on the first queue, which caused
interrupt rates to be larger on all the other queues.

This patch allows interrupt rates to be reduced for certain workloads
and colaesce parameters by 41%.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: steved@us.ibm.com
Cc: toml@us.ibm.com
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0df1284..53ec2ad 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1762,9 +1762,20 @@ static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	struct adapter *adap = pi->adapter;
-
-	return set_rxq_intr_params(adap, &adap->sge.ethrxq[pi->first_qset].rspq,
-			c->rx_coalesce_usecs, c->rx_max_coalesced_frames);
+	struct sge_rspq *q;
+	int i;
+	int r = 0;
+
+	for (i = pi->first_qset; i < pi->first_qset + pi->nqsets; i++) {
+		q = &adap->sge.ethrxq[i].rspq;
+		r = set_rxq_intr_params(adap, q, c->rx_coalesce_usecs,
+			c->rx_max_coalesced_frames);
+		if (r) {
+			dev_err(&dev->dev, "failed to set coalesce %d\n", r);
+			break;
+		}
+	}
+	return r;
 }
 
 static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
-- 
1.7.1

