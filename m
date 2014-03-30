Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaC3Xnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbaC3Xni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Vrabel" <david.vrabel@citrix.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "Nithin Sujir" <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.46410175@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 188/200] tg3: Fix deadlock in tg3_change_mtu()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index d5793d3..266a4c7 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7103,12 +7103,12 @@ static int tg3_change_mtu(struct net_device *dev, int new_mtu)
 
 	tg3_netif_stop(tp);
 
+	tg3_set_mtu(dev, tp, new_mtu);
+
 	tg3_full_lock(tp, 1);
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
 
-	tg3_set_mtu(dev, tp, new_mtu);
-
 	err = tg3_restart_hw(tp, 0);
 
 	if (!err)

