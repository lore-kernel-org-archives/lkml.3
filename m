Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaJMC1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:27:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaJMC1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Erez Shitrit <erezsh@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 26/37] gro: fix aggregation for skb using frag_list
Date: Mon, 13 Oct 2014 04:24:23 +0200
Message-Id: <20141013022401.373896263@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3140,6 +3140,9 @@ int skb_gro_receive(struct sk_buff **hea
 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
 		goto done;
 	}
+	/* switch back to head shinfo */
+	pinfo = skb_shinfo(p);
+
 	if (pinfo->frag_list)
 		goto merge;
 	if (skb_gro_len(p) != pinfo->gso_size)


