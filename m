Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3J1O6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:58:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51206 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3J1Ot3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 40/64] net: mv643xx_eth: update statistics timer from timer context only
Date: Mon, 28 Oct 2013 14:47:59 +0000
Message-Id: <1382971703-17393-41-git-send-email-luis.henriques@canonical.com>
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

commit 041b4ddb84989f06ff1df0ca869b950f1ee3cb1c upstream.

Each port driver installs a periodic timer to update port statistics
by calling mib_counters_update. As mib_counters_update is also called
from non-timer context, we should not reschedule the timer there but
rather move it to timer-only context.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 7197e0f..ae50dd6 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1273,15 +1273,13 @@ static void mib_counters_update(struct mv643xx_eth_private *mp)
 	p->rx_discard += rdlp(mp, RX_DISCARD_FRAME_CNT);
 	p->rx_overrun += rdlp(mp, RX_OVERRUN_FRAME_CNT);
 	spin_unlock_bh(&mp->mib_counters_lock);
-
-	mod_timer(&mp->mib_counters_timer, jiffies + 30 * HZ);
 }
 
 static void mib_counters_timer_wrapper(unsigned long _mp)
 {
 	struct mv643xx_eth_private *mp = (void *)_mp;
-
 	mib_counters_update(mp);
+	mod_timer(&mp->mib_counters_timer, jiffies + 30 * HZ);
 }
 
 
-- 
1.8.3.2

