Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935928Ab3DHJwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42996 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935892Ab3DHJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 082/102] bonding: get netdev_rx_handler_unregister out of locks
Date: Mon,  8 Apr 2013 10:50:37 +0100
Message-Id: <1365414657-29191-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit fcd99434fb5c137274d2e15dd2a6a7455f0f29ff upstream.

Now that netdev_rx_handler_unregister contains synchronize_net(), we need
to call it outside of bond->lock, cause it might sleep. Also, remove the
already unneded synchronize_net().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1b6e13d..1a6b118 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1965,12 +1965,11 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
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
-- 
1.8.1.2

