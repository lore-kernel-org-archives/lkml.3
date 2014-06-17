Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967614AbaFQW1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:27:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965477AbaFQVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <shemminger@vyatta.com>, Liu Yu <allanyuliu@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/212] tcp_cubic: fix the range of delayed_ack
Date: Tue, 17 Jun 2014 14:42:14 -0700
Message-Id: <1403041506-13646-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Yu <allanyuliu@tencent.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 828e4c3..121a9a2 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -409,7 +409,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
 		ratio += cnt;
 
-		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
+		ca->delayed_ack = clamp(ratio, 1U, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */
-- 
1.9.1

