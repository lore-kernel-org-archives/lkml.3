Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab3BQXGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:06:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45706 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295Ab3BQWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:25 -0500
Message-Id: <20130217225008.595345988@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:51:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Dumazet <edumazet@google.com>,
        =?ISO-8859-15?q?Pasi=20K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>,
        Neal Cardwell <ncardwell@google.com>,
        =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/66] tcp: frto should not set snd_cwnd to 0
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2e5f421211ff76c17130b4597bc06df4eeead24f ]

Commit 9dc274151a548 (tcp: fix ABC in tcp_slow_start())
uncovered a bug in FRTO code :
tcp_process_frto() is setting snd_cwnd to 0 if the number
of in flight packets is 0.

As Neal pointed out, if no packet is in flight we lost our
chance to disambiguate whether a loss timeout was spurious.

We should assume it was a proper loss.

Reported-by: Pasi Kärkkäinen <pasik@iki.fi>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index aab8f08..308b5b4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3635,7 +3635,8 @@ static int tcp_process_frto(struct sock *sk, int flag)
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark)) {
+	if (!before(tp->snd_una, tp->frto_highmark) ||
+	    !tcp_packets_in_flight(tp)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return 1;
 	}


