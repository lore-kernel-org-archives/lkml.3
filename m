Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3J1O5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:57:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51211 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3J1Otb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 41/64] net: mv643xx_eth: fix orphaned statistics timer crash
Date: Mon, 28 Oct 2013 14:48:00 +0000
Message-Id: <1382971703-17393-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit f564412c935111c583b787bcc18157377b208e2e upstream.

The periodic statistics timer gets started at port _probe() time, but
is stopped on _stop() only. In a modular environment, this can cause
the timer to access already deallocated memory, if the module is unloaded
without starting the eth device. To fix this, we add the timer right
before the port is started, instead of at _probe() time.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index ae50dd6..02b03b5 100644
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
1.8.3.2

