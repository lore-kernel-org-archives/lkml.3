Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3HMQHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:07:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3HMP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:31 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Np24JC0xKa4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OZILsRLrZA0A:10 a=pGLkceISAAAA:8 a=D19gQVrFAAAA:8 a=6R7veym_AAAA:8 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=J1Y8HTJGAAAA:8 a=KZ_wpIXNaCr4X69ulSMA:9 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155827.239598866@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Boris Zhmurov <zhmurov@yandex-team.ru>,
        Roman Gushchin <klamm@yandex-team.ru>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [23/88] net: force a reload of first item in hlist_nulls_for_each_entry_rcu
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0023-net-force-a-reload-of-first-item-in-hlist_nulls_for_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit c87a124a5d5e8cf8e21c4363c3372bcaf53ea190 ]

Roman Gushchin discovered that udp4_lib_lookup2() was not reloading
first item in the rcu protected list, in case the loop was restarted.

This produced soft lockups as in https://lkml.org/lkml/2013/4/16/37

rcu_dereference(X)/ACCESS_ONCE(X) seem to not work as intended if X is
ptr->field :

In some cases, gcc caches the value or ptr->field in a register.

Use a barrier() to disallow such caching, as documented in
Documentation/atomic_ops.txt line 114

Thanks a lot to Roman for providing analysis and numerous patches.

Diagnosed-by: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Boris Zhmurov <zhmurov@yandex-team.ru>
Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rculist_nulls.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2ae1371..1c33dd7 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -105,9 +105,14 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  * @head:	the head for your list.
  * @member:	the name of the hlist_nulls_node within the struct.
  *
+ * The barrier() is needed to make sure compiler doesn't cache first element [1],
+ * as this loop can be restarted [2]
+ * [1] Documentation/atomic_ops.txt around line 114
+ * [2] Documentation/RCU/rculist_nulls.txt around line 146
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
-	for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+	for (({barrier();}),							\
+	     pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
 		(!is_a_nulls(pos)) &&						\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
-- 
1.7.10.4


