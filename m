Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab3D2TSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:18:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759775Ab3D2TDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/34] net: count hw_addr syncs so that unsync works properly.
Date: Mon, 29 Apr 2013 12:02:27 -0700
Message-Id: <20130429184703.167187804@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 4543fbefe6e06a9e40d9f2b28d688393a299f079 ]

A few drivers use dev_uc_sync/unsync to synchronize the
address lists from master down to slave/lower devices.  In
some cases (bond/team) a single address list is synched down
to multiple devices.  At the time of unsync, we have a leak
in these lower devices, because "synced" is treated as a
boolean and the address will not be unsynced for anything after
the first device/call.

Treat "synced" as a count (same as refcount) and allow all
unsync calls to work.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 +-
 net/core/dev_addr_lists.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -232,9 +232,9 @@ struct netdev_hw_addr {
 #define NETDEV_HW_ADDR_T_SLAVE		3
 #define NETDEV_HW_ADDR_T_UNICAST	4
 #define NETDEV_HW_ADDR_T_MULTICAST	5
-	bool			synced;
 	bool			global_use;
 	int			refcount;
+	int			synced;
 	struct rcu_head		rcu_head;
 };
 
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -57,7 +57,7 @@ static int __hw_addr_add_ex(struct netde
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
-	ha->synced = false;
+	ha->synced = 0;
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 	return 0;
@@ -155,7 +155,7 @@ int __hw_addr_sync(struct netdev_hw_addr
 					    addr_len, ha->type);
 			if (err)
 				break;
-			ha->synced = true;
+			ha->synced++;
 			ha->refcount++;
 		} else if (ha->refcount == 1) {
 			__hw_addr_del(to_list, ha->addr, addr_len, ha->type);
@@ -176,7 +176,7 @@ void __hw_addr_unsync(struct netdev_hw_a
 		if (ha->synced) {
 			__hw_addr_del(to_list, ha->addr,
 				      addr_len, ha->type);
-			ha->synced = false;
+			ha->synced--;
 			__hw_addr_del(from_list, ha->addr,
 				      addr_len, ha->type);
 		}


