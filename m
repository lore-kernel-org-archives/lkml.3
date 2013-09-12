Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3ILRvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:51:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3ILRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/23] tcp: cubic: fix overflow error in bictcp_update()
Date: Thu, 12 Sep 2013 10:45:02 -0700
Message-Id: <20130912174452.460626971@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_cubic.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

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
 
@@ -250,9 +250,11 @@ static inline void bictcp_update(struct
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


