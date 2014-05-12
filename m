Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaELBvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:51:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34749 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbaELBnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:53 -0400
Message-Id: <20140512003202.877708998@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 054/143] ifb: fix rcu_sched self-detected stalls
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit 440d57bc5ff55ec1efb3efc9cbe9420b4bbdfefa ]

According to the commit 16b0dc29c1af9df341428f4c49ada4f626258082
(dummy: fix rcu_sched self-detected stalls)

Eric Dumazet fix the problem in dummy, but the ifb will occur the
same problem like the dummy modules.

Trying to "modprobe ifb numifbs=30000" triggers :

INFO: rcu_sched self-detected stall on CPU

After this splat, RTNL is locked and reboot is needed.

We must call cond_resched() to avoid this, even holding RTNL.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[wt: 2.6.32: cond_resched() needs linux/sched.h]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ifb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 030913f..cfd5510 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -33,6 +33,7 @@
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 
@@ -269,8 +270,10 @@ static int __init ifb_init_module(void)
 	rtnl_lock();
 	err = __rtnl_link_register(&ifb_link_ops);
 
-	for (i = 0; i < numifbs && !err; i++)
+	for (i = 0; i < numifbs && !err; i++) {
 		err = ifb_init_one(i);
+		cond_resched();
+	}
 	if (err)
 		__rtnl_link_unregister(&ifb_link_ops);
 	rtnl_unlock();
-- 
1.7.12.2.21.g234cd45.dirty



