Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbaELCQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:16:16 -0400
Received: from 1wt.eu ([62.212.114.60]:34431 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaELBl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:56 -0400
Message-Id: <20140512003201.797497685@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 028/143] net: do not call sock_put() on TIMEWAIT sockets
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 80ad1d61e72d626e30ebe8529a0455e660ca4693 ]

commit 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU /
hlist_nulls") incorrectly used sock_put() on TIMEWAIT sockets.

We should instead use inet_twsk_put()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_hashtables.c  | 2 +-
 net/ipv6/inet6_hashtables.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d717267..03fd04a 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -247,7 +247,7 @@ begintw:
 			}
 			if (unlikely(!INET_TW_MATCH(sk, net, hash, acookie,
 				 saddr, daddr, ports, dif))) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 093e9b2..93765577 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -104,7 +104,7 @@ begintw:
 				goto out;
 			}
 			if (!INET6_TW_MATCH(sk, net, hash, saddr, daddr, ports, dif)) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
-- 
1.7.12.2.21.g234cd45.dirty



