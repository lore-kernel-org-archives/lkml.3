Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbaHZNqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:46:44 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:32812 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaHZNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:46:42 -0400
Date: Tue, 26 Aug 2014 16:46:32 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] ipv6: sit: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140826134632.GA1473@ada>
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
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 4f40817..24c2dba 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -167,7 +167,7 @@ static void ipip6_tunnel_link(struct sit_net *sitn, struct ip_tunnel *t)
 {
 	struct ip_tunnel __rcu **tp = ipip6_bucket(sitn, t);
 
-	rcu_assign_pointer(t->next, rtnl_dereference(*tp));
+	RCU_INIT_POINTER(t->next, rtnl_dereference(*tp));
 	rcu_assign_pointer(*tp, t);
 }
 
-- 
1.9.1

