Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3DBWNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:13:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3DBWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        Van Jacobson <vanj@google.com>, Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 100/124] tcp: preserve ACK clocking in TSO
Date: Tue,  2 Apr 2013 15:11:22 -0700
Message-Id: <20130402221115.717887239@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/ipv4/tcp_output.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1809,8 +1809,11 @@ static bool tcp_tso_should_defer(struct
 			goto send_now;
 	}
 
-	/* Ok, it looks like it is advisable to defer.  */
-	tp->tso_deferred = 1 | (jiffies << 1);
+	/* Ok, it looks like it is advisable to defer.
+	 * Do not rearm the timer if already set to not break TCP ACK clocking.
+	 */
+	if (!tp->tso_deferred)
+		tp->tso_deferred = 1 | (jiffies << 1);
 
 	return true;
 


