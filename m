Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3BLUg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3BLUgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Pasi=20K=E4rkk=E4inen?= <pasik@iki.fi>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/61] tcp: fix an infinite loop in tcp_slow_start()
Date: Tue, 12 Feb 2013 12:35:13 -0800
Message-Id: <20130212203425.027018012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 973ec449bb4f2b8c514bacbcb4d9506fc31c8ce3 ]

Since commit 9dc274151a548 (tcp: fix ABC in tcp_slow_start()),
a nul snd_cwnd triggers an infinite loop in tcp_slow_start()

Avoid this infinite loop and log a one time error for further
analysis. FRTO code is suspected to cause this bug.

Reported-by: Pasi Kärkkäinen <pasik@iki.fi>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_cong.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
 


