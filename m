Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab3GZVG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:06:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab3GZU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/45] ifb: fix rcu_sched self-detected stalls
Date: Fri, 26 Jul 2013 13:57:44 -0700
Message-Id: <20130726205657.536317003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ifb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -252,8 +252,10 @@ static int __init ifb_init_module(void)
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


