Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3G3Jd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3G3JdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/106] ifb: fix rcu_sched self-detected stalls
Date: Tue, 30 Jul 2013 10:31:15 +0100
Message-Id: <1375176725-5825-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

commit 440d57bc5ff55ec1efb3efc9cbe9420b4bbdfefa upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ifb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 344dceb..04ab337 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -291,8 +291,10 @@ static int __init ifb_init_module(void)
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
1.8.3.2

