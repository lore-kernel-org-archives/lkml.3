Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaFEEUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaFEEUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 033/214] net-gro: reset skb->truesize in napi_reuse_skb()
Date: Wed,  4 Jun 2014 21:16:36 -0700
Message-Id: <20140605041644.327093210@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3574,6 +3574,7 @@ static void napi_reuse_skb(struct napi_s
 	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;
+	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 
 	napi->skb = skb;
 }


