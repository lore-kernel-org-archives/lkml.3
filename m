Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620Ab3DGW56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:57:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46317 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758909Ab3DGWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@redhat.com>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.816443706@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [73/74] bonding: get netdev_rx_handler_unregister out of locks
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit fcd99434fb5c137274d2e15dd2a6a7455f0f29ff upstream.

Now that netdev_rx_handler_unregister contains synchronize_net(), we need
to call it outside of bond->lock, cause it might sleep. Also, remove the
already unneded synchronize_net().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1934,12 +1934,11 @@ int bond_release(struct net_device *bond
 		return -EINVAL;
 	}
 
+	write_unlock_bh(&bond->lock);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
 	netdev_rx_handler_unregister(slave_dev);
-	write_unlock_bh(&bond->lock);
-	synchronize_net();
 	write_lock_bh(&bond->lock);
 
 	if (!bond->params.fail_over_mac) {

