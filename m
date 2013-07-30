Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3G3Sse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:48:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab3G3Ssa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:48:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Saurabh Mohan <saurabh.mohan@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 56/75] vti: remove duplicated code to fix a memory leak
Date: Tue, 30 Jul 2013 11:45:00 -0700
Message-Id: <1375209919-1768-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit ab6c7a0a43c2eaafa57583822b619b22637b49c7 ]

vti module allocates dev->tstats twice: in vti_fb_tunnel_init()
and in vti_tunnel_init(), this lead to a memory leak of
dev->tstats.

Just remove the duplicated operations in vti_fb_tunnel_init().

(candidate for -stable)

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Saurabh Mohan <saurabh.mohan@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_vti.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index c3a4233..5ccf343 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -645,17 +645,10 @@ static int __net_init vti_fb_tunnel_init(struct net_device *dev)
 	struct iphdr *iph = &tunnel->parms.iph;
 	struct vti_net *ipn = net_generic(dev_net(dev), vti_net_id);
 
-	tunnel->dev = dev;
-	strcpy(tunnel->parms.name, dev->name);
-
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPIP;
 	iph->ihl		= 5;
 
-	dev->tstats = alloc_percpu(struct pcpu_tstats);
-	if (!dev->tstats)
-		return -ENOMEM;
-
 	dev_hold(dev);
 	rcu_assign_pointer(ipn->tunnels_wc[0], tunnel);
 	return 0;
-- 
1.8.1.2

