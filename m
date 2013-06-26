Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3FZCtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:49:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab3FZCpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neal Cardwell" <ncardwell@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Tom Herbert" <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.646183620@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [17/26] tcp: xps: fix reordering issues
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 547669d483e5783d722772af1483fa474da7caf9 ]

commit 3853b5841c01a ("xps: Improvements in TX queue selection")
introduced ooo_okay flag, but the condition to set it is slightly wrong.

In our traces, we have seen ACK packets being received out of order,
and RST packets sent in response.

We should test if we have any packets still in host queue.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_output.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5c1807c..3add486 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -835,11 +835,13 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 							   &md5);
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
-	if (tcp_packets_in_flight(tp) == 0) {
+	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
-		skb->ooo_okay = 1;
-	} else
-		skb->ooo_okay = 0;
+
+	/* if no packet is in qdisc/device queue, then allow XPS to select
+	 * another queue.
+	 */
+	skb->ooo_okay = sk_wmem_alloc_get(sk) == 0;
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);

