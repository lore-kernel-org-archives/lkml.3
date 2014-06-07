Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaFGBhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Liu Yu" <allanyuliu@tencent.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Stephen Hemminger" <shemminger@vyatta.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.475369630@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/92] tcp_cubic: fix the range of delayed_ack
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b78eac2..ed3d6d4 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -406,7 +406,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
 		ratio += cnt;
 
-		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
+		ca->delayed_ack = clamp(ratio, 1U, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */

