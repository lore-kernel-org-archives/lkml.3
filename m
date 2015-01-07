Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbbAGRVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:21:16 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:44744 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbbAGRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:21:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Ying Xue <ying.xue@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rculist: Fix sparse warning
Date: Wed,  7 Jan 2015 09:20:54 -0800
Message-Id: <1420651257-553-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107172030.GA31571@linux.vnet.ibm.com>
 <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791AF0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>

This fixes the following sparse warnings:

make C=1 CF=-D__CHECK_ENDIAN__ net/ipv6/addrconf.o
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)

To silence these spare complaints, an RCU annotation should be added to
"next" pointer of hlist_node structure through hlist_next_rcu() macro
when iterating over a hlist with hlist_for_each_entry_continue_rcu_bh().

By the way, this commit also resolves the same error appearing in
hlist_for_each_entry_continue_rcu().

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 529bc946f450..a18b16f1dc0e 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -524,11 +524,11 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_continue_rcu(pos, member)			\
-	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
-			typeof(*(pos)), member);			\
+	for (pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu( \
+			&(pos)->member)), typeof(*(pos)), member);	\
 	     pos;							\
-	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
-			typeof(*(pos)), member))
+	     pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(	\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue_rcu_bh - iterate over a hlist continuing after current point
@@ -536,11 +536,11 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_continue_rcu_bh(pos, member)		\
-	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
-			typeof(*(pos)), member);			\
+	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(  \
+			&(pos)->member)), typeof(*(pos)), member);	\
 	     pos;							\
-	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
-			typeof(*(pos)), member))
+	     pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(	\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_from_rcu - iterate over a hlist continuing from current point
-- 
1.8.1.5

