Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3J1O6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:58:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab3J1Ot2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 39/64] net: do not call sock_put() on TIMEWAIT sockets
Date: Mon, 28 Oct 2013 14:47:58 +0000
Message-Id: <1382971703-17393-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 80ad1d61e72d626e30ebe8529a0455e660ca4693 upstream.

commit 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU /
hlist_nulls") incorrectly used sock_put() on TIMEWAIT sockets.

We should instead use inet_twsk_put()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/inet_hashtables.c  | 2 +-
 net/ipv6/inet6_hashtables.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7880af9..ffd0f56 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -268,7 +268,7 @@ begintw:
 			}
 			if (unlikely(!INET_TW_MATCH(sk, net, hash, acookie,
 				 saddr, daddr, ports, dif))) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 73f1a00..e38290b 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -110,7 +110,7 @@ begintw:
 				goto out;
 			}
 			if (!INET6_TW_MATCH(sk, net, hash, saddr, daddr, ports, dif)) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
-- 
1.8.3.2

