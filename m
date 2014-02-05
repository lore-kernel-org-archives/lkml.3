Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaBEVHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:07:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48002 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaBEUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        Van Jacobson <vanj@google.com>, Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 042/213] tcp: preserve ACK clocking in TSO
Date: Wed, 5 Feb 2014 14:59:57 -0500
Message-ID: <1391630568-49251-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f4541d60a449afd40448b06496dcd510f505928e upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp_output.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6fdff3045b62..407a6ff44415 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1566,8 +1566,11 @@ static int tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb)
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
1.8.5.2

