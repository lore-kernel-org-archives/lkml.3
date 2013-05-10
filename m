Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3EJOof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:44:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57035 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab3EJOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlad Yasevich" <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.563468237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [087/118] net: count hw_addr syncs so that unsync works  properly.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/netdevice.h | 2 +-
 net/core/dev_addr_lists.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -225,9 +225,9 @@ struct netdev_hw_addr {
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

