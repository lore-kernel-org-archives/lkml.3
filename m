Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3JBK6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:58:35 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54224 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3JBK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:57:51 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: mv643xx_eth: update statistics timer from timer context only
Date: Wed,  2 Oct 2013 12:57:20 +0200
Message-Id: <1380711442-24735-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1380711442-24735-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1380711442-24735-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each port driver installs a periodic timer to update port statistics
by calling mib_counters_update. As mib_counters_update is also called
from non-timer context, we should not reschedule the timer there but
rather move it to timer-only context.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 7fb5677..44a87e4 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1131,15 +1131,13 @@ static void mib_counters_update(struct mv643xx_eth_private *mp)
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
1.7.10.4

