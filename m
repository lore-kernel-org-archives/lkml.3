Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3FDWns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35769 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3FDWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:40 -0400
Message-Id: <20130604172136.684192507@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Petr Matousek <pmatouse@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 154/184] net: fix divide by zero in tcp algorithm illinois
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <brouer@redhat.com>

commit 8f363b77ee4fbf7c3bbcf5ec2c5ca482d396d664 upstream

Reading TCP stats when using TCP Illinois congestion control algorithm
can cause a divide by zero kernel oops.

The division by zero occur in tcp_illinois_info() at:
 do_div(t, ca->cnt_rtt);
where ca->cnt_rtt can become zero (when rtt_reset is called)

Steps to Reproduce:
 1. Register tcp_illinois:
     # sysctl -w net.ipv4.tcp_congestion_control=illinois
 2. Monitor internal TCP information via command "ss -i"
     # watch -d ss -i
 3. Establish new TCP conn to machine

Either it fails at the initial conn, or else it needs to wait
for a loss or a reset.

This is only related to reading stats.  The function avg_delay() also
performs the same divide, but is guarded with a (ca->cnt_rtt > 0) at its
calling point in update_params().  Thus, simply fix tcp_illinois_info().

Function tcp_illinois_info() / get_info() is called without
socket lock.  Thus, eliminate any race condition on ca->cnt_rtt
by using a local stack variable.  Simply reuse info.tcpv_rttcnt,
as its already set to ca->cnt_rtt.
Function avg_delay() is not affected by this race condition, as
its called with the socket lock.

Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_illinois.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 1eba160..c35d91f 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -313,11 +313,13 @@ static void tcp_illinois_info(struct sock *sk, u32 ext,
 			.tcpv_rttcnt = ca->cnt_rtt,
 			.tcpv_minrtt = ca->base_rtt,
 		};
-		u64 t = ca->sum_rtt;
 
-		do_div(t, ca->cnt_rtt);
-		info.tcpv_rtt = t;
+		if (info.tcpv_rttcnt > 0) {
+			u64 t = ca->sum_rtt;
 
+			do_div(t, info.tcpv_rttcnt);
+			info.tcpv_rtt = t;
+		}
 		nla_put(skb, INET_DIAG_VEGASINFO, sizeof(info), &info);
 	}
 }
-- 
1.7.12.2.21.g234cd45.dirty



