Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935073AbaGXKDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:03:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbaGXJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 087/128] ipvs: stop tot_stats estimator only under CONFIG_SYSCTL
Date: Thu, 24 Jul 2014 10:45:36 +0100
Message-Id: <1406195177-8656-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 9802d21e7a0b0d2167ef745edc1f4ea7a0fc6ea3 upstream.

The tot_stats estimator is started only when CONFIG_SYSCTL
is defined. But it is stopped without checking CONFIG_SYSCTL.
Fix the crash by moving ip_vs_stop_estimator into
ip_vs_control_net_cleanup_sysctl.

The change is needed after commit 14e405461e664b
("IPVS: Add __ip_vs_control_{init,cleanup}_sysctl()") from 2.6.39.

Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c8148e487386..c9de95e8faa6 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3781,6 +3781,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct net *net)
 	cancel_delayed_work_sync(&ipvs->defense_work);
 	cancel_work_sync(&ipvs->defense_work.work);
 	unregister_net_sysctl_table(ipvs->sysctl_hdr);
+	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 }
 
 #else
@@ -3841,7 +3842,6 @@ void __net_exit ip_vs_control_net_cleanup(struct net *net)
 	 */
 	rcu_barrier();
 	ip_vs_trash_cleanup(net);
-	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 	ip_vs_control_net_cleanup_sysctl(net);
 	remove_proc_entry("ip_vs_stats_percpu", net->proc_net);
 	remove_proc_entry("ip_vs_stats", net->proc_net);
-- 
1.9.1

