Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaELCGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:06:46 -0400
Received: from 1wt.eu ([62.212.114.60]:34542 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbaELBm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:26 -0400
Message-Id: <20140512003205.924777846@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 126/143] tcp_cubic: limit delayed_ack ratio to prevent divide error
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

TCP Cubic keeps a metric that estimates the amount of delayed
acknowledgements to use in adjusting the window. If an abnormally
large number of packets are acknowledged at once, then the update
could wrap and reach zero. This kind of ACK could only
happen when there was a large window and huge number of
ACK's were lost.

This patch limits the value of delayed ack ratio. The choice of 32
is just a conservative value since normally it should be range of
1 to 4 packets.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit b9f47a3aaeabdce3b42829bbb27765fa340f76ba)
[wt: in 2.6.32, this fix is needed for the next one]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_cubic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 0d41c26..1b6b8c2 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -90,6 +90,7 @@ struct bictcp {
 	u32	ack_cnt;	/* number of acks */
 	u32	tcp_cwnd;	/* estimated tcp cwnd */
 #define ACK_RATIO_SHIFT	4
+#define ACK_RATIO_LIMIT (32u << ACK_RATIO_SHIFT)
 	u16	delayed_ack;	/* estimate the ratio of Packets/ACKs << 4 */
 	u8	sample_cnt;	/* number of samples to decide curr_rtt */
 	u8	found;		/* the exit point is found? */
@@ -379,8 +380,12 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 	u32 delay;
 
 	if (icsk->icsk_ca_state == TCP_CA_Open) {
-		cnt -= ca->delayed_ack >> ACK_RATIO_SHIFT;
-		ca->delayed_ack += cnt;
+		u32 ratio = ca->delayed_ack;
+
+		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
+		ratio += cnt;
+
+		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */
-- 
1.7.12.2.21.g234cd45.dirty



