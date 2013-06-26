Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3FZCrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:47:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54182 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab3FZCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Boris Zhmurov" <zhmurov@yandex-team.ru>,
        "Roman Gushchin" <klamm@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:59 +0100
Message-ID: <lsq.1372214159.708140691@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [20/26] net: force a reload of first item in  hlist_nulls_for_each_entry_rcu
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/rculist_nulls.h | 7 ++++++-
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

