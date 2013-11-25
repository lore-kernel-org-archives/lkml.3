Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3KYOLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58830 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab3KYNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:45 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.38981060@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 03/87] net: do not call sock_put() on TIMEWAIT sockets
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 80ad1d61e72d626e30ebe8529a0455e660ca4693 ]

commit 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU /
hlist_nulls") incorrectly used sock_put() on TIMEWAIT sockets.

We should instead use inet_twsk_put()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/inet_hashtables.c  | 2 +-
 net/ipv6/inet6_hashtables.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 984ec65..4afcf31 100644
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

