Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3KAW1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:27:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3KAWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:07:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 11/66] net: mv643xx_eth: fix orphaned statistics timer crash
Date: Fri,  1 Nov 2013 15:06:47 -0700
Message-Id: <20131101220637.892279391@linuxfoundation.org>
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

[ Upstream commit f564412c935111c583b787bcc18157377b208e2e ]

The periodic statistics timer gets started at port _probe() time, but
is stopped on _stop() only. In a modular environment, this can cause
the timer to access already deallocated memory, if the module is unloaded
without starting the eth device. To fix this, we add the timer right
before the port is started, instead of at _probe() time.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2235,6 +2235,7 @@ static int mv643xx_eth_open(struct net_d
 		mp->int_mask |= INT_TX_END_0 << i;
 	}
 
+	add_timer(&mp->mib_counters_timer);
 	port_start(mp);
 
 	wrlp(mp, INT_MASK_EXT, INT_EXT_LINK_PHY | INT_EXT_TX);
@@ -2914,7 +2915,6 @@ static int mv643xx_eth_probe(struct plat
 	mp->mib_counters_timer.data = (unsigned long)mp;
 	mp->mib_counters_timer.function = mib_counters_timer_wrapper;
 	mp->mib_counters_timer.expires = jiffies + 30 * HZ;
-	add_timer(&mp->mib_counters_timer);
 
 	spin_lock_init(&mp->mib_counters_lock);
 


