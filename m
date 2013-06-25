Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3FYSgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:36:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3FYSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:36:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Boris Zhmurov <zhmurov@yandex-team.ru>,
        Roman Gushchin <klamm@yandex-team.ru>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/27] net: force a reload of first item in hlist_nulls_for_each_entry_rcu
Date: Tue, 25 Jun 2013 11:35:35 -0700
Message-Id: <20130625183519.559502143@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rculist_nulls.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -105,9 +105,14 @@ static inline void hlist_nulls_add_head_
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


