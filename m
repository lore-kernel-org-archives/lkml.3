Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaCDUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaCDUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 045/172] tg3: Fix deadlock in tg3_change_mtu()
Date: Tue,  4 Mar 2014 12:02:09 -0800
Message-Id: <20140304200301.178835768@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13965,12 +13965,12 @@ static int tg3_change_mtu(struct net_dev
 
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


