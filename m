Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3JMAN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 20:13:59 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50946 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3JMAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 20:13:58 -0400
From: baker.kernel@gmail.com
To: davem@davemloft.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "baker.zhang" <baker.kernel@gmail.com>
Subject: [PATCH net-next] fib_trie: remove duplicated rcu lock
Date: Sun, 13 Oct 2013 08:13:37 +0800
Message-Id: <1381623217-5883-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "baker.zhang" <baker.kernel@gmail.com>

fib_table_lookup has included the rcu lock protection.

Signed-off-by: baker.zhang <baker.kernel@gmail.com>
---
 net/ipv4/fib_frontend.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b3f627a..0e9127d 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -170,12 +170,10 @@ static inline unsigned int __inet_dev_addr_type(struct net *net,
 	local_table = fib_get_table(net, RT_TABLE_LOCAL);
 	if (local_table) {
 		ret = RTN_UNICAST;
-		rcu_read_lock();
 		if (!fib_table_lookup(local_table, &fl4, &res, FIB_LOOKUP_NOREF)) {
 			if (!dev || dev == res.fi->fib_dev)
 				ret = res.type;
 		}
-		rcu_read_unlock();
 	}
 	return ret;
 }
@@ -933,7 +931,6 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb)
 		local_bh_disable();
 
 		frn->tb_id = tb->tb_id;
-		rcu_read_lock();
 		frn->err = fib_table_lookup(tb, &fl4, &res, FIB_LOOKUP_NOREF);
 
 		if (!frn->err) {
@@ -942,7 +939,6 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb)
 			frn->type = res.type;
 			frn->scope = res.scope;
 		}
-		rcu_read_unlock();
 		local_bh_enable();
 	}
 }
-- 
1.8.1.2

