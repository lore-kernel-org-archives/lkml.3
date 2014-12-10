Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaLJIqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:46:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:46452 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaLJIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:46:30 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <paulmck@linux.vnet.ibm.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <jon.maloy@ericsson.com>,
        <erik.hugne@ericsson.com>, <netdev@vger.kernel.org>,
        <kbuild-all@01.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next RESEND 1/2] tipc: fix RCU sparse error
Date: Wed, 10 Dec 2014 16:46:06 +0800
Message-ID: <1418201167-9591-2-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
References: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 97ede29e80ee ("tipc: convert name table read-write lock to
RCU") involves the following sparse when using

  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__

net/tipc/name_table.c:1136:17: sparse: incompatible types in comparison expression (different address spaces)
net/tipc/name_table.c:1136:17: sparse: incompatible types in comparison expression (different address spaces)

To silence above spare complaint, an RCU annotation should be added
to "next" pointer of hlist_node structure through hlist_next_rcu()
macro when iterating over a hlist with hlist_for_each_entry_from_rcu().

By the way, this commit also simplifies the way of dereferencing
the first element of a hlist_head list by replacing
hlist_for_each_entry_rcu() with hlist_entry_safe().

Reported-by: Kbuild test robot <kbuild-all@01.org>
Cc: Kbuild test robot <kbuild-all@01.org>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 include/linux/rculist.h |    4 ++--
 net/tipc/name_table.c   |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index aa79b3c..866d9c9 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -549,8 +549,8 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  */
 #define hlist_for_each_entry_from_rcu(pos, member)			\
 	for (; pos;							\
-	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
-			typeof(*(pos)), member))
+	     pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu( \
+			&(pos)->member)), typeof(*(pos)), member))
 
 #endif	/* __KERNEL__ */
 #endif
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index c8df022..fa4341f 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -1110,7 +1110,7 @@ static int __tipc_nl_seq_list(struct tipc_nl_msg *msg, u32 *last_type,
 			      u32 *last_lower, u32 *last_publ)
 {
 	struct hlist_head *seq_head;
-	struct name_seq *seq = NULL;
+	struct name_seq *seq;
 	int err;
 	int i;
 
@@ -1127,8 +1127,8 @@ static int __tipc_nl_seq_list(struct tipc_nl_msg *msg, u32 *last_type,
 			if (!seq)
 				return -EPIPE;
 		} else {
-			hlist_for_each_entry_rcu(seq, seq_head, ns_list)
-				break;
+			seq = hlist_entry_safe(rcu_dereference_raw(
+			hlist_first_rcu(seq_head)), struct name_seq, ns_list);
 			if (!seq)
 				continue;
 		}
-- 
1.7.9.5

