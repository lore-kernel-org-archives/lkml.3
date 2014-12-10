Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaLJIrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:47:53 -0500
Received: from mail1.windriver.com ([147.11.146.13]:59482 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaLJIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:47:51 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <paulmck@linux.vnet.ibm.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <jon.maloy@ericsson.com>,
        <erik.hugne@ericsson.com>, <netdev@vger.kernel.org>,
        <kbuild-all@01.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next RESEND 2/2] ipv6: fix sparse warning
Date: Wed, 10 Dec 2014 16:46:07 +0800
Message-ID: <1418201167-9591-3-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
References: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following spare warning when using

make C=1 CF=-D__CHECK_ENDIAN__ net/ipv6/addrconf.o
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)

To silence above spare complaint, an RCU annotation should be added
to "next" pointer of hlist_node structure through hlist_next_rcu()
macro when iterating over a hlist with
hlist_for_each_entry_continue_rcu_bh().

By the way, this commit also resolves the same error appearing in
hlist_for_each_entry_continue_rcu().

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 include/linux/rculist.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 866d9c9..32bd4ad 100644
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
1.7.9.5

