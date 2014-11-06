Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaKFWo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaKFWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Per Hurtig <per.hurtig@kau.se>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/162] tcp: fixing TLP's FIN recovery
Date: Thu,  6 Nov 2014 14:34:51 -0800
Message-Id: <1415313426-9622-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Per Hurtig <per.hurtig@kau.se>

[ Upstream commit bef1909ee3ed1ca39231b260a8d3b4544ecd0c8f ]

Fix to a problem observed when losing a FIN segment that does not
contain data.  In such situations, TLP is unable to recover from
*any* tail loss and instead adds at least PTO ms to the
retransmission process, i.e., RTO = RTO + PTO.

Signed-off-by: Per Hurtig <per.hurtig@kau.se>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nandita Dukkipati <nanditad@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_output.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f587e1c..395f909 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2048,9 +2048,7 @@ void tcp_send_loss_probe(struct sock *sk)
 	if (WARN_ON(!skb || !tcp_skb_pcount(skb)))
 		goto rearm_timer;
 
-	/* Probe with zero data doesn't trigger fast recovery. */
-	if (skb->len > 0)
-		err = __tcp_retransmit_skb(sk, skb);
+	err = __tcp_retransmit_skb(sk, skb);
 
 	/* Record snd_nxt for loss detection. */
 	if (likely(!err))
-- 
1.9.1

