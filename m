Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbaE2N70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:59:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59460 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933432AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/103] slip: fix spinlock variant
Date: Thu, 29 May 2014 15:49:11 +0200
Message-Id: <742bc1c6e156d8f55a23f39f7c6ddfd3ede7daa7.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit ddcde142bed44490e338ed1124cb149976d355bb ]

With commit cc9fa74e2a ("slip/slcan: added locking in wakeup function") a
formerly missing locking was added to slip.c and slcan.c by Andre Naujoks.

Alexander Stein contributed the fix 367525c8c2 ("can: slcan: Fix spinlock
variant") as the kernel lock debugging advised to use spin_lock_bh() instead
of just using spin_lock().

This fix has to be applied to the same code section in slip.c for the same
reason too.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/slip/slip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index cc70ecfc7062..ad4a94e9ff57 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -429,13 +429,13 @@ static void slip_write_wakeup(struct tty_struct *tty)
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
 		return;
 
-	spin_lock(&sl->lock);
+	spin_lock_bh(&sl->lock);
 	if (sl->xleft <= 0)  {
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
 		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		spin_unlock(&sl->lock);
+		spin_unlock_bh(&sl->lock);
 		sl_unlock(sl);
 		return;
 	}
@@ -443,7 +443,7 @@ static void slip_write_wakeup(struct tty_struct *tty)
 	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
 	sl->xleft -= actual;
 	sl->xhead += actual;
-	spin_unlock(&sl->lock);
+	spin_unlock_bh(&sl->lock);
 }
 
 static void sl_tx_timeout(struct net_device *dev)
-- 
1.9.3

