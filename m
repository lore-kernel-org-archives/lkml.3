Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaCJCG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:06:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30686 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaCJCG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:06:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,621,1389715200"; 
   d="scan'208";a="9668905"
Message-ID: <531D1C0E.6010507@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 09:57:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: add a pre-check of net_ns in sk_change_net()
References: <5319A3C2.8080001@cn.fujitsu.com> <20140309.190941.472588800498066811.davem@davemloft.net>
In-Reply-To: <20140309.190941.472588800498066811.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 10:03:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 10:03:40,
	Serialize complete at 2014/03/10 10:03:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to switch the net_ns if the target net_ns the same
as the current one, so here we add a pre-check of net_ns to avoid
this as David suggested.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 include/net/sock.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5c3f7c3..9678569 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2252,8 +2252,12 @@ void sock_net_set(struct sock *sk, struct net *net)
  */
 static inline void sk_change_net(struct sock *sk, struct net *net)
 {
-	put_net(sock_net(sk));
-	sock_net_set(sk, hold_net(net));
+	struct net *current_net = sock_net(sk);
+
+	if (!net_eq(current_net, net)) {
+		put_net(current_net);
+		sock_net_set(sk, hold_net(net));
+	}
 }
 
 static inline struct sock *skb_steal_sock(struct sk_buff *skb)
-- 
1.7.7


