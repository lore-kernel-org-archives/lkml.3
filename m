Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaBEUkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:40:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48358 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaBEUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Patrick McHardy <kaber@trash.net>, Roland Dreier <roland@purestorage.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 127/213] IPoIB: Fix use-after-free of multicast object
Date: Wed, 5 Feb 2014 15:01:22 -0500
Message-ID: <1391630568-49251-128-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bea1e22df494a729978e7f2c54f7bda328f74bc3 upstream.

Fix a crash in ipoib_mcast_join_task().  (with help from Or Gerlitz)

Commit c8c2afe360b7 ("IPoIB: Use rtnl lock/unlock when changing device
flags") added a call to rtnl_lock() in ipoib_mcast_join_task(), which
is run from the ipoib_workqueue, and hence the workqueue can't be
flushed from the context of ipoib_stop().

In the current code, ipoib_stop() (which doesn't flush the workqueue)
calls ipoib_mcast_dev_flush(), which goes and deletes all the
multicast entries.  This takes place without any synchronization with
a possible running instance of ipoib_mcast_join_task() for the same
ipoib device, leading to a crash due to NULL pointer dereference.

Fix this by making sure that the workqueue is flushed before
ipoib_mcast_dev_flush() is called.  To make that possible, we move the
RTNL-lock wrapped code to ipoib_mcast_join_finish().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b22576f12a..f6a23ecd982f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -157,7 +157,7 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ipoib_ib_dev_down(dev, 0);
+	ipoib_ib_dev_down(dev, 1);
 	ipoib_ib_dev_stop(dev, 0);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index b166bb75753d..917540c81260 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -189,7 +189,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 
 	mcast->mcmember = *mcmember;
 
-	/* Set the cached Q_Key before we attach if it's the broadcast group */
+	/* Set the multicast MTU and cached Q_Key before we attach if it's
+	 * the broadcast group.
+	 */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
 		spin_lock_irq(&priv->lock);
@@ -197,10 +199,17 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			spin_unlock_irq(&priv->lock);
 			return -EAGAIN;
 		}
+		priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
 		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 		set_qkey = 1;
+
+		if (!ipoib_cm_admin_enabled(dev)) {
+			rtnl_lock();
+			dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
+			rtnl_unlock();
+		}
 	}
 
 	if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
@@ -589,14 +598,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		return;
 	}
 
-	priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
-
-	if (!ipoib_cm_admin_enabled(dev)) {
-		rtnl_lock();
-		dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
-		rtnl_unlock();
-	}
-
 	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
 
 	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
-- 
1.8.5.2

