Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452Ab3EGElL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:41:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488Ab3EGEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:42 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=P-F6Ynh-PwUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DGnpng1v5bsA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=g7kyjjb2gZotL02U:21 a=eTQuv629vtRnctmv:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035859.554578633@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [111/126] net: count hw_addr syncs so that unsync works properly.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0111-net-count-hw_addr-syncs-so-that-unsync-works-properl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/netdevice.h |    2 +-
 net/core/dev_addr_lists.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b91c93b..e50d832 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -233,9 +233,9 @@ struct netdev_hw_addr {
 #define NETDEV_HW_ADDR_T_SLAVE		3
 #define NETDEV_HW_ADDR_T_UNICAST	4
 #define NETDEV_HW_ADDR_T_MULTICAST	5
-	bool			synced;
 	bool			global_use;
 	int			refcount;
+	int			synced;
 	struct rcu_head		rcu_head;
 };
 
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 716f363..fb898d7 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -38,7 +38,7 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
-	ha->synced = false;
+	ha->synced = 0;
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -164,7 +164,7 @@ int __hw_addr_sync(struct netdev_hw_addr_list *to_list,
 					    addr_len, ha->type);
 			if (err)
 				break;
-			ha->synced = true;
+			ha->synced++;
 			ha->refcount++;
 		} else if (ha->refcount == 1) {
 			__hw_addr_del(to_list, ha->addr, addr_len, ha->type);
@@ -185,7 +185,7 @@ void __hw_addr_unsync(struct netdev_hw_addr_list *to_list,
 		if (ha->synced) {
 			__hw_addr_del(to_list, ha->addr,
 				      addr_len, ha->type);
-			ha->synced = false;
+			ha->synced--;
 			__hw_addr_del(from_list, ha->addr,
 				      addr_len, ha->type);
 		}
-- 
1.7.10.4


