Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab3JJQOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:14:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 009/104] tcp: cubic: fix overflow error in bictcp_update()
Date: Thu, 10 Oct 2013 08:40:57 -0700
Message-Id: <1381419752-29733-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2ed0edf9090bf4afa2c6fc4f38575a85a80d4b20 ]

commit 17a6e9f1aa9 ("tcp_cubic: fix clock dependency") added an
overflow error in bictcp_update() in following code :

/* change the unit from HZ to bictcp_HZ */
t = ((tcp_time_stamp + msecs_to_jiffies(ca->delay_min>>3) -
      ca->epoch_start) << BICTCP_HZ) / HZ;

Because msecs_to_jiffies() being unsigned long, compiler does
implicit type promotion.

We really want to constrain (tcp_time_stamp - ca->epoch_start)
to a signed 32bit value, or else 't' has unexpected high values.

This bugs triggers an increase of retransmit rates ~24 days after
boot [1], as the high order bit of tcp_time_stamp flips.

[1] for hosts with HZ=1000

Big thanks to Van Jacobson for spotting this problem.

Diagnosed-by: Van Jacobson <vanj@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_cubic.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index a9077f4..b6b591f 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -206,8 +206,8 @@ static u32 cubic_root(u64 a)
  */
 static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
 {
-	u64 offs;
-	u32 delta, t, bic_target, max_cnt;
+	u32 delta, bic_target, max_cnt;
+	u64 offs, t;
 
 	ca->ack_cnt++;	/* count the number of ACKs */
 
@@ -250,9 +250,11 @@ static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
 	 * if the cwnd < 1 million packets !!!
 	 */
 
+	t = (s32)(tcp_time_stamp - ca->epoch_start);
+	t += msecs_to_jiffies(ca->delay_min >> 3);
 	/* change the unit from HZ to bictcp_HZ */
-	t = ((tcp_time_stamp + msecs_to_jiffies(ca->delay_min>>3)
-	      - ca->epoch_start) << BICTCP_HZ) / HZ;
+	t <<= BICTCP_HZ;
+	do_div(t, HZ);
 
 	if (t < ca->bic_K)		/* t - K */
 		offs = ca->bic_K - t;
-- 
1.8.1.2

