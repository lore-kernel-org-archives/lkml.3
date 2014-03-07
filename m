Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaCGK4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:56:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40012 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaCGK4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:56:15 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660344"
Message-ID: <5319A3C2.8080001@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:47:30 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] netlink: switch net_ns only if net is not init_net
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:53:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:53:36,
	Serialize complete at 2014/03/07 18:53:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many netlink users create netlink sock in the init_net, and the
switching nes_ns(init_net-->net) is needless in this case. So here
we add a pre-check to avoid this.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 net/netlink/af_netlink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fdf5135..e9e4be9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2429,7 +2429,8 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 		goto out_sock_release_nosk;
 
 	sk = sock->sk;
-	sk_change_net(sk, net);
+	if (!net_eq(net, &init_net))
+		sk_change_net(sk, net);
 
 	if (!cfg || cfg->groups < 32)
 		groups = 32;
-- 
1.7.7

