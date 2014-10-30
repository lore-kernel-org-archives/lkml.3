Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbaJ3T7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:59:52 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:46332
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbaJ3T7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:59:51 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Add IPv6 into the hash computation for vRSS
Date: Thu, 30 Oct 2014 14:07:17 -0700
Message-Id: <1414703237-11510-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow the workload spreading via vRSS for IPv6.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c   |    4 +++-
 drivers/net/hyperv/rndis_filter.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 78ec33f..3295e4e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -193,7 +193,9 @@ static bool netvsc_set_hash(u32 *hash, struct sk_buff *skb)
 	struct flow_keys flow;
 	int data_len;
 
-	if (!skb_flow_dissect(skb, &flow) || flow.n_proto != htons(ETH_P_IP))
+	if (!skb_flow_dissect(skb, &flow) ||
+	    !(flow.n_proto == htons(ETH_P_IP) ||
+	      flow.n_proto == htons(ETH_P_IPV6)))
 		return false;
 
 	if (flow.ip_proto == IPPROTO_TCP)
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 2b86f0b..ccce6f2 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -728,7 +728,8 @@ int rndis_filter_set_rss_param(struct rndis_device *rdev, int num_queue)
 	rssp->hdr.size = sizeof(struct ndis_recv_scale_param);
 	rssp->flag = 0;
 	rssp->hashinfo = NDIS_HASH_FUNC_TOEPLITZ | NDIS_HASH_IPV4 |
-			 NDIS_HASH_TCP_IPV4;
+			 NDIS_HASH_TCP_IPV4 | NDIS_HASH_IPV6 |
+			 NDIS_HASH_TCP_IPV6;
 	rssp->indirect_tabsize = 4*ITAB_NUM;
 	rssp->indirect_taboffset = sizeof(struct ndis_recv_scale_param);
 	rssp->hashkey_size = HASH_KEYLEN;
-- 
1.7.1

