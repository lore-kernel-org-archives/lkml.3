Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3KAW1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:27:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3KAWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:07:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 10/66] net: mv643xx_eth: update statistics timer from timer context only
Date: Fri,  1 Nov 2013 15:06:46 -0700
Message-Id: <20131101220637.633926411@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

[ Upstream commit 041b4ddb84989f06ff1df0ca869b950f1ee3cb1c ]

Each port driver installs a periodic timer to update port statistics
by calling mib_counters_update. As mib_counters_update is also called
from non-timer context, we should not reschedule the timer there but
rather move it to timer-only context.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1131,15 +1131,13 @@ static void mib_counters_update(struct m
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
 
 


