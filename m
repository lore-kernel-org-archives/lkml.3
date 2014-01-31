Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaAaIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:24:19 -0500
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:41036 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaAaIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:24:16 -0500
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, williams@redhat.com, lclaudio@uudg.org,
        jkacur@redhat.com, willemb@google.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH linux-3.10.y v2 2/3] Revert "ip6tnl: fix use after free of fb_tnl_dev"
Date: Fri, 31 Jan 2014 09:24:05 +0100
Message-Id: <1391156646-11981-2-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1391156646-11981-1-git-send-email-nicolas.dichtel@6wind.com>
References: <20140130171029.01cd80ca@gandalf.local.home>
 <1391156646-11981-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 22c3ec552c29cf4bd4a75566088950fe57d860c4.

This patch is not the right fix, it introduces a memory leak when a netns is
destroyed (the FB device is never deleted).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
---

v2: add Steven's tags

 net/ipv6/ip6_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 209bb4d6e188..0516ebbea80b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1711,6 +1711,8 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct ip6_tnl_net *ip6n)
 		}
 	}
 
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	unregister_netdevice_queue(t->dev, &list);
 	unregister_netdevice_many(&list);
 }
 
-- 
1.8.4.1

