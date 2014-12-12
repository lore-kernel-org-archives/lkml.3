Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbaLLBg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 20:36:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:42715 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaLLBg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 20:36:27 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] rculist: fix sparse warning
Date: Fri, 12 Dec 2014 09:36:14 +0800
Message-ID: <1418348174-26797-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning when using

make C=1 CF=-D__CHECK_ENDIAN__ net/ipv6/addrconf.o
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)

To silence above spare complaint, an RCU annotation should be added to
"next" pointer of hlist_node structure through hlist_next_rcu() macro
when iterating over a hlist with hlist_for_each_entry_continue_rcu_bh().

By the way, this commit also resolves the same error appearing in
hlist_for_each_entry_continue_rcu().

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
The commit is based on next.2014.12.11a branch of linux-rcu tree 

 include/linux/rculist.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 372ad5e..6f7aefb 100644
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
 
 
 #endif	/* __KERNEL__ */
-- 
1.7.9.5

