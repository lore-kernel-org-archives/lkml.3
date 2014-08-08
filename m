Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbaHHVSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:18:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499AbaHHUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hall <tylerwhall@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Andre Naujoks <nautsch2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 231/259] slcan: Port write_wakeup deadlock fix from slip
Date: Fri,  8 Aug 2014 13:40:54 -0700
Message-Id: <1407530482-4483-232-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hall <tylerwhall@gmail.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/slcan.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 25377e5..3c28d1f 100644
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
1.9.1

