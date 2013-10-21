Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3JUJfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:35:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39266 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065Ab3JUIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yuchung Cheng" <ycheng@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.726246978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 004/149] tcp: cubic: fix overflow error in bictcp_update()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_cubic.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index f376b05..b9d22e6 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -204,8 +204,8 @@ static u32 cubic_root(u64 a)
  */
 static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
 {
-	u64 offs;
-	u32 delta, t, bic_target, max_cnt;
+	u32 delta, bic_target, max_cnt;
+	u64 offs, t;
 
 	ca->ack_cnt++;	/* count the number of ACKs */
 
@@ -248,9 +248,11 @@ static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
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

