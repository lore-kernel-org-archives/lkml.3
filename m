Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbaE2Ntv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:49:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59838 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738AbaE2Ntq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Yu <allanyuliu@tencent.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/103] tcp_cubic: fix the range of delayed_ack
Date: Thu, 29 May 2014 15:49:14 +0200
Message-Id: <e78282a5759165273c4a704c842dc808e85b1780.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <allanyuliu@tencent.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 0cda345d1b2201dd15591b163e3c92bad5191745 ]

commit b9f47a3aaeab (tcp_cubic: limit delayed_ack ratio to prevent
divide error) try to prevent divide error, but there is still a little
chance that delayed_ack can reach zero. In case the param cnt get
negative value, then ratio+cnt would overflow and may happen to be zero.
As a result, min(ratio, ACK_RATIO_LIMIT) will calculate to be zero.

In some old kernels, such as 2.6.32, there is a bug that would
pass negative param, which then ultimately leads to this divide error.

commit 5b35e1e6e9c (tcp: fix tcp_trim_head() to adjust segment count
with skb MSS) fixed the negative param issue. However,
it's safe that we fix the range of delayed_ack as well,
to make sure we do not hit a divide by zero.

CC: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Liu Yu <allanyuliu@tencent.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b6ae92a51f58..894b7cea5d7b 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -408,7 +408,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
 		ratio += cnt;
 
-		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
+		ca->delayed_ack = clamp(ratio, 1U, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */
-- 
1.9.3

