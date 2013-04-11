Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566Ab3DKVVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:21:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935460Ab3DKUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:54 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mrGHgKfAx7IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GeoeZEqiE6cA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202610.878036466@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yuchung Cheng <ycheng@google.com>, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 150/171 ] tcp: undo spurious timeout after SACK reneging
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0150-tcp-undo-spurious-timeout-after-SACK-reneging.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 7ebe183c6d444ef5587d803b64a1f4734b18c564 ]

On SACK reneging the sender immediately retransmits and forces a
timeout but disables Eifel (undo). If the (buggy) receiver does not
drop any packet this can trigger a false slow-start retransmit storm
driven by the ACKs of the original packets. This can be detected with
undo and TCP timestamps.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/tcp_input.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 396c6ae..db1b172 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2083,11 +2083,8 @@ void tcp_enter_loss(struct sock *sk, int how)
 	if (tcp_is_reno(tp))
 		tcp_reset_reno_sack(tp);
 
-	if (!how) {
-		/* Push undo marker, if it was plain RTO and nothing
-		 * was retransmitted. */
-		tp->undo_marker = tp->snd_una;
-	} else {
+	tp->undo_marker = tp->snd_una;
+	if (how) {
 		tp->sacked_out = 0;
 		tp->fackets_out = 0;
 	}
-- 
1.7.10.4


