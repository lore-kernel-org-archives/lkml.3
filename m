Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaBEUE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:04:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:54470 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaBEUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jesper Dangaard Brouer <brouer@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 045/213] net: fix divide by zero in tcp algorithm illinois
Date: Wed, 5 Feb 2014 15:00:00 -0500
Message-ID: <1391630568-49251-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8f363b77ee4fbf7c3bbcf5ec2c5ca482d396d664 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp_illinois.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 1eba160b72dc..c35d91f0fb11 100644
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
1.8.5.2

