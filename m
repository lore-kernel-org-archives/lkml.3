Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3FDWoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35932 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab3FDWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:48 -0400
Message-Id: <20130604172134.247801384@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, Roland Dreier <roland@purestorage.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 095/184] IPoIB: Fix use-after-free of multicast object
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..f6a23ec 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -157,7 +157,7 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ipoib_ib_dev_down(dev, 0);
+	ipoib_ib_dev_down(dev, 1);
 	ipoib_ib_dev_stop(dev, 0);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 8763c1e..bd656a7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -188,7 +188,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 
 	mcast->mcmember = *mcmember;
 
-	/* Set the cached Q_Key before we attach if it's the broadcast group */
+	/* Set the multicast MTU and cached Q_Key before we attach if it's
+	 * the broadcast group.
+	 */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
 		spin_lock_irq(&priv->lock);
@@ -196,10 +198,17 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
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
@@ -588,14 +597,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
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
1.7.12.2.21.g234cd45.dirty



