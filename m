Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaCEOiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaCEOhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 30/62] tg3: Fix deadlock in tg3_change_mtu()
Date: Wed,  5 Mar 2014 14:36:34 +0000
Message-Id: <1394030226-26652-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit c6993dfd7db9b0c6b7ca7503a56fda9236a4710f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3390b69..6dcd72a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12485,12 +12485,12 @@ static int tg3_change_mtu(struct net_device *dev, int new_mtu)
 
 	tg3_netif_stop(tp);
 
+	tg3_set_mtu(dev, tp, new_mtu);
+
 	tg3_full_lock(tp, 1);
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
 
-	tg3_set_mtu(dev, tp, new_mtu);
-
 	/* Reset PHY, otherwise the read DMA engine will be in a mode that
 	 * breaks all requests to 256 bytes.
 	 */
-- 
1.9.0

