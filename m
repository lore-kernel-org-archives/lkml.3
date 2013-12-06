Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab3LFWkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:40:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab3LFVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Dave Jones <davej@redhat.com>,
        Yuchung Cheng <ycheng@google.com>,
        Dave Jones <davej@fedoraproject.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 19/83] net-tcp: fix panic in tcp_fastopen_cache_set()
Date: Fri,  6 Dec 2013 13:51:09 -0800
Message-Id: <20131206214641.857972969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dccf76ca6b626c0c4a4e09bb221adee3270ab0ef ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_metrics.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -659,10 +659,13 @@ void tcp_fastopen_cache_get(struct sock
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
 


