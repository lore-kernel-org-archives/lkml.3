Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaHLHiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:38:06 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:39000 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaHLHiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:38:04 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2014 03:38:03 EDT
From: Christoph Jaeger <cj@linux.com>
To: pshelar@nicira.com, davem@davemloft.net
Cc: dev@openvswitch.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <cj@linux.com>
Subject: [PATCH] openvswitch: Fix memory leak in ovs_vport_alloc() error path
Date: Tue, 12 Aug 2014 09:27:57 +0200
Message-Id: <1407828477-10287-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ovs_vport_alloc() bails out without freeing the memory 'vport' points to.

Picked up by Coverity - CID 1230503.

Fixes: 5cd667b0a4 ("openvswitch: Allow each vport to have an array of 'port_id's.")
Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 net/openvswitch/vport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 702fb21..6d8f2ec 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -137,8 +137,10 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
 	vport->ops = ops;
 	INIT_HLIST_NODE(&vport->dp_hash_node);
 
-	if (ovs_vport_set_upcall_portids(vport, parms->upcall_portids))
+	if (ovs_vport_set_upcall_portids(vport, parms->upcall_portids)) {
+		kfree(vport);
 		return ERR_PTR(-EINVAL);
+	}
 
 	vport->percpu_stats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!vport->percpu_stats) {
-- 
1.9.3

