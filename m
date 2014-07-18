Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbaGRNkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:40:31 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17647 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761418AbaGRNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/170] ipvs: stop tot_stats estimator only under CONFIG_SYSCTL
Date: Fri, 18 Jul 2014 14:10:07 +0200
Message-Id: <f730d2ab16bae1111f796d01d3ab0b7d53e805f3.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 9802d21e7a0b0d2167ef745edc1f4ea7a0fc6ea3 ]

The tot_stats estimator is started only when CONFIG_SYSCTL
is defined. But it is stopped without checking CONFIG_SYSCTL.
Fix the crash by moving ip_vs_stop_estimator into
ip_vs_control_net_cleanup_sysctl.

The change is needed after commit 14e405461e664b
("IPVS: Add __ip_vs_control_{init,cleanup}_sysctl()") from 2.6.39.

Cc: <stable@vger.kernel.org> # 3.15.x
Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.12.x
Cc: <stable@vger.kernel.org> # 3.10.x
Cc: <stable@vger.kernel.org> # 3.2.x
Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Sgned-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index a3df9bddc4f7..f9568654ffd2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3765,6 +3765,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct net *net)
 	cancel_delayed_work_sync(&ipvs->defense_work);
 	cancel_work_sync(&ipvs->defense_work.work);
 	unregister_net_sysctl_table(ipvs->sysctl_hdr);
+	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 }
 
 #else
@@ -3825,7 +3826,6 @@ void __net_exit ip_vs_control_net_cleanup(struct net *net)
 	 */
 	rcu_barrier();
 	ip_vs_trash_cleanup(net);
-	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 	ip_vs_control_net_cleanup_sysctl(net);
 	remove_proc_entry("ip_vs_stats_percpu", net->proc_net);
 	remove_proc_entry("ip_vs_stats", net->proc_net);
-- 
2.0.0

