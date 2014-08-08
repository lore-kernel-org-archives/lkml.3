Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbaHHVWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:22:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHHUvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 226/259] udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup
Date: Fri,  8 Aug 2014 13:40:49 -0700
Message-Id: <1407530482-4483-227-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 63c6f81cdde58c41da62a8d8a209592e42a0203e ]

Its too easy to add thousand of UDP sockets on a particular bucket,
and slow down an innocent multicast receiver.

Early demux is supposed to be an optimization, we should avoid spending
too much time in it.

It is interesting to note __udp4_lib_demux_lookup() only tries to
match first socket in the chain.

10 is the threshold we already have in __udp4_lib_lookup() to switch
to secondary hash.

Fixes: 421b3885bf6d5 ("udp: ipv4: Add udp early demux")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Held <drheld@google.com>
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/udp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a7e4729..98ea36d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1833,6 +1833,10 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
 	unsigned int count, slot = udp_hashfn(net, hnum, udp_table.mask);
 	struct udp_hslot *hslot = &udp_table.hash[slot];
 
+	/* Do not bother scanning a too big list */
+	if (hslot->count > 10)
+		return NULL;
+
 	rcu_read_lock();
 begin:
 	count = 0;
-- 
1.9.1

