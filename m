Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaB0WEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:04:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:4730 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaB0WEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:04:45 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389744000"; 
   d="scan'208";a="106448084"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Jesse Gross <jesse@nicira.com>, <pshelar@nicira.com>,
        <dev@openvswitch.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] openvswitch: Disable bottom half when grabbing stats lock in userspace context
Date: Thu, 27 Feb 2014 22:04:37 +0000
Message-ID: <1393538677-21268-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The megaflow feature introduced per-CPU stats, and the new code did some
refactoring as well [1]. However the new functions doesn't disable bottom halves
when locking the stat, and as they can be called from userspace context, they
can be interrupted by netif_receive_skb.

[1] e298e50570: openvswitch: Per cpu flow stats.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 net/openvswitch/flow.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 16f4b46..07a4672 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -90,13 +90,14 @@ static void stats_read(struct flow_stats *stats,
 		       struct ovs_flow_stats *ovs_stats,
 		       unsigned long *used, __be16 *tcp_flags)
 {
-	spin_lock(&stats->lock);
+	unsigned long flags;
+	spin_lock_irqsave(&stats->lock, flags);
 	if (time_after(stats->used, *used))
 		*used = stats->used;
 	*tcp_flags |= stats->tcp_flags;
 	ovs_stats->n_packets += stats->packet_count;
 	ovs_stats->n_bytes += stats->byte_count;
-	spin_unlock(&stats->lock);
+	spin_unlock_irqrestore(&stats->lock, flags);
 }
 
 void ovs_flow_stats_get(struct sw_flow *flow, struct ovs_flow_stats *ovs_stats,
@@ -130,12 +131,13 @@ void ovs_flow_stats_get(struct sw_flow *flow, struct ovs_flow_stats *ovs_stats,
 
 static void stats_reset(struct flow_stats *stats)
 {
-	spin_lock(&stats->lock);
+	unsigned long flags;
+	spin_lock_irqsave(&stats->lock, flags);
 	stats->used = 0;
 	stats->packet_count = 0;
 	stats->byte_count = 0;
 	stats->tcp_flags = 0;
-	spin_unlock(&stats->lock);
+	spin_unlock_irqrestore(&stats->lock, flags);
 }
 
 void ovs_flow_stats_clear(struct sw_flow *flow)
