Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3BQWze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45687 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab3BQWzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:22 -0500
Message-Id: <20130217225008.708037902@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:51:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 61/66] tcp: fix for zero packets_in_flight was too broad
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ Upstream commit 6731d2095bd4aef18027c72ef845ab1087c3ba63 ]

There are transients during normal FRTO procedure during which
the packets_in_flight can go to zero between write_queue state
updates and firing the resulting segments out. As FRTO processing
occurs during that window the check must be more precise to
not match "spuriously" :-). More specificly, e.g., when
packets_in_flight is zero but FLAG_DATA_ACKED is true the problematic
branch that set cwnd into zero would not be taken and new segments
might be sent out later.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Tested-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 308b5b4..e865ed1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3635,8 +3635,7 @@ static int tcp_process_frto(struct sock *sk, int flag)
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark) ||
-	    !tcp_packets_in_flight(tp)) {
+	if (!before(tp->snd_una, tp->frto_highmark)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return 1;
 	}
@@ -3656,6 +3655,11 @@ static int tcp_process_frto(struct sock *sk, int flag)
 		}
 	} else {
 		if (!(flag & FLAG_DATA_ACKED) && (tp->frto_counter == 1)) {
+			if (!tcp_packets_in_flight(tp)) {
+				tcp_enter_frto_loss(sk, 2, flag);
+				return true;
+			}
+
 			/* Prevent sending of new data. */
 			tp->snd_cwnd = min(tp->snd_cwnd,
 					   tcp_packets_in_flight(tp));


