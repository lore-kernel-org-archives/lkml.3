Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbaHZOFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:05:55 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:41682 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbaHZOFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:05:54 -0400
Date: Tue, 26 Aug 2014 17:05:43 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] ipv6: ip6_tunnel: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140826140543.GA1846@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

This case fulfills the conditions above because between the rtnl_dereference()
call and the rcu_assign_pointer() call there is no update of that value.
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (...,
(
 rtnl_dereference(...)
|
 rcu_dereference_protected(...)
) )

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index afa0824..3837be3 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -233,7 +233,7 @@ ip6_tnl_link(struct ip6_tnl_net *ip6n, struct ip6_tnl *t)
 {
 	struct ip6_tnl __rcu **tp = ip6_tnl_bucket(ip6n, &t->parms);
 
-	rcu_assign_pointer(t->next , rtnl_dereference(*tp));
+	RCU_INIT_POINTER(t->next , rtnl_dereference(*tp));
 	rcu_assign_pointer(*tp, t);
 }
 
-- 
1.9.1

