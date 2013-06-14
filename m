Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3FNLan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:30:43 -0400
Received: from gate.alliedtelesyn.co.nz ([202.49.72.33]:41629 "HELO
	gate.alliedtelesyn.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752290Ab3FNLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:30:41 -0400
From: Aydin Arik <aydin.arik@alliedtelesis.co.nz>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aydin Arik <aydin.arik@alliedtelesis.co.nz>
Subject: [PATCH 1/1] [PATCH v2] tcp: Fixed MD5 key lookups when adding/removing MD5.
Date: Fri, 14 Jun 2013 23:30:03 +1200
Message-Id: <1371209403-28275-1-git-send-email-aydin.arik@alliedtelesis.co.nz>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MD5 key lookups on a given TCP socket were being performed
incorrectly. This fix alters parameter inputs to the MD5
lookup function tcp_md5_do_lookup, which is called by functions
tcp_md5_do_add and tcp_md5_do_del. Specifically, the change now
inputs the correct address and address family required to make
a proper lookup.

Commit a915da9b69273815527ccb3789421cb7027b545b ("tcp: md5: rcu conversion")
is the source of the regression.

Signed-off-by: Aydin Arik <aydin.arik@alliedtelesis.co.nz>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d09203c..da84cdb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1005,7 +1005,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
@@ -1050,7 +1050,7 @@ int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family)
 	struct tcp_md5sig_key *key;
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (!key)
 		return -ENOENT;
 	hlist_del_rcu(&key->node);
-- 
1.7.9.5

