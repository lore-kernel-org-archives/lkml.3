Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaBJT7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:59:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaBJTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 123/124] Revert "ip6tnl: fix use after free of fb_tnl_dev"
Date: Mon, 10 Feb 2014 11:41:03 -0800
Message-Id: <1392061264-28124-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ No relevant upstream commit. ]

This reverts commit 22c3ec552c29cf4bd4a75566088950fe57d860c4.

This patch is not the right fix, it introduces a memory leak when a netns is
destroyed (the FB device is never deleted).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index fa3fe70..a953bfb 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1725,6 +1725,8 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct ip6_tnl_net *ip6n)
 		}
 	}
 
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	unregister_netdevice_queue(t->dev, &list);
 	unregister_netdevice_many(&list);
 }
 
-- 
1.8.3.2

