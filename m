Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaKFWpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:45:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaKFWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 022/162] gro: fix aggregation for skb using frag_list
Date: Thu,  6 Nov 2014 14:34:46 -0800
Message-Id: <1415313426-9622-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 73d3fe6d1c6d840763ceafa9afae0aaafa18c4b5 ]

In commit 8a29111c7ca6 ("net: gro: allow to build full sized skb")
I added a regression for linear skb that traditionally force GRO
to use the frag_list fallback.

Erez Shitrit found that at most two segments were aggregated and
the "if (skb_gro_len(p) != pinfo->gso_size)" test was failing.

This is because pinfo at this spot still points to the last skb in the
chain, instead of the first one, where we find the correct gso_size
information.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 8a29111c7ca6 ("net: gro: allow to build full sized skb")
Reported-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 808a270..ddbb949 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3043,6 +3043,9 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
 		goto done;
 	}
+	/* switch back to head shinfo */
+	pinfo = skb_shinfo(p);
+
 	if (pinfo->frag_list)
 		goto merge;
 	if (skb_gro_len(p) != pinfo->gso_size)
-- 
1.9.1

