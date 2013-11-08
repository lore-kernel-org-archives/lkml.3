Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3KHCQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3KHCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 17/91] net: mv643xx_eth: fix orphaned statistics timer crash
Date: Thu,  7 Nov 2013 18:14:32 -0800
Message-Id: <1383876946-2396-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

[ Upstream commit f564412c935111c583b787bcc18157377b208e2e ]

The periodic statistics timer gets started at port _probe() time, but
is stopped on _stop() only. In a modular environment, this can cause
the timer to access already deallocated memory, if the module is unloaded
without starting the eth device. To fix this, we add the timer right
before the port is started, instead of at _probe() time.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 6d89717..0733685 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2366,6 +2366,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 		mp->int_mask |= INT_TX_END_0 << i;
 	}
 
+	add_timer(&mp->mib_counters_timer);
 	port_start(mp);
 
 	wrlp(mp, INT_MASK_EXT, INT_EXT_LINK_PHY | INT_EXT_TX);
@@ -2913,7 +2914,6 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	mp->mib_counters_timer.data = (unsigned long)mp;
 	mp->mib_counters_timer.function = mib_counters_timer_wrapper;
 	mp->mib_counters_timer.expires = jiffies + 30 * HZ;
-	add_timer(&mp->mib_counters_timer);
 
 	spin_lock_init(&mp->mib_counters_lock);
 
-- 
1.8.1.2

