Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaABRYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:24:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaABRHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 52/91] ip6tnl: fix use after free of fb_tnl_dev
Date: Thu,  2 Jan 2014 09:04:27 -0800
Message-Id: <1388682306-30859-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

The upstream commit bb8140947a24 ("ip6tnl: allow to use rtnl ops on fb tunnel")
(backported into linux-3.10.y) left a bug which was fixed upstream by commit
1e9f3d6f1c40 ("ip6tnl: fix use after free of fb_tnl_dev").

The problem is a bit different in linux-3.10.y, because there is no x-netns
support (upstream commit 0bd8762824e7 ("ip6tnl: add x-netns support")).
When ip6_tunnel.ko is unloaded, FB device is deleted by rtnl_link_unregister()
and then we try to delete it again in ip6_tnl_destroy_tunnels().

This patch removes the second deletion.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a953bfb..fa3fe70 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1725,8 +1725,6 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct ip6_tnl_net *ip6n)
 		}
 	}
 
-	t = rtnl_dereference(ip6n->tnls_wc[0]);
-	unregister_netdevice_queue(t->dev, &list);
 	unregister_netdevice_many(&list);
 }
 
-- 
1.8.3.2

