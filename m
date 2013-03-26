Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3CZRgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3CZRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:29 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fJrb92fgSNwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=v2QcxWBWjx0A:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.372916885@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Pasi=20K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 72/86] tcp: fix an infinite loop in tcp_slow_start()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0072-tcp-fix-an-infinite-loop-in-tcp_slow_start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 93e3a886683c28e718e146c827e9cc750c88817e ]

Since commit 9dc274151a548 (tcp: fix ABC in tcp_slow_start()),
a nul snd_cwnd triggers an infinite loop in tcp_slow_start()

Avoid this infinite loop and log a one time error for further
analysis. FRTO code is suspected to cause this bug.

Reported-by: Pasi Kärkkäinen <pasik@iki.fi>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_cong.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 1432cdb..fc582a7 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -309,6 +309,12 @@ void tcp_slow_start(struct tcp_sock *tp)
 {
 	int cnt; /* increase in packets */
 	unsigned int delta = 0;
+	u32 snd_cwnd = tp->snd_cwnd;
+
+	if (unlikely(!snd_cwnd)) {
+		pr_err_once("snd_cwnd is nul, please report this bug.\n");
+		snd_cwnd = 1U;
+	}
 
 	/* RFC3465: ABC Slow start
 	 * Increase only after a full MSS of bytes is acked
@@ -323,7 +329,7 @@ void tcp_slow_start(struct tcp_sock *tp)
 	if (sysctl_tcp_max_ssthresh > 0 && tp->snd_cwnd > sysctl_tcp_max_ssthresh)
 		cnt = sysctl_tcp_max_ssthresh >> 1;	/* limited slow start */
 	else
-		cnt = tp->snd_cwnd;			/* exponential increase */
+		cnt = snd_cwnd;				/* exponential increase */
 
 	/* RFC3465: ABC
 	 * We MAY increase by 2 if discovered delayed ack
@@ -333,11 +339,11 @@ void tcp_slow_start(struct tcp_sock *tp)
 	tp->bytes_acked = 0;
 
 	tp->snd_cwnd_cnt += cnt;
-	while (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-		tp->snd_cwnd_cnt -= tp->snd_cwnd;
+	while (tp->snd_cwnd_cnt >= snd_cwnd) {
+		tp->snd_cwnd_cnt -= snd_cwnd;
 		delta++;
 	}
-	tp->snd_cwnd = min(tp->snd_cwnd + delta, tp->snd_cwnd_clamp);
+	tp->snd_cwnd = min(snd_cwnd + delta, tp->snd_cwnd_clamp);
 }
 EXPORT_SYMBOL_GPL(tcp_slow_start);
 
-- 
1.7.10.4


