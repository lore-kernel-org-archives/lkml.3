Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3FDWyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:54:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35778 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3FDWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:48 -0400
Message-Id: <20130604172136.933976596@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        Van Jacobson <vanj@google.com>, Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 160/184] tcp: preserve ACK clocking in TSO
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f4541d60a449afd40448b06496dcd510f505928e ]

A long standing problem with TSO is the fact that tcp_tso_should_defer()
rearms the deferred timer, while it should not.

Current code leads to following bad bursty behavior :

20:11:24.484333 IP A > B: . 297161:316921(19760) ack 1 win 119
20:11:24.484337 IP B > A: . ack 263721 win 1117
20:11:24.485086 IP B > A: . ack 265241 win 1117
20:11:24.485925 IP B > A: . ack 266761 win 1117
20:11:24.486759 IP B > A: . ack 268281 win 1117
20:11:24.487594 IP B > A: . ack 269801 win 1117
20:11:24.488430 IP B > A: . ack 271321 win 1117
20:11:24.489267 IP B > A: . ack 272841 win 1117
20:11:24.490104 IP B > A: . ack 274361 win 1117
20:11:24.490939 IP B > A: . ack 275881 win 1117
20:11:24.491775 IP B > A: . ack 277401 win 1117
20:11:24.491784 IP A > B: . 316921:332881(15960) ack 1 win 119
20:11:24.492620 IP B > A: . ack 278921 win 1117
20:11:24.493448 IP B > A: . ack 280441 win 1117
20:11:24.494286 IP B > A: . ack 281961 win 1117
20:11:24.495122 IP B > A: . ack 283481 win 1117
20:11:24.495958 IP B > A: . ack 285001 win 1117
20:11:24.496791 IP B > A: . ack 286521 win 1117
20:11:24.497628 IP B > A: . ack 288041 win 1117
20:11:24.498459 IP B > A: . ack 289561 win 1117
20:11:24.499296 IP B > A: . ack 291081 win 1117
20:11:24.500133 IP B > A: . ack 292601 win 1117
20:11:24.500970 IP B > A: . ack 294121 win 1117
20:11:24.501388 IP B > A: . ack 295641 win 1117
20:11:24.501398 IP A > B: . 332881:351881(19000) ack 1 win 119

While the expected behavior is more like :

20:19:49.259620 IP A > B: . 197601:202161(4560) ack 1 win 119
20:19:49.260446 IP B > A: . ack 154281 win 1212
20:19:49.261282 IP B > A: . ack 155801 win 1212
20:19:49.262125 IP B > A: . ack 157321 win 1212
20:19:49.262136 IP A > B: . 202161:206721(4560) ack 1 win 119
20:19:49.262958 IP B > A: . ack 158841 win 1212
20:19:49.263795 IP B > A: . ack 160361 win 1212
20:19:49.264628 IP B > A: . ack 161881 win 1212
20:19:49.264637 IP A > B: . 206721:211281(4560) ack 1 win 119
20:19:49.265465 IP B > A: . ack 163401 win 1212
20:19:49.265886 IP B > A: . ack 164921 win 1212
20:19:49.266722 IP B > A: . ack 166441 win 1212
20:19:49.266732 IP A > B: . 211281:215841(4560) ack 1 win 119
20:19:49.267559 IP B > A: . ack 167961 win 1212
20:19:49.268394 IP B > A: . ack 169481 win 1212
20:19:49.269232 IP B > A: . ack 171001 win 1212
20:19:49.269241 IP A > B: . 215841:221161(5320) ack 1 win 119

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Van Jacobson <vanj@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Nandita Dukkipati <nanditad@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_output.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index af83bdf..38a23e4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1391,8 +1391,11 @@ static int tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb)
 			goto send_now;
 	}
 
-	/* Ok, it looks like it is advisable to defer.  */
-	tp->tso_deferred = 1 | (jiffies << 1);
+	/* Ok, it looks like it is advisable to defer.
+	 * Do not rearm the timer if already set to not break TCP ACK clocking.
+	 */
+	if (!tp->tso_deferred)
+		tp->tso_deferred = 1 | (jiffies << 1);
 
 	return 1;
 
-- 
1.7.12.2.21.g234cd45.dirty



