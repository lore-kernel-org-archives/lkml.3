Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaJMCvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:51:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaJMC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Per Hurtig <per.hurtig@kau.se>, Eric Dumazet <edumazet@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 31/37] tcp: fixing TLPs FIN recovery
Date: Mon, 13 Oct 2014 04:24:28 +0200
Message-Id: <20141013022401.584919904@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2069,9 +2069,7 @@ void tcp_send_loss_probe(struct sock *sk
 	if (WARN_ON(!skb || !tcp_skb_pcount(skb)))
 		goto rearm_timer;
 
-	/* Probe with zero data doesn't trigger fast recovery. */
-	if (skb->len > 0)
-		err = __tcp_retransmit_skb(sk, skb);
+	err = __tcp_retransmit_skb(sk, skb);
 
 	/* Record snd_nxt for loss detection. */
 	if (likely(!err))


