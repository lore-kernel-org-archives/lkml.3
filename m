Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966530AbaFQVuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966494AbaFQVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/212] slip: fix spinlock variant
Date: Tue, 17 Jun 2014 14:42:09 -0700
Message-Id: <1403041506-13646-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/slip/slip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index cc70ecf..ad4a94e 100644
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
1.9.1

