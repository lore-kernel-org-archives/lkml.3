Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaELCSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:18:35 -0400
Received: from 1wt.eu ([62.212.114.60]:34395 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaELBln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:43 -0400
Message-Id: <20140512003204.794479746@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 100/143] tg3: Fix deadlock in tg3_change_mtu()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit c6993dfd7db9b0c6b7ca7503a56fda9236a4710f ]

Quoting David Vrabel -
"5780 cards cannot have jumbo frames and TSO enabled together.  When
jumbo frames are enabled by setting the MTU, the TSO feature must be
cleared.  This is done indirectly by calling netdev_update_features()
which will call tg3_fix_features() to actually clear the flags.

netdev_update_features() will also trigger a new netlink message for the
feature change event which will result in a call to tg3_get_stats64()
which deadlocks on the tg3 lock."

tg3_set_mtu() does not need to be under the tg3 lock since converting
the flags to use set_bit(). Move it out to after tg3_netif_stop().

Reported-by: David Vrabel <david.vrabel@citrix.com>
Tested-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/tg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 89aa69c..56648b4 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5583,12 +5583,12 @@ static int tg3_change_mtu(struct net_device *dev, int new_mtu)
 
 	tg3_netif_stop(tp);
 
+	tg3_set_mtu(dev, tp, new_mtu);
+
 	tg3_full_lock(tp, 1);
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
 
-	tg3_set_mtu(dev, tp, new_mtu);
-
 	err = tg3_restart_hw(tp, 0);
 
 	if (!err)
-- 
1.7.12.2.21.g234cd45.dirty



