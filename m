Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaHDRE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56536 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Simon Horman" <horms@verge.net.au>, "Jet Chen" <jet.chen@intel.com>,
        "Julian Anastasov" <ja@ssi.bg>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.777127626@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 83/94] ipvs: stop tot_stats estimator only under
 CONFIG_SYSCTL
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 9802d21e7a0b0d2167ef745edc1f4ea7a0fc6ea3 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3688,6 +3688,7 @@ void __net_init ip_vs_control_net_cleanu
 	cancel_delayed_work_sync(&ipvs->defense_work);
 	cancel_work_sync(&ipvs->defense_work.work);
 	unregister_net_sysctl_table(ipvs->sysctl_hdr);
+	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 }
 
 #else
@@ -3743,7 +3744,6 @@ void __net_exit ip_vs_control_net_cleanu
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
 	ip_vs_trash_cleanup(net);
-	ip_vs_stop_estimator(net, &ipvs->tot_stats);
 	ip_vs_control_net_cleanup_sysctl(net);
 	proc_net_remove(net, "ip_vs_stats_percpu");
 	proc_net_remove(net, "ip_vs_stats");

