Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaFQWos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:44:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbaFQVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 063/212] net-gro: reset skb->truesize in napi_reuse_skb()
Date: Tue, 17 Jun 2014 14:42:37 -0700
Message-Id: <1403041506-13646-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e33d0ba8047b049c9262fdb1fcafb93cb52ceceb ]

Recycling skb always had been very tough...

This time it appears GRO layer can accumulate skb->truesize
adjustments made by drivers when they attach a fragment to skb.

skb_gro_receive() can only subtract from skb->truesize the used part
of a fragment.

I spotted this problem seeing TcpExtPruneCalled and
TcpExtTCPRcvCollapsed that were unexpected with a recent kernel, where
TCP receive window should be sized properly to accept traffic coming
from a driver not overshooting skb->truesize.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4c0ff6f..fd9b17a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3979,6 +3979,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;
+	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 
 	napi->skb = skb;
 }
-- 
1.9.1

