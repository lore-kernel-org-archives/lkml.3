Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab3CZRzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:55:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CZRgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:15 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RukVFyfidrwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Tn2-2cLip6UA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173605.049879635@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 32/86] tcp: fix for zero packets_in_flight was too broad
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0032-tcp-fix-for-zero-packets_in_flight-was-too-broad.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>

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
---
 net/ipv4/tcp_input.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 97cbfa9..8d02e34 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3511,8 +3511,7 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark) ||
-	    !tcp_packets_in_flight(tp)) {
+	if (!before(tp->snd_una, tp->frto_highmark)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return true;
 	}
@@ -3532,6 +3531,11 @@ static bool tcp_process_frto(struct sock *sk, int flag)
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
-- 
1.7.10.4


