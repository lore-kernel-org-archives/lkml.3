Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3LSLzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:55:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3LSLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 017/208] net-tcp: fix panic in tcp_fastopen_cache_set()
Date: Thu, 19 Dec 2013 11:51:55 +0000
Message-Id: <1387454106-19326-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit dccf76ca6b626c0c4a4e09bb221adee3270ab0ef upstream.

We had some reports of crashes using TCP fastopen, and Dave Jones
gave a nice stack trace pointing to the error.

Issue is that tcp_get_metrics() should not be called with a NULL dst

Fixes: 1fe4c481ba637 ("net-tcp: Fast Open client - cookie cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Tested-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_metrics.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index f6a005c..306dbd9 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -665,10 +665,13 @@ void tcp_fastopen_cache_get(struct sock *sk, u16 *mss,
 void tcp_fastopen_cache_set(struct sock *sk, u16 mss,
 			    struct tcp_fastopen_cookie *cookie, bool syn_lost)
 {
+	struct dst_entry *dst = __sk_dst_get(sk);
 	struct tcp_metrics_block *tm;
 
+	if (!dst)
+		return;
 	rcu_read_lock();
-	tm = tcp_get_metrics(sk, __sk_dst_get(sk), true);
+	tm = tcp_get_metrics(sk, dst, true);
 	if (tm) {
 		struct tcp_fastopen_metrics *tfom = &tm->tcpm_fastopen;
 
-- 
1.8.3.2

