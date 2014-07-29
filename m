Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaG2PKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:10:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59628 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbaG2PJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:09:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: Tyler Hall <tylerwhall@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Andre Naujoks <nautsch2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] slcan: Port write_wakeup deadlock fix from slip
Date: Tue, 29 Jul 2014 17:08:53 +0200
Message-Id: <1406646576-1299-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406646576-1299-1-git-send-email-jslaby@suse.cz>
References: <1406646576-1299-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hall <tylerwhall@gmail.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

[ Upstream commit a8e83b17536aad603fbeae4c460f2da0ee9fe6ed ]

The commit "slip: Fix deadlock in write_wakeup" fixes a deadlock caused
by a change made in both slcan and slip. This is a direct port of that
fix.

Signed-off-by: Tyler Hall <tylerwhall@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Andre Naujoks <nautsch2@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/slcan.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 25377e547f9b..3c28d1f187c0 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -54,6 +54,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/workqueue.h>
 #include <linux/can.h>
 #include <linux/can/skb.h>
 
@@ -87,6 +88,7 @@ struct slcan {
 	struct tty_struct	*tty;		/* ptr to TTY structure	     */
 	struct net_device	*dev;		/* easy for intr handling    */
 	spinlock_t		lock;
+	struct work_struct	tx_work;	/* Flushes transmit buffer   */
 
 	/* These are pointers to the malloc()ed frame buffers. */
 	unsigned char		rbuff[SLC_MTU];	/* receiver buffer	     */
@@ -311,34 +313,44 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	sl->dev->stats.tx_bytes += cf->can_dlc;
 }
 
-/*
- * Called by the driver when there's room for more data.  If we have
- * more packets to send, we send them here.
- */
-static void slcan_write_wakeup(struct tty_struct *tty)
+/* Write out any remaining transmit buffer. Scheduled when tty is writable */
+static void slcan_transmit(struct work_struct *work)
 {
+	struct slcan *sl = container_of(work, struct slcan, tx_work);
 	int actual;
-	struct slcan *sl = (struct slcan *) tty->disc_data;
 
+	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
+	if (!sl->tty || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev)) {
+		spin_unlock_bh(&sl->lock);
 		return;
+	}
 
-	spin_lock(&sl->lock);
 	if (sl->xleft <= 0)  {
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
-		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		spin_unlock(&sl->lock);
+		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+		spin_unlock_bh(&sl->lock);
 		netif_wake_queue(sl->dev);
 		return;
 	}
 
-	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
+	actual = sl->tty->ops->write(sl->tty, sl->xhead, sl->xleft);
 	sl->xleft -= actual;
 	sl->xhead += actual;
-	spin_unlock(&sl->lock);
+	spin_unlock_bh(&sl->lock);
+}
+
+/*
+ * Called by the driver when there's room for more data.
+ * Schedule the transmit.
+ */
+static void slcan_write_wakeup(struct tty_struct *tty)
+{
+	struct slcan *sl = tty->disc_data;
+
+	schedule_work(&sl->tx_work);
 }
 
 /* Send a can_frame to a TTY queue. */
@@ -524,6 +536,7 @@ static struct slcan *slc_alloc(dev_t line)
 	sl->magic = SLCAN_MAGIC;
 	sl->dev	= dev;
 	spin_lock_init(&sl->lock);
+	INIT_WORK(&sl->tx_work, slcan_transmit);
 	slcan_devs[i] = dev;
 
 	return sl;
@@ -622,8 +635,12 @@ static void slcan_close(struct tty_struct *tty)
 	if (!sl || sl->magic != SLCAN_MAGIC || sl->tty != tty)
 		return;
 
+	spin_lock_bh(&sl->lock);
 	tty->disc_data = NULL;
 	sl->tty = NULL;
+	spin_unlock_bh(&sl->lock);
+
+	flush_work(&sl->tx_work);
 
 	/* Flush network side */
 	unregister_netdev(sl->dev);
-- 
2.0.1

